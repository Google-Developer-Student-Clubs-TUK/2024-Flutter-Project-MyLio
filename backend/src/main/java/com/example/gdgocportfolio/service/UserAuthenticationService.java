package com.example.gdgocportfolio.service;

import com.example.gdgocportfolio.dto.UserJwtInfoDto;
import com.example.gdgocportfolio.dto.UserLoginRequestDto;
import com.example.gdgocportfolio.dto.UserRegisterRequestDto;
import com.example.gdgocportfolio.entity.User;
import com.example.gdgocportfolio.entity.UserAuthentication;
import com.example.gdgocportfolio.exceptions.IncorrectPasswordException;
import com.example.gdgocportfolio.exceptions.UserExistsDataException;
import com.example.gdgocportfolio.exceptions.UserExistsWithPhoneNumberDataException;
import com.example.gdgocportfolio.repository.UserAuthenticationRepository;
import com.example.gdgocportfolio.repository.UserRepository;
import com.example.gdgocportfolio.util.HashConvertor;
import com.example.gdgocportfolio.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;
import java.util.Set;

@Service
public class UserAuthenticationService {

	private final UserRepository userRepository;
	private final UserAuthenticationRepository userAuthenticationRepository;
	private final HashConvertor hashConvertor;
	private final JwtUtil jwtUtil;

	@Autowired
	public UserAuthenticationService(UserRepository userRepository, UserAuthenticationRepository userAuthenticationRepository, HashConvertor hashConvertor, JwtUtil jwtUtil) {
		this.userRepository = userRepository;
		this.userAuthenticationRepository = userAuthenticationRepository;
		this.hashConvertor = hashConvertor;
		this.jwtUtil = jwtUtil;
	}

	public UserJwtInfoDto verifyUserJwtToken(String jwtToken) {
		Map<String, String> result = jwtUtil.parseJwtToken(jwtToken, Set.of("email", "userId"));
		return new UserJwtInfoDto(result.get("email"), result.get("userId"));
	}

	/**
	 * @return Return JWT token if user is authenticated, otherwise return null.
	 * @throws IncorrectPasswordException if password is incorrect
	 * @throws IllegalArgumentException if user is not found
	 */
	public String generateUserJwtToken(UserLoginRequestDto userLoginRequestDto) {
		UserAuthentication userAuthentication = userAuthenticationRepository.findByEmail(userLoginRequestDto.getEmail());
		if (userAuthentication == null) {
			throw new IllegalArgumentException("User not found");
		}

		if (userAuthentication.getPassword().equals(hashConvertor.convertToHash(userLoginRequestDto.getPassword()))) {
			return jwtUtil.generateJwtToken(
					Map.of(
							"email", userAuthentication.getEmail(),
							"userId", userAuthentication.getUserId().toString()
					));
		}
		throw new IncorrectPasswordException();
	}

	@Transactional
	public void registerUser(UserRegisterRequestDto requestDTO) {
		UserAuthentication authenticationInfo = userAuthenticationRepository.findByEmail(requestDTO.getEmail());
		if (authenticationInfo != null) throw new UserExistsDataException();

		User user = userRepository.findByPhoneNumber(requestDTO.getPhoneNumber());
		if (user != null) throw new UserExistsWithPhoneNumberDataException();

		user = new User();
		user.setPhoneNumber(requestDTO.getPhoneNumber());
		user.setName(requestDTO.getName());
		userRepository.save(user);

		UserAuthentication userAuthentication = new UserAuthentication();
		userAuthentication.setUserId(user.getUserId());
		userAuthentication.setEmail(requestDTO.getEmail());
		userAuthentication.setPassword(hashConvertor.convertToHash(requestDTO.getPassword()));
		userAuthentication.setEnabled(true);
		userAuthenticationRepository.save(userAuthentication);
	}
}
