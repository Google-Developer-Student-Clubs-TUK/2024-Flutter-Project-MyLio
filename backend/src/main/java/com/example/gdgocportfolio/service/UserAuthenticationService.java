package com.example.gdgocportfolio.service;

import com.example.gdgocportfolio.dto.UserLoginRequestDTO;
import com.example.gdgocportfolio.dto.UserRegisterRequestDTO;
import com.example.gdgocportfolio.entity.User;
import com.example.gdgocportfolio.entity.UserAuthentication;
import com.example.gdgocportfolio.repository.UserAuthenticationRepository;
import com.example.gdgocportfolio.repository.UserRepository;
import com.example.gdgocportfolio.util.HashConvertor;
import io.jsonwebtoken.JwtBuilder;
import io.jsonwebtoken.Jwts;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserAuthenticationService {

	private final UserRepository userRepository;
	private final UserAuthenticationRepository userAuthenticationRepository;
	private final HashConvertor hashConvertor;

	@Autowired
	public UserAuthenticationService(UserRepository userRepository, UserAuthenticationRepository userAuthenticationRepository, HashConvertor hashConvertor) {
		this.userRepository = userRepository;
		this.userAuthenticationRepository = userAuthenticationRepository;
		this.hashConvertor = hashConvertor;
	}

	/**
	 * @return Return JWT token if user is authenticated, otherwise return null.
	 */
	public String authenticateUser(UserLoginRequestDTO userLoginRequestDTO) {
		UserAuthentication userAuthentication = userAuthenticationRepository.findByEmail(userLoginRequestDTO.getEmail());
		if (userAuthentication == null) {
			return null;
		}
		if (userAuthentication.getPassword().equals(hashConvertor.convertToHash(userLoginRequestDTO.getPassword()))) {

			return "JWT token"; // TODO : return JWT token
		}
		return null;
	}

	@Transactional
	public void registerUser(UserRegisterRequestDTO requestDTO) {
		User user = new User();
		userRepository.save(user);

		UserAuthentication userAuthentication = new UserAuthentication();
		userAuthentication.setUserId(user.getUserId());
		userAuthentication.setEmail(requestDTO.getEmail());
		userAuthentication.setPassword(hashConvertor.convertToHash(requestDTO.getPassword()));
		userAuthentication.setEnabled(true);
		userAuthenticationRepository.save(userAuthentication);
	}
}
