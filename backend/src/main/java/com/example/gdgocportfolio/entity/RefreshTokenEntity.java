package com.example.gdgocportfolio.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(indexes = {@Index(name = "index_expire", columnList = "expire")})
public class RefreshTokenEntity {
	@Id
	@Column(columnDefinition = "BINARY(16)")
	private UUID uuid;
	@Column(nullable = false)
	private Long userId;
	@Column(nullable = false)
	private Long expire;
}
