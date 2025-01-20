package com.example.gdgocportfolio.service;

import com.example.gdgocportfolio.dto.UserEditRequestDto;
import com.example.gdgocportfolio.entity.User;
import com.example.gdgocportfolio.exceptions.UserNotExistsException;
import com.example.gdgocportfolio.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserService {

	private final UserRepository userRepository;

	public UserService(UserRepository userRepository) {
		this.userRepository = userRepository;
	}

	@Transactional
	public void edit(final UserEditRequestDto dto) {
		User user = userRepository.findById(dto.getUserId()).orElseThrow(UserNotExistsException::new);
		if (dto.getName() != null) user.setName(dto.getName());
		if (dto.getPhoneNumber() != null) user.setPhoneNumber(dto.getPhoneNumber());
	}
}
