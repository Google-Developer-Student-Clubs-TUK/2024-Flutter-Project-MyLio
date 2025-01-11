package com.example.gdgocportfolio.entity;

import com.example.gdgocportfolio.authorization.AuthorizationAbstract;
import jakarta.persistence.*;
import lombok.Data;
import org.springframework.validation.annotation.Validated;

import java.util.List;
import java.util.Set;

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

	@ElementCollection
//	@Transient
	private Set<String> permissions;

	private boolean enabled;
}
