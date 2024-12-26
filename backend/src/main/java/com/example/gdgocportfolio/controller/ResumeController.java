package com.example.gdgocportfolio.controller;

import com.example.gdgocportfolio.dto.ResumeDto;
import com.example.gdgocportfolio.service.ResumeService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/resume")
public class ResumeController {
    private final ResumeService resumeService;

    public ResumeController(ResumeService resumeService) {
        this.resumeService = resumeService;
    }

    // 이력서 생성
    @PostMapping("/create/{userId}")
    public ResponseEntity<String> createResume(@PathVariable Long userId, @RequestBody ResumeDto resumeDto) {
        resumeService.saveResume(userId, resumeDto);
        return ResponseEntity.ok("이력서 저장 완료");
    }

    // 이력서 조회 (단건)
    @GetMapping("/{resumeId}")
    public ResponseEntity<ResumeDto> getResume(@PathVariable Long resumeId) {
        ResumeDto resumeDto = resumeService.getResume(resumeId);
        return ResponseEntity.ok(resumeDto);
    }

    // 이력서 조회 (사용자별 전체)
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<ResumeDto>> getResumesByUser(@PathVariable Long userId) {
        List<ResumeDto> resumes = resumeService.getResumesByUser(userId);
        return ResponseEntity.ok(resumes);
    }

    // 이력서 업데이트
    @PutMapping("/update/{resumeId}")
    public ResponseEntity<String> updateResume(@PathVariable Long resumeId, @RequestBody ResumeDto resumeDto) {
        resumeService.updateResume(resumeId, resumeDto);
        return ResponseEntity.ok("이력서 업데이트 완료");
    }

    // 이력서 삭제
    @DeleteMapping("/delete/{resumeId}")
    public ResponseEntity<String> deleteResume(@PathVariable Long resumeId) {
        resumeService.deleteResume(resumeId);
        return ResponseEntity.ok("이력서 삭제 완료");
    }

}
