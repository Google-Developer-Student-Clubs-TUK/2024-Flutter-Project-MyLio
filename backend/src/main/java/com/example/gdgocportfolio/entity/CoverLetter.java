package com.example.gdgocportfolio.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

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

	@Column(nullable = false, length = 200)
	private String title; // 제목

	@OneToMany(mappedBy = "coverLetter", cascade = CascadeType.ALL, orphanRemoval = true)
	private List<QuestionAnswer> questionAnswers = new ArrayList<>();

	@CreatedDate
	private LocalDateTime createTime;

	@LastModifiedDate
	private LocalDateTime lastUpdateTime;

}
