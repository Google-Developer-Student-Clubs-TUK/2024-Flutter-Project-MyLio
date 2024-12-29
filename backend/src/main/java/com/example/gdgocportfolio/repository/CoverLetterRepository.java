package com.example.gdgocportfolio.repository;

import com.example.gdgocportfolio.entity.CoverLetter;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CoverLetterRepository extends JpaRepository<CoverLetter, Long> {

}
