package com.example.gdgocportfolio.controller;


import com.example.gdgocportfolio.dto.CoverLetterCreateRequestDto;
import com.example.gdgocportfolio.dto.CoverLetterResponseDto;
import com.example.gdgocportfolio.dto.QuestionAnswerCreateRequestDto;
import com.example.gdgocportfolio.dto.QuestionAnswerDto;
import com.example.gdgocportfolio.entity.CoverLetter;
import com.example.gdgocportfolio.entity.QuestionAnswer;
import com.example.gdgocportfolio.service.ChatGPTService;
import com.example.gdgocportfolio.service.CoverLetterService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/coverLetters")
@Tag(name = "자소서 관리 및 GPT 생성 결과 저장")
public class CoverLetterController {

    private final CoverLetterService coverLetterService;
    private final ChatGPTService chatGPTService;

    public CoverLetterController(CoverLetterService coverLetterService, ChatGPTService chatGPTService) {
        this.coverLetterService = coverLetterService;
        this.chatGPTService = chatGPTService;
    }


    // ------------------------------------------------------
    // 1) CoverLetter CRUD
    // ------------------------------------------------------

    // 자소서 생성
    @PostMapping("/gen/{userId}")
    @Operation(summary = "GPT 이용해 CoverLetter 새로 생성",
            description = "userId, title, questions(1~3개)를 받아 질문당 GPT 호출 → CoverLetter + QuestionAnswer 저장")
    public ResponseEntity<CoverLetterResponseDto> createCoverLetterWithGpt(
            @PathVariable Long userId,
            @Valid @RequestBody CoverLetterCreateRequestDto requestDto
    ) {
        CoverLetter saved = coverLetterService.createCoverLetterWithGpt(userId, requestDto.getTitle(), requestDto.getQuestions());
        return ResponseEntity.ok(toResponseDto(saved));
    }

