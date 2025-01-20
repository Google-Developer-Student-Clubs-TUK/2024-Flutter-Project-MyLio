package com.example.gdgocportfolio.repository;

import com.example.gdgocportfolio.entity.QuestionAnswer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface QuestionAnswerRepository extends JpaRepository<QuestionAnswer, Long> {
    Optional<QuestionAnswer> findByQuestionAnswerIdAndCoverLetterCoverLetterId(Long questionAnswerId, Long coverLetterId);
}
