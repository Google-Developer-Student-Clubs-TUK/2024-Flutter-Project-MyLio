package com.example.gdgocportfolio.controller;

import com.example.gdgocportfolio.dto.UserLoginRequestDto;
import com.example.gdgocportfolio.dto.UserRegisterRequestDto;
import com.example.gdgocportfolio.dto.UserRegisterResponseDto;
import com.example.gdgocportfolio.exceptions.IncorrectPasswordException;
import com.example.gdgocportfolio.exceptions.UserExistsDataException;
import com.example.gdgocportfolio.service.UserAuthenticationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.Valid;
import jakarta.validation.Validator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.Set;

@RestController
@Tag(name = "회원")
@RequestMapping("/api/v1/auth/user")
public class UserAuthenticationController {

	private final UserAuthenticationService userAuthenticationService;
	private final Validator validator;

	@Autowired
	public UserAuthenticationController(UserAuthenticationService userAuthenticationService, Validator validator) {
		this.userAuthenticationService = userAuthenticationService;
		this.validator = validator;
	}

	@PostMapping
	@Operation(summary = "회원가입")
	public ResponseEntity<UserRegisterResponseDto> registerUser(@RequestBody @Valid UserRegisterRequestDto requestDTO) throws URISyntaxException {
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
	@GetMapping
	@Operation(summary = "로그인")
	@ResponseStatus(HttpStatus.OK)
	public void login(@RequestHeader("email") String email, @RequestHeader("pw") String password, HttpServletResponse res) {
		UserLoginRequestDto userLoginRequestDto = new UserLoginRequestDto();
		userLoginRequestDto.setEmail(email);
		userLoginRequestDto.setPassword(password);

		Set<ConstraintViolation<UserLoginRequestDto>> violation = validator.validate(userLoginRequestDto);
		if (!violation.isEmpty()) {
			String message = violation.stream()
					.map(ConstraintViolation::getMessage)
					.findFirst()
					.orElse("Invalid request");
			throw new IllegalArgumentException(message);
		}

		res.addHeader("Set-Cookie", "token=" + userAuthenticationService.generateUserJwtToken(userLoginRequestDto));
	}

	@ExceptionHandler(MethodArgumentNotValidException.class)
	public ResponseEntity<String> handleMethodArgumentNotValidException(MethodArgumentNotValidException e) {
		return ResponseEntity
				.badRequest()
				.body(e.getBindingResult().getFieldError().getDefaultMessage());
	}

	@ExceptionHandler(IllegalArgumentException.class)
	public ResponseEntity<String> handleIllegalArgumentException(IllegalArgumentException e) {

		return ResponseEntity
				.badRequest()
				.body(e.getMessage());
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

	@ExceptionHandler(UserExistsDataException.class)
	public ResponseEntity<String> handleUserExistsDataException(UserExistsDataException e) {
		return ResponseEntity
				.badRequest()
				.body("User already exists");
	}
}
