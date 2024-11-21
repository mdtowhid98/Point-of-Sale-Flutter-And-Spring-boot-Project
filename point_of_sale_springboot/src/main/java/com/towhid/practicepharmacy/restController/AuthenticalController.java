package com.towhid.practicepharmacy.restController;

import com.towhid.practicepharmacy.entity.AuthenticationResponse;
import com.towhid.practicepharmacy.entity.Branch;
import com.towhid.practicepharmacy.entity.Category;
import com.towhid.practicepharmacy.entity.User;
import com.towhid.practicepharmacy.service.AuthService;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@AllArgsConstructor
@CrossOrigin(origins = "http://localhost:4200/")
public class AuthenticalController {

    private final AuthService authService;




    @PostMapping("/register")
    public ResponseEntity<AuthenticationResponse> register(
            @RequestBody User request
    ) {
        return ResponseEntity.ok(authService.register(request));
    }

    @PostMapping("/register/admin")
    public ResponseEntity<AuthenticationResponse> registerAdmin(
            @RequestBody User request
    ) {
        return ResponseEntity.ok(authService.registerAdmin(request));
    }

    @PostMapping("/register/pharmacist")
    public ResponseEntity<AuthenticationResponse> registerPharmacist(
            @RequestBody User request
    ) {
        return ResponseEntity.ok(authService.registerPharmacist(request));
    }


    @PostMapping("/login")
    public ResponseEntity<AuthenticationResponse> login(
            @RequestBody User request
    ) {
        return ResponseEntity.ok(authService.authenticate(request));
    }


    @GetMapping("/activate/{id}")
    public ResponseEntity<String> activateUser(@PathVariable("id") int id) {
        String response = authService.activateUser(id);
        return ResponseEntity.ok(response);
    }


}
