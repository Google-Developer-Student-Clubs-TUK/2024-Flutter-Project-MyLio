package com.example.gdgocportfolio.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "question_answer")
public class QuestionAnswer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long questionAnswerId;

    @Column(nullable = false, length = 1000)
    private String question; // 자소서 문항

    @Column(nullable = false, length = 5000)
    private String answer; // 자소서 답변 (GPT 결과 + 사용자의 수정)

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "coverLetterId")
    private CoverLetter coverLetter;
}
