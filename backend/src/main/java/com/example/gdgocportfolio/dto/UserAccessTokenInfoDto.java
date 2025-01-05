package com.example.gdgocportfolio.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.List;

@Data
public class UserAccessTokenInfoDto {
	@Schema(description = "이메일", example = "test@naver.com")
	private final String email;
	@Schema(description = "아이디", example = "123")
	private final String userId;
	private final List<String> permissions;
}
