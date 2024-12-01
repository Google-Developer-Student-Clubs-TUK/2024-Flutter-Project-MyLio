package com.example.gdgocportfolio.dto;

import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.Data;

@Data
@JsonNaming
public class UserRegisterRequestDto {
	private String name;
	private String phoneNumber;
	private String email;
	private String password;
}
