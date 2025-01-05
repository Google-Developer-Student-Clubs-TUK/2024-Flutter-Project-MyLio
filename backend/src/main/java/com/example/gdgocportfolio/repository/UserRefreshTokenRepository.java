package com.example.gdgocportfolio.repository;

import com.example.gdgocportfolio.entity.RefreshTokenEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface UserRefreshTokenRepository extends JpaRepository<RefreshTokenEntity, UUID> {
}
