package com.example.gdgocportfolio.repository;

import com.example.gdgocportfolio.entity.RefreshTokenEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface UserRefreshTokenRepository extends JpaRepository<RefreshTokenEntity, UUID> {
	public List<RefreshTokenEntity> findAllByUserId(Long userId);
	public List<RefreshTokenEntity> findAllByExpireLessThan(Long expire);
}
