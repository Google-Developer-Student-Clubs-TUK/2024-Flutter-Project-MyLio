package com.example.gdgocportfolio.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class UserJwtInfoDto {
	@Schema(description = "이메일", example = "test@naver.com")
	private final String email;
	@Schema(description = "아이디", example = "test")
	private final String userId;
}
