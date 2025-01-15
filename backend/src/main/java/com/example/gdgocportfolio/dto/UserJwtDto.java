package com.example.gdgocportfolio.dto;

import lombok.Data;

@Data
public class UserJwtDto {
	private final String accessToken;
	private final String refreshToken;
}
