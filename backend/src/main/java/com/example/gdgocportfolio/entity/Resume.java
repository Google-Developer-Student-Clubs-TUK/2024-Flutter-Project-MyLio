package com.example.gdgocportfolio.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;

import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "resume", indexes = {
		@Index(columnList = "resumeId"),
		@Index(columnList = "userId")
})
public class Resume {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long resumeId;

	@Column(nullable = false)
	private Long userId;

	private String data; // 역정규화, json data

	@CreatedDate
	private LocalDateTime createTime;
	@LastModifiedDate
	private LocalDateTime lastUpdateTime;
}
