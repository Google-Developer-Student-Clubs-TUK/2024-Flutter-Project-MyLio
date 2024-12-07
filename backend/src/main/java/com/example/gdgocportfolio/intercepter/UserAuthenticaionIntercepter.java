package com.example.gdgocportfolio.intercepter;

import com.example.gdgocportfolio.service.UserAuthenticationService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

public class UserAuthenticaionIntercepter implements HandlerInterceptor {

	private UserAuthenticationService userAuthenticationService;
	private Boolean verify;

	public UserAuthenticaionIntercepter(UserAuthenticationService userAuthenticationService, Boolean verify) {
		this.userAuthenticationService = userAuthenticationService;
		this.verify = verify;
	}

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		String token = request.getHeader("token");
		if (token == null) {
			response.setStatus(401);
			return false;
		}

		try {
			userAuthenticationService.verifyUserJwtToken(token);
		} catch (Exception e) {
			response.setStatus(401);
			return false;
		}

		return true;
	}
}
