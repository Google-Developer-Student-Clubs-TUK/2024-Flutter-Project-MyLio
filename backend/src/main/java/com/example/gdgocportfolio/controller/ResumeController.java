package com.example.gdgocportfolio.controller;

import com.example.gdgocportfolio.dto.ResumeDto;
import com.example.gdgocportfolio.service.ResumeService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/resume")
public class ResumeController {
    private final ResumeService resumeService;

    public ResumeController(ResumeService resumeService) {
        this.resumeService = resumeService;
    }

    @PostMapping("/create")
    public ResponseEntity<String> createResume(@RequestBody ResumeDto resumeDto) {
        resumeService.saveResume(resumeDto);
        return ResponseEntity.ok("이력서 저장 완료");
    }

    @GetMapping("/{id}")
    public ResponseEntity<ResumeDto> getResume(@PathVariable Long id) {
        ResumeDto resumeDto = resumeService.getResume(id);
        return ResponseEntity.ok(resumeDto);
    }
}
