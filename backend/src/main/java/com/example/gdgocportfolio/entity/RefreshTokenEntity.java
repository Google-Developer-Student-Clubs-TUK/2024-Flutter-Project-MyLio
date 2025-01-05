package com.example.gdgocportfolio.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
public class RefreshTokenEntity {
	@Id
	@Column(columnDefinition = "BINARY(16)")
	private UUID uuid;
	@Column(nullable = false)
	private Long userId;
	@Column(nullable = false)
	private Long expire;
}
