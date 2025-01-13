package com.example.gdgocportfolio.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.UUID;

@Data
@AllArgsConstructor
public class UserRefreshTokenInfoDto {
	private final UUID uuid;
	private final Long userId;
}
