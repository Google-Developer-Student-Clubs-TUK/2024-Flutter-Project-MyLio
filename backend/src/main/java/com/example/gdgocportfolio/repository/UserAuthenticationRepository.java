package com.example.gdgocportfolio.repository;

import com.example.gdgocportfolio.entity.UserAuthentication;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserAuthenticationRepository extends JpaRepository<UserAuthentication, Long> {
	Optional<UserAuthentication> findByEmailEquals(String email);
}
