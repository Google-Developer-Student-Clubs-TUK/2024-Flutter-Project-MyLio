package com.example.gdgocportfolio.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.annotation.Nullable;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class UserEditRequestDto {
	@NotNull
	private Long userId;

//	@Nullable
	@Size(min = 2, max = 64, message = "Name must be between 2 and 64 characters")
	@Schema(description = "이름", example = "홍길동")
	private String name;

//	@Nullable
	@Pattern(regexp = "^\\d{3}-\\d{3,4}-\\d{4}$", message = "Invalid phone number")
	@Schema(description = "휴대폰번호", example = "010-1234-5678")
	private String phoneNumber;
}
