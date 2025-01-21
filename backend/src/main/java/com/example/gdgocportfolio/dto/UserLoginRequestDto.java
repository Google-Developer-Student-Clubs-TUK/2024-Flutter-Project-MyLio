package com.example.gdgocportfolio.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserLoginRequestDto {
	@NotNull
	@Email(message = "Invalid email address")
	@Schema(description = "이메일", example = "test@naver.com")
	private String email;

	@NotNull
	@Size(min = 8, message = "Password must be at least 8 characters long")
	@Pattern(regexp = "^[A-Za-z0-9]+")
	@Schema(description = "아이디", example = "123")
	private String password;
}
