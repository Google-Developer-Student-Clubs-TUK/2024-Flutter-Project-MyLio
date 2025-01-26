package com.example.gdgocportfolio.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class UserEditPasswordDto {
	@NotNull
	private Long userId;
	@NotNull
	@Size(min = 8, message = "Password must be at least 8 characters long")
	private String password;
}
