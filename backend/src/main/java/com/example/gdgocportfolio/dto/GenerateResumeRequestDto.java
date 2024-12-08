package com.example.gdgocportfolio.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class GenerateResumeRequestDto {

    @NotNull(message = "Questions cannot be null")
    @Size(min = 1, message = "At least one question is required") // 최소 한 개 이상의 질문을 허용
    private List<String> questions;
}
