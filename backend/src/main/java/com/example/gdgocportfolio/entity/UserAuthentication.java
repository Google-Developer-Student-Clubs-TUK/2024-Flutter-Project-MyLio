package com.example.gdgocportfolio.entity;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "user_authentication", indexes = {
		@Index(columnList = "userId"),
		@Index(columnList = "email")
})
public class UserAuthentication {
	@Id
	private Long userId;

	@Column(nullable = false, unique = true)
	private String email;
	@Column(nullable = false)
	private String password;

	private boolean enabled;
}
