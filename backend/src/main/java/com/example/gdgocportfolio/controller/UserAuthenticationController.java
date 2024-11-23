package com.example.gdgocportfolio.controller;

import com.example.gdgocportfolio.dto.UserLoginRequestDTO;
import com.example.gdgocportfolio.dto.UserRegisterRequestDTO;
import com.example.gdgocportfolio.service.UserAuthenticationService;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/auth")
public class UserAuthenticationController {

	private final UserAuthenticationService userAuthenticationService;

	@Autowired
	public UserAuthenticationController(UserAuthenticationService userAuthenticationService) {
		this.userAuthenticationService = userAuthenticationService;
	}

	@PostMapping("/user")
	public void registerUser(@RequestBody UserRegisterRequestDTO requestDTO, HttpServletResponse res) {

	}

	@GetMapping("/login")
	public void login(@RequestHeader String email, @RequestHeader String password) {
		UserLoginRequestDTO userLoginRequestDTO = new UserLoginRequestDTO();
		userLoginRequestDTO.setEmail(email);
		userLoginRequestDTO.setPassword(password);

		userAuthenticationService.authenticateUser(userLoginRequestDTO);
	}
}
