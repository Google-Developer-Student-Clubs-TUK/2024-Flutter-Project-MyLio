package com.example.gdgocportfolio.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;
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
    @NotNull(message = "이력서 제목은 필수입니다.")
    @Schema(
            description = "이력서 제목 (필수)",
            example = "네이버 백엔드 개발자 이력서"
    ) private String resumeTitle; // 이력서 제목 (필수)
    @NotNull(message = "산업군은 필수입니다. (최대 3개)")
    @Schema(
            description = "산업군 (필수; 최대 3개)",
            example = "[\"IT\", \"금융\"]"
    ) private List<String> industryGroups;  // 산업군 (최대 3개, 필수)
    @NotNull(message = "직무는 필수입니다.")
    @Schema(
            description = "직무 (필수)",
            example = "백엔드 개발자"
    ) private String jobDuty;  // 직무 (필수)

    // 활동 경험
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class Activity {
        @Schema(
                description = "활동명",
                example = "A 컴퍼니 직무교육 12기"
        ) private String name;         // 활동명
        @Schema(
                description = "기관/장소",
                example = "A 컴퍼니"
        ) private String organization; // 기관/장소
        @Schema(
                description = "시작일",
                example = "2022-01-01 "
        ) private String startDate;    // 시작일
        @Schema(
                description = "종료일",
                example = "2022-12-31 "
        ) private String endDate;      // 종료일
        @Schema(
                description = "활동내용",
                example = "Java Spring 실무교육"
        ) private String description;  // 활동내용
    }
    @Schema(description = "활동 경험") private List<Activity> activityExperience;   // 여러 활동 추가 가능

    // 수상 경력
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class Award {
        @Schema(
                description = "수상명",
                example = "24년 L컴퍼니 경진대회 최우수상"
        ) private String name;         // 수상명
        @Schema(
                description = "수상 일자",
                example = "2024-12-15"
        ) private String date;         // 수상 일자
        @Schema(
                description = "수상 기관",
                example = "L컴퍼니"
        ) private String organization; // 수상 기관
        @Schema(
                description = "수상 내용",
                example = "AI 솔루션 개발로 최우수상 입상"
        ) private String description;  // 수상 내용
    }
    @Schema(description = "수상 경력 (최대 5개)") private List<Award> awards;   // 최대 5개까지 추가 가능

    // 자격증
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class Certificate {
        @Schema(
                description = "자격증명",
                example = "정보처리기사"
        ) private String name;         // 자격증명
        @Schema(
                description = "취득일자",
                example = "2024-11-11"
        ) private String date;         // 취득일자
        @Schema(
                description = "발행처",
                example = "한국산업인력공단"
        ) private String issuer;       // 발행처
    }
    @Schema(description = "자격증 (최대 5개)") private List<Certificate> certificates;    // 최대 5개까지 추가 가능

    // 어학 능력
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class Language {
        @Schema(
                description = "언어",
                example = "영어"
        ) private String language;     // 언어
        @Schema(
                description = "시험명",
                example = "TOEIC"
        ) private String examName;     // 시험명
        @Schema(
                description = "점수/급수",
                example = "935"
        ) private String score;        // 점수/급수
        @Schema(
                description = "취득일자",
                example = "2024-02-08"
        ) private String date;         // 취득일자
    }
    @Schema(description = "어학 능력 (최대 10개)") private List<Language> languages;   // 최대 10개까지 추가 가능

    // 기타 항목
    @Schema(
            description = "강점 (최대 5개)",
            example = "[\"문제 해결 능력\", \"팀워크\"]"
    ) private List<String> strengths;            // 강점 (최대 5개 추가 가능)
    @Schema(
            description = "약점 (최대 5개)",
            example = "[\"완벽주의 성향\"]"
    ) private List<String> weaknesses;           // 약점 (최대 5개 추가 가능)
    @Schema(
            description = "역량",
            example = "[\"Java\", \"Spring Boot\", \"MySQL\"]"
    )private List<String> capabilities;
}
