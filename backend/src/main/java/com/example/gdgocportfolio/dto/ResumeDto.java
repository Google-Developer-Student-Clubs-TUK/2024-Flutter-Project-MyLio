package com.example.gdgocportfolio.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ResumeDto {

    // 필수 입력 항목
    private String title;                      // 이력서 제목 (필수)
    private List<String> industries;           // 산업군 (최대 3개, 필수)
    private String job;                        // 직무 (필수)

    // 활동/경험
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class Activity {
        private String name;         // 활동명
        private String organization; // 기관/장소
        private String startDate;    // 시작일
        private String endDate;      // 종료일
        private String description;  // 활동내용
    }
    private List<Activity> activities;         // 여러 활동 추가 가능

    // 수상 경력
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class Award {
        private String name;         // 수상명
        private String date;         // 수상일자
        private String organization; // 수상 기관
        private String description;  // 수상 내용
    }
    private List<Award> awards;                // 최대 5개까지 추가 가능

    // 자격증
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class Certificate {
        private String name;         // 자격증명
        private String date;         // 취득일자
        private String issuer;       // 발행처
    }
    private List<Certificate> certificates;    // 최대 5개까지 추가 가능

    // 어학 능력
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class Language {
        private String language;     // 언어
        private String examName;     // 시험명
        private String score;        // 점수/급수
        private String date;         // 취득일자
    }
    private List<Language> languages;          // 최대 10개까지 추가 가능

    // 기타 항목
    private List<String> strengths;            // 강점 (최대 5개 추가 가능)
    private List<String> weaknesses;           // 약점 (최대 5개 추가 가능)
    private List<String> skills;
}
