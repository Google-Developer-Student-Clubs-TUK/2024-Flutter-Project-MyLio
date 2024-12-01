package com.example.gdgocportfolio.dto;

import com.fasterxml.jackson.databind.annotation.JsonNaming;

@JsonNaming
public class UserRegisterResponseDto_ {
	private String message;

	public UserRegisterResponseDto_(String message) {
		this.message = message;
	}
}
