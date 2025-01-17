package com.example.gdgocportfolio.entity;

import jakarta.persistence.*;
import lombok.Data;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Entity
@Table(name = "resume")
@EntityListeners(AuditingEntityListener.class)
public class Resume {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long resumeId;

    @ManyToOne(fetch = FetchType.LAZY) // User와 ManyToOne
    @JoinColumn(name = "user_id", nullable = false) // FK 매핑
    private User user;

    @Column(nullable = false)
    private boolean isPrimary; // 대표 이력서 여부

    private String resumeTitle;                     // 제목
    @ElementCollection
    private List<String> industryGroups;          // 산업군 (최대 3개)
    private String jobDuty;                       // 직무

    @ElementCollection
    private List<String> strengths;           // 강점 (최대 5개)
    @ElementCollection
    private List<String> weaknesses;          // 약점 (최대 5개)
    @ElementCollection
    private List<String> capabilities;              // 역량 (최대 5개)

    @Column(columnDefinition = "TEXT")
    private String activityExperience;                // JSON 문자열 저장
    @Column(columnDefinition = "TEXT")
    private String awards;                    // JSON 문자열 저장
    @Column(columnDefinition = "TEXT")
    private String certificates;              // JSON 문자열 저장
    @Column(columnDefinition = "TEXT")
    private String languages;

    @CreatedDate
    private LocalDateTime createTime;

    @LastModifiedDate
    private LocalDateTime lastUpdateTime;
}
