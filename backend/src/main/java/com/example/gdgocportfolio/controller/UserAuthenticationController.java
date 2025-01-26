package com.example.gdgocportfolio.controller;

import com.example.gdgocportfolio.dto.*;
import com.example.gdgocportfolio.exceptions.*;
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

import java.net.URISyntaxException;
import java.util.Set;

@RestController
@Tag(name = "회원")
@RequestMapping("/api/v1/auth/user")
@Tag(name = "회원")
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
	@ResponseStatus(HttpStatus.CREATED)
	public String registerUser(@RequestBody @Valid UserRegisterRequestDto requestDTO) throws URISyntaxException {
		userAuthenticationService.registerUser(requestDTO);
		return "User registered successfully";
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

		UserJwtDto userJwtDto = userAuthenticationService.generateUserJwtToken(userLoginRequestDto);

		res.addHeader("Set-Cookie", "ACCESS_TOKEN=" + userJwtDto.getAccessToken());
		res.addHeader("Set-Cookie", "REFRESH_TOKEN=" + userJwtDto.getRefreshToken());
	}

	@DeleteMapping
	@ResponseStatus(HttpStatus.OK)
	public void delete(@RequestHeader("user_id") Long userId, UserAccessTokenInfoDto accessToken) {
		if (!Long.valueOf(accessToken.getUserId()).equals(userId)) throw new UnauthorizedException("User id is difference (" + userId + ", " + accessToken.getUserId() + ")");
		userAuthenticationService.deleteUser(userId);
	}

	@PatchMapping
	public void editPassword(@RequestBody @Valid UserEditPasswordDto userEditPasswordDto, UserAccessTokenInfoDto accessToken) {
		if (!Long.valueOf(accessToken.getUserId()).equals(userEditPasswordDto.getUserId())) throw new UnauthorizedException("User id is difference (" + userEditPasswordDto.getUserId() + ", " + accessToken.getUserId() + ")");
		userAuthenticationService.editPassword(userEditPasswordDto);
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

//	@ExceptionHandler(IncorrectPasswordException.class)
//	public ResponseEntity<String> handleIncorrectPasswordException(IncorrectPasswordException e) {
//		return ResponseEntity
//				.badRequest()
//				.body("Incorrect password");
//	}

	@ExceptionHandler(URISyntaxException.class)
	public ResponseEntity<String> handleURISyntaxException(URISyntaxException e) {
		return ResponseEntity
				.internalServerError()
				.body("URI syntax error");
	}

//	@ExceptionHandler(UserExistsException.class)
//	public ResponseEntity<String> handleUserExistsDataException(UserExistsException e) {
//		return ResponseEntity
//				.badRequest()
//				.body("User already exists");
//	}
//
//	@ExceptionHandler(UserExistsWithPhoneNumberException.class)
//	public String userExistsWithPhoneNumberDataException(UserExistsWithPhoneNumberException e) {
//		return "Phone number already used";
//	}
}
