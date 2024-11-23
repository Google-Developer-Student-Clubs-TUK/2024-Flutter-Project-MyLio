package com.example.gdgocportfolio.dto;

import lombok.Data;

@Data
public class UserRegisterRequestDTO {
	private String name;
	private String phoneNumber;
	private String email;
	private String password;
}
