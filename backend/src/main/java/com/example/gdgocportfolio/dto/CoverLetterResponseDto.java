package com.example.gdgocportfolio.dto;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class CoverLetterResponseDto {
    private Long coverLetterId;
    private Long userId;
    private String title;
    private LocalDateTime createTime;
    private LocalDateTime lastUpdateTime;

    private List<QuestionAnswerDto> questionAnswers;
}