    // 자소서 상세 조회
    @GetMapping("/{userId}/{coverLetterId}")
    @Operation(summary = "자소서 상세 조회")
    public ResponseEntity<CoverLetterResponseDto> getCoverLetter(
            @PathVariable Long userId,
            @PathVariable Long coverLetterId
    ) {
        return coverLetterService.getCoverLetterByIdAndUserId(coverLetterId, userId)
                .map(this::toResponseDto)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // 특정 유저의 전체 자소서 조회
    @GetMapping("/user/{userId}")
    @Operation(summary = "특정 유저의 모든 CoverLetter")
    public ResponseEntity<List<CoverLetterResponseDto>> getCoverLettersByUser(
            @PathVariable Long userId
    ) {
        List<CoverLetter> list = coverLetterService.getAllCoverLettersByUserId(userId);
        List<CoverLetterResponseDto> dtos = list.stream().map(this::toResponseDto).toList();
        return ResponseEntity.ok(dtos);
    }

    // 자소서 수정 -> 제목 변경용으로 추후 구현 예정
//    @PutMapping("/{userId}/{coverLetterId}")
//    @Operation(summary = "자소서 수정")
//    public ResponseEntity<CoverLetterResponseDto> updateCoverLetter(
//            @PathVariable Long userId,
//            @PathVariable Long coverLetterId,
//            @RequestBody CoverLetterCreateRequestDto dto
//    ) {
//        CoverLetter newData = new CoverLetter();
//        newData.setTitle(dto.getTitle());
//
//        CoverLetter updated = coverLetterService.updateCoverLetter(coverLetterId, userId, newData);
//        return ResponseEntity.ok(toResponseDto(updated));
//    }

    // 자소서 삭제
    @DeleteMapping("/{userId}/{coverLetterId}")
    @Operation(summary = "자소서 삭제")
    public ResponseEntity<Void> deleteCoverLetter(
            @PathVariable Long userId,
            @PathVariable Long coverLetterId
    ) {
        coverLetterService.deleteCoverLetter(coverLetterId, userId);
        return ResponseEntity.noContent().build();
    }

    // ------------------------------------------------------
    // 2) QuestionAnswer CRUD
    // ------------------------------------------------------

    // QuestionAnswer 생성 (자소서에 문항답변 추가)
//    @PostMapping("/{userId}/{coverLetterId}/question-answer")
//    @Operation(summary = "커버레터에 Q/A 추가",
//            description = "coverLetterId, userId, question, answer -> QuestionAnswer 생성")
//    public ResponseEntity<QuestionAnswerDto> createQuestionAnswer(
//            @PathVariable Long userId,
//            @PathVariable Long coverLetterId,
//            @Valid @RequestBody QuestionAnswerCreateRequestDto requestDto
//    ) {
//        QuestionAnswer qa = coverLetterService.createQuestionAnswer(
//                userId, coverLetterId, requestDto.getQuestion(), requestDto.getAnswer());
//        return ResponseEntity.ok(toQaDto(qa));
//    }

    @PostMapping("/{userId}/{coverLetterId}/question-answer/{qaId}/regen")
    @Operation(summary = "GPT 이용, 특정 Q/A 재생성 (답변 재요청)",
            description = "coverLetterId, userId, qaId로 특정 Q/A를 찾아, 기존 question을 다시 GPT에 보내고, 새 answer를 반환 (저장은 x; " +
                    "사용자가 임시저장하면 저장 (put)")
    public ResponseEntity<QuestionAnswerDto> regenQuestionAnswer(
            @PathVariable Long userId,
            @PathVariable Long coverLetterId,
            @PathVariable Long qaId
    ) {
        String regeneratedAnswer = coverLetterService.regenQuestionAnswer(userId, coverLetterId, qaId);
        QuestionAnswerDto dto = new QuestionAnswerDto();
        dto.setQuestionAnswerId(qaId);
        dto.setAnswer(regeneratedAnswer);
        return ResponseEntity.ok(dto);
    }


    // QuestionAnswer 조회 (coverLetter 범위 내)
    @GetMapping("/{userId}/{coverLetterId}/question-answer/{qaId}")
    @Operation(summary = "개별 Q/A 조회")
    public ResponseEntity<QuestionAnswerDto> getQuestionAnswer(
            @PathVariable Long userId,
            @PathVariable Long coverLetterId,
            @PathVariable Long qaId
    ) {
        return coverLetterService.getQuestionAnswer(coverLetterId, qaId)
                .map(this::toQaDto)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // QuestionAnswer 수정
    @PutMapping("/{userId}/{coverLetterId}/question-answer/{qaId}")
    @Operation(summary = "개별 Q/A 수정 (해당 coverLetterId 범위에서)")
    public ResponseEntity<QuestionAnswerDto> updateQuestionAnswer(
            @PathVariable Long userId,
            @PathVariable Long coverLetterId,
            @PathVariable Long qaId,
            @Valid @RequestBody QuestionAnswerCreateRequestDto requestDto
    ) {
        QuestionAnswer updated = coverLetterService.updateQuestionAnswer(
                userId, coverLetterId, qaId, requestDto.getQuestion(), requestDto.getAnswer());
        return ResponseEntity.ok(toQaDto(updated));
    }


    // QuestionAnswer 삭제
    @DeleteMapping("/{userId}/{coverLetterId}/question-answer/{qaId}")
    @Operation(summary = "개별 Q/A 삭제 (coverLetterId 범위 안)")
    public ResponseEntity<Void> deleteQuestionAnswer(
            @PathVariable Long userId,
            @PathVariable Long coverLetterId,
            @PathVariable Long qaId
    ) {
        coverLetterService.deleteQuestionAnswer(userId, coverLetterId, qaId);
        return ResponseEntity.noContent().build();
    }

    // ------------------------------------------------------
    // DTO 변환 메서드
    // ------------------------------------------------------
    private CoverLetterResponseDto toResponseDto(CoverLetter coverLetter) {
        CoverLetterResponseDto dto = new CoverLetterResponseDto();
        dto.setCoverLetterId(coverLetter.getCoverLetterId());
        dto.setUserId(coverLetter.getUser().getUserId()); // User 객체에서 userId 가져옴
        dto.setTitle(coverLetter.getTitle());
        dto.setCreateTime(coverLetter.getCreateTime());
        dto.setLastUpdateTime(coverLetter.getLastUpdateTime());

        List<QuestionAnswerDto> qaDtos = coverLetter.getQuestionAnswers().stream()
                .map(this::toQaDto)
                .toList();
        dto.setQuestionAnswers(qaDtos);

        return dto;
    }

    private QuestionAnswerDto toQaDto(QuestionAnswer qa) {
        QuestionAnswerDto dto = new QuestionAnswerDto();
        dto.setQuestionAnswerId(qa.getQuestionAnswerId());
        dto.setQuestion(qa.getQuestion());
        dto.setAnswer(qa.getAnswer());
        return dto;
    }
}
