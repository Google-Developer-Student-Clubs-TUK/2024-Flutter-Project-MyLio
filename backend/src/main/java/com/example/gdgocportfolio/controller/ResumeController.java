package com.example.gdgocportfolio.controller;

import com.example.gdgocportfolio.dto.ResumeDto;
import com.example.gdgocportfolio.service.ResumeService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/resume")
@Tag(name = "이력서")
public class ResumeController {
    private final ResumeService resumeService;

    public ResumeController(ResumeService resumeService) {
        this.resumeService = resumeService;
    }

    // 이력서 생성
    @PostMapping("/create/{userId}")
    @Operation(summary = "이력서 생성", description = "이력서를 생성합니다.")
    public ResponseEntity<String> createResume(@PathVariable Long userId, @Valid @RequestBody ResumeDto resumeDto) {
        resumeService.saveResume(userId, resumeDto);
        return ResponseEntity.ok("이력서 저장 완료");
    }

    // 이력서 조회 (단건)
    @GetMapping("/{userId}/{resumeId}")
    @Operation(summary = "이력서 조회(단건)", description = "이력서 단건을 조회합니다.")
    public ResponseEntity<ResumeDto> getResume(@PathVariable Long userId, @PathVariable Long resumeId) {
        ResumeDto resumeDto = resumeService.getResume(userId, resumeId);
        return ResponseEntity.ok(resumeDto);
    }

    // 이력서 조회 (사용자별 전체)
    @GetMapping("/user/{userId}")
    @Operation(summary = "이력서 조회 (사용자별 전체)", description = "사용자의 이력서 전체를 조회합니다.")
    public ResponseEntity<List<ResumeDto>> getResumesByUser(@PathVariable Long userId) {
        List<ResumeDto> resumes = resumeService.getResumesByUser(userId);
        return ResponseEntity.ok(resumes);
    }

    // 이력서 업데이트
    @PutMapping("/update/{userId}/{resumeId}")
    @Operation(summary = "이력서 업데이트", description = "이력서를 업데이트합니다.")
    public ResponseEntity<String> updateResume(@PathVariable Long userId, @PathVariable Long resumeId, @RequestBody ResumeDto resumeDto) {
        resumeService.updateResume(userId, resumeId, resumeDto);
        return ResponseEntity.ok("이력서 업데이트 완료");
    }

    // 이력서 삭제
    @DeleteMapping("/delete/{userId}/{resumeId}")
    @Operation(summary = "이력서 삭제", description = "이력서를 삭제합니다.")
    public ResponseEntity<String> deleteResume(@PathVariable Long userId, @PathVariable Long resumeId) {
        resumeService.deleteResume(userId, resumeId);
        return ResponseEntity.ok("이력서 삭제 완료");
    }

    // 대표 이력서 설정
    @PostMapping("/set-primary/{userId}/{resumeId}")
    public ResponseEntity<String> setPrimaryResume(@PathVariable Long userId, @PathVariable Long resumeId) {
        resumeService.setPrimaryResume(userId, resumeId);
        return ResponseEntity.ok("대표 이력서 설정 완료");
    }

}
