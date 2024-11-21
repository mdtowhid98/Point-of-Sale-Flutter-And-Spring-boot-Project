package com.towhid.practicepharmacy.service;

import com.towhid.practicepharmacy.entity.AuthenticationResponse;
import com.towhid.practicepharmacy.entity.Role;
import com.towhid.practicepharmacy.entity.Token;
import com.towhid.practicepharmacy.entity.User;
import com.towhid.practicepharmacy.jwt.JwtService;
import com.towhid.practicepharmacy.repository.TokenRepository;
import com.towhid.practicepharmacy.repository.UserRepository;
import jakarta.mail.MessagingException;
import lombok.AllArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final TokenRepository tokenRepository;
    private final AuthenticationManager authenticationManager;
    private final EmailService emailService;

    private void saveUserToken(String jwt, User user) {
        Token token = new Token();
        token.setToken(jwt);
        token.setLoggedOut(false);
        token.setUser(user);

        tokenRepository.save(token);
    }


    private void revokeAllTokenByUser(User user) {

        List<Token> validTokens = tokenRepository.findAllTokensByUser(user.getId());
        if(validTokens.isEmpty()) {
            return;
        }

        // Set all valid tokens for the user to logged out
        validTokens.forEach(t-> {
            t.setLoggedOut(true);
        });

        // Save the changes to the tokens in the token repository
        tokenRepository.saveAll(validTokens);
    }

    public AuthenticationResponse register(User user) {

        // Check if the user already exists
        if(userRepository.findByEmail(user.getUsername()).isPresent()) {
            return new AuthenticationResponse(null, "User already exists");
        }

        // Create a new user entity and save it to the database
//        User user = new User();
//        user.setName(user.getName());
//        user.setEmail(user.getEmail());
        user.setPassword(passwordEncoder.encode(user.getPassword()));
//
        user.setRole(Role.valueOf("USER"));
//        user.setLock(true);
        user.setActive(false);
        userRepository.save(user);

        // Generate JWT token for the newly registered user
        String jwt = jwtService.generateToken(user);

        // Save the token to the token repository
        saveUserToken(jwt, user);
        sendActivationEmail(user);

        return new AuthenticationResponse(jwt, "User registration was successful");
    }

    public AuthenticationResponse registerAdmin(User user) {

        // Check if the user already exists
        if (userRepository.findByEmail(user.getUsername()).isPresent()) {
            return new AuthenticationResponse(null, "User already exists");
        }

        // Create a new user entity and save it to the database

        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setRole(Role.valueOf("ADMIN"));
//        user.setLock(true);
        user.setActive(false);

        userRepository.save(user);

        // Generate JWT token for the newly registered user
        String jwt = jwtService.generateToken(user);

        // Save the token to the token repository
        saveUserToken(jwt, user);
        sendActivationEmail(user);

        return new AuthenticationResponse(jwt, "User registration was successful");
    }

    public AuthenticationResponse registerPharmacist(User user) {

        // Check if the user already exists
        if (userRepository.findByEmail(user.getUsername()).isPresent()) {
            return new AuthenticationResponse(null, "User already exists");
        }

        // Create a new user entity and save it to the database

        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setRole(Role.valueOf("PHARMACIST"));
//        user.setLock(false);
        user.setActive(false);

        userRepository.save(user);

        // Generate JWT token for the newly registered user
        String jwt = jwtService.generateToken(user);

        // Save the token to the token repository
        saveUserToken(jwt, user);
        sendActivationEmail(user);

        return new AuthenticationResponse(jwt, "User registration was successful");
    }

    // Method to authenticate a user
    public AuthenticationResponse authenticate(User request) {

        // Authenticate user credentials using Spring Security's AuthenticationManager
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getUsername(),
                        request.getPassword()
                )
        );

        // Retrieve the user from the database
        User user = userRepository.findByEmail(request.getUsername()).orElseThrow();

        // Generate JWT token for the authenticated user
        String jwt = jwtService.generateToken(user);

        // Revoke all existing tokens for this user
        revokeAllTokenByUser(user);

        // Save the new token to the token repository
        saveUserToken(jwt, user);


        return new AuthenticationResponse(jwt, "User login was successful");
    }


    private void sendActivationEmail(User user) {
        String activationLink = "http://localhost:8087/activate/" + user.getId();

        String mailText = "<h3>Dear " + user.getName()
                + ",</h3>"
                + "<p>Please click on the following link to confirm your account:</p>"
                + "<a href=\"" + activationLink + "\">Activate Account</a>"
                + "<br><br>Regards,<br>Pharmacy";

        String subject = "Confirm User Account";

        try {

            emailService.sendSimpleEmail(user.getEmail(), subject, mailText);

        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }


    }

    // Activate user based on the token
    public String activateUser(long id) {

        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not Found with this ID"));

        if (user != null) {

            user.setActive(true);
            //  user.setActivationToken(null); // Clear token after activation
            userRepository.save(user);
            return "User activated successfully!";
        } else {
            return "Invalid activation token!";
        }
    }



}
