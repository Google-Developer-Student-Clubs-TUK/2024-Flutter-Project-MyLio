package com.example.gdgocportfolio.service;

import com.example.gdgocportfolio.entity.User;
import com.example.gdgocportfolio.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserService {

    private final UserRepository userRepository;

    @Autowired
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    // User 조회 (ID 기준)
    public Optional<User> findById(Long userId) {
        return userRepository.findById(userId);
    }
}
