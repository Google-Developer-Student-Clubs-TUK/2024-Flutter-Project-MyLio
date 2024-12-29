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
@Table(name = "coverLetter", indexes = {
		@Index(columnList = "coverLetterId"),
		@Index(columnList = "userId")
})
public class CoverLetter {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long coverLetterId;

	@Column(nullable = false)
	private Long userId;

	private String data; // 역정규화, json data

	@CreatedDate
	private LocalDateTime createTime;
	@LastModifiedDate
	private LocalDateTime lastUpdateTime;
}
