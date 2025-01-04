package com.example.gdgocportfolio.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.util.List;

@Data
@Entity
@Table(name = "resume")
public class Resume {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long resumeId;

    @ManyToOne(fetch = FetchType.LAZY) // User와 ManyToOne
    @JoinColumn(name = "user_id", nullable = false) // FK 매핑
    private User user;

    @Column(nullable = false)
    private boolean isPrimary; // 대표 이력서 여부

    private String title;                     // 제목
    @ElementCollection
    private List<String> industries;          // 산업군 (최대 3개)
    private String job;                       // 직무

    @ElementCollection
    private List<String> strengths;           // 강점 (최대 5개)
    @ElementCollection
    private List<String> weaknesses;          // 약점 (최대 5개)
    @ElementCollection
    private List<String> skills;              // 역량 (최대 5개)

    @Column(columnDefinition = "TEXT")
    private String activities;                // JSON 문자열 저장
    @Column(columnDefinition = "TEXT")
    private String awards;                    // JSON 문자열 저장
    @Column(columnDefinition = "TEXT")
    private String certificates;              // JSON 문자열 저장
    @Column(columnDefinition = "TEXT")
    private String languages;
}
