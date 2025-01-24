package com.example.gdgocportfolio.service;

import com.example.gdgocportfolio.dto.UserDto;
import com.example.gdgocportfolio.dto.UserEditRequestDto;
import com.example.gdgocportfolio.entity.User;
import com.example.gdgocportfolio.entity.UserAuthentication;
import com.example.gdgocportfolio.exceptions.UserNotExistsException;
import com.example.gdgocportfolio.repository.UserAuthenticationRepository;
import com.example.gdgocportfolio.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
public class UserService {

	private final UserRepository userRepository;
	private final UserAuthenticationRepository userAuthenticationRepository;

	public UserService(UserRepository userRepository, UserAuthenticationRepository userAuthenticationRepository) {
		this.userRepository = userRepository;
		this.userAuthenticationRepository = userAuthenticationRepository;
	}

	@Transactional
	public void edit(final UserEditRequestDto dto) {
		User user = userRepository.findById(dto.getUserId()).orElseThrow(UserNotExistsException::new);
		if (dto.getName() != null) user.setName(dto.getName());
		if (dto.getPhoneNumber() != null) user.setPhoneNumber(dto.getPhoneNumber());
	}
  
    // User 조회 (ID 기준)
    public Optional<User> findById(Long userId) {
        return userRepository.findById(userId);
    }

	@Transactional
	public UserDto getInfo(Long userId) {
		User user = this.findById(userId).orElseThrow(UserNotExistsException::new);
		UserAuthentication userAuthentication = userAuthenticationRepository.findById(userId).orElseThrow(UserNotExistsException::new);
		return new UserDto(user.getName(), user.getPhoneNumber(), userAuthentication.getEmail());
	}
}
