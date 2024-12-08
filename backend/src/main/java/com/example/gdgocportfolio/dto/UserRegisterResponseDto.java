package com.example.gdgocportfolio.dto;

import com.fasterxml.jackson.databind.annotation.JsonNaming;

@JsonNaming
public class UserRegisterResponseDto {
	private String message;

	public UserRegisterResponseDto(String message) {
		this.message = message;
	}
}
