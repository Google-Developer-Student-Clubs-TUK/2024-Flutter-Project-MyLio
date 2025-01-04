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
public class GenerateCoverLetterRequestDto {

    @NotNull(message = "Questions cannot be null")
    @Size(min = 1, message = "최소 한 개 이상의 질문이 존재해야 합니다") // 최소 한 개 이상의 질문을 허용
    private List<String> questions;
}
