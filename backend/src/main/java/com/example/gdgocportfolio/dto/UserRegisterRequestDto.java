package com.example.gdgocportfolio.dto;

import com.fasterxml.jackson.databind.annotation.JsonNaming;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
@JsonNaming
public class UserRegisterRequestDto {
	@NotNull
	@Size(min = 2, max = 64, message = "Name must be between 2 and 64 characters")
	@Schema(description = "이름", example = "홍길동")
	private String name;

	@NotNull
	@Pattern(regexp = "^\\d{3}-\\d{3,4}-\\d{4}$", message = "Invalid phone number")
	@Schema(description = "휴대폰번호", example = "010-1234-5678")
	private String phoneNumber;

	@NotNull
	@Email(message = "Invalid email address")
	@Schema(description = "이메일", example = "abc@gmail.com")
	private String email;

	@NotNull
	@Pattern(regexp = "^[A-Za-z0-9]+")
	@Size(min = 8, message = "Password must be at least 8 characters long")
	@Schema(description = "비밀번호", example = "12345678")
	private String password;
}
