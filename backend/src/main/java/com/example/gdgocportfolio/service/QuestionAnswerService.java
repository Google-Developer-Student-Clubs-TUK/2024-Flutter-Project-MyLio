package com.example.gdgocportfolio.service;

import com.example.gdgocportfolio.dto.QuestionAnswerUpdateRequestDto;
import com.example.gdgocportfolio.entity.CoverLetter;
import com.example.gdgocportfolio.entity.QuestionAnswer;
import com.example.gdgocportfolio.exceptions.CoverLetterNotExistsException;
import com.example.gdgocportfolio.exceptions.QuestionAnswerNotExistsException;
import com.example.gdgocportfolio.repository.CoverLetterRepository;
import com.example.gdgocportfolio.repository.QuestionAnswerRepository;
import jakarta.persistence.EntityManager;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Optional;

@Service
@Transactional
public class QuestionAnswerService {

    private final QuestionAnswerRepository questionAnswerRepository;
    private final CoverLetterRepository coverLetterRepository;
    private final EntityManager entityManager;


    public QuestionAnswerService(QuestionAnswerRepository questionAnswerRepository, CoverLetterRepository coverLetterRepository, EntityManager entityManager) {
        this.questionAnswerRepository = questionAnswerRepository;
        this.coverLetterRepository = coverLetterRepository;
        this.entityManager = entityManager;
    }

//    // QuestionAnswer 생성 (coverLetterId 범위 내에서)
//    public QuestionAnswer createQuestionAnswer(Long coverLetterId, Long userId,
//                                               String question, String answer) {
//        // coverLetter 소유 확인
//        CoverLetter coverLetter = coverLetterRepository.findByCoverLetterIdAndUserUserId(coverLetterId, userId)
//                .orElseThrow(() -> new RuntimeException("CoverLetter not found or not your resource."));
//
//        QuestionAnswer qa = new QuestionAnswer();
//        qa.setQuestion(question);
//        qa.setAnswer(answer);
//        qa.setCoverLetter(coverLetter);
//
//        // coverLetter에 추가
//        coverLetter.getQuestionAnswers().add(qa);
//        coverLetterRepository.save(coverLetter); // Cascade.ALL 이므로 QA도 함께 저장
//
//        // CoverLetter 강제 Dirty 상태로 설정
//        coverLetter.setLastUpdateTime(LocalDateTime.now());
//        coverLetter.setTitle(coverLetter.getTitle()); // Dirty 상태 강제 트리거
//
//        // Persistence Context 강제 동기화
//        entityManager.flush();
//
//        // 강제로 동기화
//        entityManager.flush();
//
//        return qa;
//    }

    // Q/A 조회. coverLetter 범위 내에서 qaId를 가져옴
    public Optional<QuestionAnswer> getQuestionAnswerWithinCoverLetter(Long coverLetterId, Long questionAnswerId) {
        return questionAnswerRepository.findByQuestionAnswerIdAndCoverLetterCoverLetterId(questionAnswerId, coverLetterId);
    }

    // Q/A 수정
    public QuestionAnswer updateQuestionAnswer(Long coverLetterId, Long userId,
                                               Long questionAnswerId,
                                               QuestionAnswerUpdateRequestDto dto) {
        // CoverLetter 소유 확인
        CoverLetter coverLetter = coverLetterRepository.findByCoverLetterIdAndUserUserId(coverLetterId, userId)
                .orElseThrow(() -> new CoverLetterNotExistsException("CoverLetter not found or not your resource."));

        // QA가 해당 CoverLetter에 속해 있는지 확인
        QuestionAnswer qa = questionAnswerRepository.findByQuestionAnswerIdAndCoverLetterCoverLetterId(questionAnswerId, coverLetterId)
                .orElseThrow(() -> new QuestionAnswerNotExistsException("QuestionAnswer not found in this CoverLetter."));

        // QA 수정
        qa.setQuestion(dto.getQuestion());
        qa.setAnswer(dto.getAnswer());
        questionAnswerRepository.save(qa);

        // CoverLetter의 lastUpdateTime 갱신
        coverLetter.setLastUpdateTime(LocalDateTime.now());
        coverLetterRepository.save(coverLetter);

        return qa;
    }

    // Q/A 삭제
    public void deleteQuestionAnswer(Long coverLetterId, Long userId, Long questionAnswerId) {
        // coverLetter 소유 확인
        CoverLetter coverLetter = coverLetterRepository.findByCoverLetterIdAndUserUserId(coverLetterId, userId)
                .orElseThrow(() -> new CoverLetterNotExistsException("CoverLetter not found or not your resource."));

        // QA가 해당 coverLetter에 속하는지 확인
        QuestionAnswer qa = questionAnswerRepository
                .findByQuestionAnswerIdAndCoverLetterCoverLetterId(questionAnswerId, coverLetterId)
                .orElseThrow(() -> new QuestionAnswerNotExistsException("QuestionAnswer not found in this CoverLetter."));

        questionAnswerRepository.delete(qa);

        // CoverLetter 강제 Dirty 상태로 설정
        coverLetter.setLastUpdateTime(LocalDateTime.now());
        coverLetter.setTitle(coverLetter.getTitle()); // Dirty 상태 강제 트리거

        // Persistence Context 강제 동기화
        entityManager.flush();

    }
}
