package com.example.gdgocportfolio.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class UserLoginRequestDto {
	@Email(message = "Invalid email address")
	@Schema(description = "이메일", example = "test@naver.com")
	private String email;

	@Size(min = 8, message = "Password must be at least 8 characters long")
	@Schema(description = "아이디", example = "test")
	private String password;
}
