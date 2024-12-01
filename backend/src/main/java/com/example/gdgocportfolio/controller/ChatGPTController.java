package com.example.gdgocportfolio.controller;

import com.example.gdgocportfolio.dto.GenerateResumeRequestDto;
import com.example.gdgocportfolio.dto.GenerateResumeResponseDto;
import com.example.gdgocportfolio.service.ChatGPTService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping("/api/chatgpt4")
public class ChatGPTController {

    @Autowired
    private ChatGPTService chatGPTService;

    @PostMapping("/generate-resume")
    public ResponseEntity<GenerateResumeResponseDto> generateResume(@Valid @RequestBody GenerateResumeRequestDto requestDTO) {
        String response = chatGPTService.generateResume(requestDTO.getQuestions());
        GenerateResumeResponseDto responseDTO = new GenerateResumeResponseDto(response);

        return ResponseEntity.ok(responseDTO);
    }

}
