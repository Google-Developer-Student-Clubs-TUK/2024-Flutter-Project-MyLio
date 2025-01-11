package com.example.gdgocportfolio.scheduler;

import com.example.gdgocportfolio.service.AdminAuthenticationService;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class ExpiredRefreshScanner {
	private final AdminAuthenticationService adminAuthenticationService;

	public ExpiredRefreshScanner(AdminAuthenticationService adminAuthenticationService) {
		this.adminAuthenticationService = adminAuthenticationService;
	}

	@Scheduled(fixedDelay = 60*60*1000)
	public void run() {
		adminAuthenticationService.deleteAllExpiredRefreshToken();
	}
}
