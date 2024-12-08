package com.example.gdgocportfolio.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ResumeResponseDto {
    private Long resumeId;
    private Long userId;
    private String data; // JSON 형태의 데이터
    private LocalDateTime createTime;
    private LocalDateTime lastUpdateTime;
}
