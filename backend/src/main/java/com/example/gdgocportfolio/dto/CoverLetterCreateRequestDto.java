package com.example.gdgocportfolio.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.util.List;

@Data
public class CoverLetterCreateRequestDto {

    @NotBlank
    private String title;

    @NotNull
    @Size(min = 1, max = 3, message = "문항은 최소 1개, 최대 3개까지 가능합니다.")
    private List<String> questions;
}
