package com.example.gdgocportfolio.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class UserLoginRequestDto {
	@Schema(description = "이메일", example = "test@naver.com")
	private String email;
	@Schema(description = "아이디", example = "test")
	private String password;

}
