package com.example.gdgocportfolio.service;

import com.example.gdgocportfolio.entity.CoverLetter;
import com.example.gdgocportfolio.entity.QuestionAnswer;
import com.example.gdgocportfolio.entity.User;
import com.example.gdgocportfolio.repository.CoverLetterRepository;
import com.example.gdgocportfolio.repository.QuestionAnswerRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class CoverLetterService {

    private final CoverLetterRepository coverLetterRepository;
    private final QuestionAnswerRepository questionAnswerRepository;
    private final ChatGPTService chatGPTService;
    private final UserService userService;

    public CoverLetterService(CoverLetterRepository coverLetterRepository,
                              QuestionAnswerRepository questionAnswerRepository,
                              ChatGPTService chatGPTService,
                              UserService userService) {
        this.coverLetterRepository = coverLetterRepository;
        this.questionAnswerRepository = questionAnswerRepository;
        this.chatGPTService = chatGPTService;
        this.userService = userService;
    }

    public CoverLetter updateCoverLetter(Long coverLetterId, Long userId, CoverLetter updated) {
        return coverLetterRepository.findByCoverLetterIdAndUserUserId(coverLetterId, userId)
                .map(existing -> {
                    existing.setTitle(updated.getTitle());
                    // questionAnswers는 필요 시 별도 로직으로 관리
                    return coverLetterRepository.save(existing);
                })
                .orElseThrow(() -> new RuntimeException("CoverLetter not found or does not belong to this user"));
    }


    // CoverLetter 생성 (GPT 이용)
    public CoverLetter createCoverLetterWithGpt(Long userId, String title, List<String> questions) {
        User user = userService.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        CoverLetter coverLetter = new CoverLetter();
        coverLetter.setUser(user);
        coverLetter.setTitle(title);

        List<QuestionAnswer> qaList = questions.stream().map(question -> {
            String answer = chatGPTService.generateAnswer(userId, question);
            QuestionAnswer qa = new QuestionAnswer();
            qa.setQuestion(question);
            qa.setAnswer(answer);
            qa.setCoverLetter(coverLetter);
            return qa;
        }).toList();

        coverLetter.setQuestionAnswers(qaList);
        return coverLetterRepository.save(coverLetter);
    }

    // QuestionAnswer 생성
    public QuestionAnswer createQuestionAnswer(Long userId, Long coverLetterId, String question, String answer) {
        CoverLetter coverLetter = getCoverLetterByIdAndUserId(coverLetterId, userId)
                .orElseThrow(() -> new RuntimeException("CoverLetter not found or not yours"));

        QuestionAnswer qa = new QuestionAnswer();
        qa.setQuestion(question);
        qa.setAnswer(answer);
        qa.setCoverLetter(coverLetter);

        return questionAnswerRepository.save(qa);
    }

    // QuestionAnswer 조회
    public Optional<QuestionAnswer> getQuestionAnswer(Long coverLetterId, Long qaId) {
        return questionAnswerRepository.findByQuestionAnswerIdAndCoverLetterCoverLetterId(qaId, coverLetterId);
    }

    // QuestionAnswer 수정
    public QuestionAnswer updateQuestionAnswer(Long userId, Long coverLetterId, Long qaId, String question, String answer) {
        CoverLetter coverLetter = getCoverLetterByIdAndUserId(coverLetterId, userId)
                .orElseThrow(() -> new RuntimeException("CoverLetter not found or not yours"));

        QuestionAnswer qa = getQuestionAnswer(coverLetterId, qaId)
                .orElseThrow(() -> new RuntimeException("QuestionAnswer not found in this CoverLetter"));

        if (question != null) qa.setQuestion(question);
        if (answer != null) qa.setAnswer(answer);

        return questionAnswerRepository.save(qa);
    }

    // QuestionAnswer 삭제
    public void deleteQuestionAnswer(Long userId, Long coverLetterId, Long qaId) {
        CoverLetter coverLetter = getCoverLetterByIdAndUserId(coverLetterId, userId)
                .orElseThrow(() -> new RuntimeException("CoverLetter not found or not yours"));

        QuestionAnswer qa = getQuestionAnswer(coverLetterId, qaId)
                .orElseThrow(() -> new RuntimeException("QuestionAnswer not found in this CoverLetter"));

        questionAnswerRepository.delete(qa);
    }

    // QuestionAnswer GPT 재생성
    public String regenQuestionAnswer(Long userId, Long coverLetterId, Long qaId) {
        QuestionAnswer qa = getQuestionAnswer(coverLetterId, qaId)
                .orElseThrow(() -> new RuntimeException("QuestionAnswer not found"));

        String question = qa.getQuestion();
        return chatGPTService.generateAnswer(userId, question);
    }

    // CoverLetter 상세 조회
    public Optional<CoverLetter> getCoverLetterByIdAndUserId(Long coverLetterId, Long userId) {
        return coverLetterRepository.findByCoverLetterIdAndUserUserId(coverLetterId, userId);
    }

    // 특정 User의 모든 CoverLetter 조회
    public List<CoverLetter> getAllCoverLettersByUserId(Long userId) {
        return coverLetterRepository.findAllByUserUserId(userId);
    }

    // CoverLetter 삭제
    public void deleteCoverLetter(Long coverLetterId, Long userId) {
        if (coverLetterRepository.existsByCoverLetterIdAndUserUserId(coverLetterId, userId)) {
            coverLetterRepository.deleteById(coverLetterId);
        } else {
            throw new RuntimeException("CoverLetter not found or does not belong to this user");
        }
    }
}
