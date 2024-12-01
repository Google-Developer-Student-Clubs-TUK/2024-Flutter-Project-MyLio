package com.example.gdgocportfolio.controller;

import com.example.gdgocportfolio.dto.UserLoginRequestDto;
import com.example.gdgocportfolio.dto.UserRegisterRequestDto;
import com.example.gdgocportfolio.dto.UserRegisterResponseDto;
import com.example.gdgocportfolio.exceptions.IncorrectPasswordException;
import com.example.gdgocportfolio.service.UserAuthenticationService;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.net.URISyntaxException;

@RestController
@RequestMapping("/api/v1/auth")
public class UserAuthenticationController {

	private final UserAuthenticationService userAuthenticationService;

	@Autowired
	public UserAuthenticationController(UserAuthenticationService userAuthenticationService) {
		this.userAuthenticationService = userAuthenticationService;
	}

	@PostMapping("/register")
	public ResponseEntity<UserRegisterResponseDto> registerUser(@RequestBody UserRegisterRequestDto requestDTO) throws URISyntaxException {
		userAuthenticationService.registerUser(requestDTO);
		return ResponseEntity
				.created(new URI("/api/v1/login"))
				.body(new UserRegisterResponseDto("User registered successfully"));
	}

	/**
	 * Returns a JWT token
	 * @param email user email
	 * @param password user password
	 */
	@GetMapping("/login")
	@ResponseStatus(HttpStatus.OK)
	public void login(@RequestHeader String email, @RequestHeader String password, HttpServletResponse res) {
		UserLoginRequestDto userLoginRequestDto = new UserLoginRequestDto();
		userLoginRequestDto.setEmail(email);
		userLoginRequestDto.setPassword(password);

		res.addHeader("Set-Cookie", "token=" + userAuthenticationService.generateUserJwtToken(userLoginRequestDto));
	}

	@ExceptionHandler(IllegalArgumentException.class)
	public ResponseEntity<String> handleIllegalArgumentException(IllegalArgumentException e) {
		return ResponseEntity
				.badRequest()
				.body("User not found");
	}

	@ExceptionHandler(IncorrectPasswordException.class)
	public ResponseEntity<String> handleIncorrectPasswordException(IncorrectPasswordException e) {
		return ResponseEntity
				.badRequest()
				.body("Incorrect password");
	}

	@ExceptionHandler(URISyntaxException.class)
	public ResponseEntity<String> handleURISyntaxException(URISyntaxException e) {
		return ResponseEntity
				.internalServerError()
				.body("URI syntax error");
	}
}
