package com.example.gdgocportfolio.dto;

import com.fasterxml.jackson.databind.annotation.JsonNaming;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@JsonNaming
public class UserRegisterRequestDto {
	@Schema(description = "이름", example = "홍길동")
	private String name;
	@Schema(description = "휴대폰번호", example = "010-1234-5678")
	private String phoneNumber;
	@Schema(description = "이메일", example = "test@naver.com")
	private String email;
	@Schema(description = "비밀번호", example = "test123")
	private String password;
}
