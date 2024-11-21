package com.towhid.practicepharmacy.repository;

import com.towhid.practicepharmacy.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository

public interface UserRepository extends JpaRepository<User,Long> {

    Optional<User> findByEmail(String email);
}
