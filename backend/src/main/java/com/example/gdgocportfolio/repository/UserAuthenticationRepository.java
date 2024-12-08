package com.example.gdgocportfolio.repository;

import com.example.gdgocportfolio.entity.UserAuthentication;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserAuthenticationRepository extends JpaRepository<UserAuthentication, Long> {
	UserAuthentication findByEmail(String email);
}
