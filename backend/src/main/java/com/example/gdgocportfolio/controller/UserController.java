package com.example.gdgocportfolio.controller;

import com.example.gdgocportfolio.dto.UserAccessTokenInfoDto;
import com.example.gdgocportfolio.dto.UserEditRequestDto;
import com.example.gdgocportfolio.exceptions.UnauthorizedException;
import com.example.gdgocportfolio.exceptions.UserNotExistsException;
import com.example.gdgocportfolio.service.UserService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/user")
public class UserController {

	private final UserService userService;

	public UserController(UserService userService) {
		this.userService = userService;
	}

	@PutMapping
	@ResponseStatus(HttpStatus.OK)
	public void edit(@Valid @RequestBody UserEditRequestDto dto, UserAccessTokenInfoDto accessToken) {
		if (!Long.valueOf(accessToken.getUserId()).equals(dto.getUserId())) throw new UnauthorizedException();
		this.userService.edit(dto);
	}

	@ExceptionHandler(UserNotExistsException.class)
	@ResponseStatus(HttpStatus.BAD_REQUEST)
	public String userNotExistsException(UserNotExistsException e) {
		return "No user";
	}

	@ExceptionHandler(NumberFormatException.class)
	@ResponseStatus(HttpStatus.BAD_REQUEST)
	public void numberFormatException(NumberFormatException e) {
	}

	@ExceptionHandler(UnauthorizedException.class)
	@ResponseStatus(HttpStatus.UNAUTHORIZED)
	public String unauthorizedException(UnauthorizedException e) {
		return "Invalid user id";
	}
}
