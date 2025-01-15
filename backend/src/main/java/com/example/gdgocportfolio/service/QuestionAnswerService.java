package com.example.gdgocportfolio.service;

import com.example.gdgocportfolio.entity.CoverLetter;
import com.example.gdgocportfolio.entity.QuestionAnswer;
import com.example.gdgocportfolio.repository.CoverLetterRepository;
import com.example.gdgocportfolio.repository.QuestionAnswerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class QuestionAnswerService {

    @Autowired
    private QuestionAnswerRepository questionAnswerRepository;

    @Autowired
    private CoverLetterRepository coverLetterRepository;

    // QuestionAnswer 생성 (coverLetterId 범위 내에서)
    public QuestionAnswer createQuestionAnswer(Long coverLetterId, Long userId,
                                               String question, String answer) {
        // coverLetter 소유 확인
        CoverLetter coverLetter = coverLetterRepository.findByCoverLetterIdAndUserId(coverLetterId, userId)
                .orElseThrow(() -> new RuntimeException("CoverLetter not found or not your resource."));

        QuestionAnswer qa = new QuestionAnswer();
        qa.setQuestion(question);
        qa.setAnswer(answer);
        qa.setCoverLetter(coverLetter);

        // coverLetter에 추가
        coverLetter.getQuestionAnswers().add(qa);
        coverLetterRepository.save(coverLetter); // Cascade.ALL 이므로 QA도 함께 저장
        return qa;
    }

    // coverLetter 범위 내에서 qaId를 가져옴
    public Optional<QuestionAnswer> getQuestionAnswerWithinCoverLetter(Long coverLetterId, Long questionAnswerId) {
        return questionAnswerRepository.findByQuestionAnswerIdAndCoverLetterCoverLetterId(questionAnswerId, coverLetterId);
    }

    public QuestionAnswer updateQuestionAnswer(Long coverLetterId, Long userId,
                                               Long questionAnswerId,
                                               String newQuestion, String newAnswer) {
        // 우선 coverLetter 소유 확인
        CoverLetter coverLetter = coverLetterRepository.findByCoverLetterIdAndUserId(coverLetterId, userId)
                .orElseThrow(() -> new RuntimeException("CoverLetter not found or not your resource."));

        // QA가 해당 coverLetter에 속해있는지 확인
        QuestionAnswer qa = questionAnswerRepository.findByQuestionAnswerIdAndCoverLetterCoverLetterId(questionAnswerId, coverLetterId)
                .orElseThrow(() -> new RuntimeException("QuestionAnswer not found in this CoverLetter."));

        // 수정
        qa.setQuestion(newQuestion);
        qa.setAnswer(newAnswer);

        // 저장
        questionAnswerRepository.save(qa);
        return qa;
    }

    public void deleteQuestionAnswer(Long coverLetterId, Long userId, Long questionAnswerId) {
        // coverLetter 소유 확인
        if (!coverLetterRepository.existsByCoverLetterIdAndUserId(coverLetterId, userId)) {
            throw new RuntimeException("CoverLetter not found or not your resource.");
        }

        // QA가 해당 coverLetter에 속하는지 확인
        QuestionAnswer qa = questionAnswerRepository
                .findByQuestionAnswerIdAndCoverLetterCoverLetterId(questionAnswerId, coverLetterId)
                .orElseThrow(() -> new RuntimeException("QuestionAnswer not found in this CoverLetter."));

        questionAnswerRepository.delete(qa);
    }
}
