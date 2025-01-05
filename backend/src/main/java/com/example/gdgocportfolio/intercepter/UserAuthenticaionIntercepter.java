package com.example.gdgocportfolio.intercepter;

import com.example.gdgocportfolio.authorization.AuthorizationAbstract;
import com.example.gdgocportfolio.authorization.AuthorizationManager;
import com.example.gdgocportfolio.authorization.list.UserResumeAuthorization;
import com.example.gdgocportfolio.dto.UserAccessTokenInfoDto;
import com.example.gdgocportfolio.dto.UserJwtDto;
import com.example.gdgocportfolio.service.UserAuthenticationService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpStatus;
import org.springframework.web.servlet.HandlerInterceptor;

import java.util.*;

public class UserAuthenticaionIntercepter implements HandlerInterceptor {

	private final UserAuthenticationService userAuthenticationService;
	private final AuthorizationManager authorizationManager;
	private final Boolean verify; // Injected in configuration
	private final Map<String, AuthorizationAbstract> uriPermission;

	public UserAuthenticaionIntercepter(UserAuthenticationService userAuthenticationService, AuthorizationManager authorizationManager, Boolean verify) {
		this.userAuthenticationService = userAuthenticationService;
		this.authorizationManager = authorizationManager;
		this.verify = verify;
		this.uriPermission = new HashMap<>();
		uriInit();
	}

	private void uriInit() {
		this.uriPermission.put("/api/v1/resume/*", authorizationManager.find(UserResumeAuthorization.class));
	};

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		if (!verify) {
			return true;
		}

		List<AuthorizationAbstract> authorizations = uriFilter(request.getRequestURI());
		String accessToken = request.getHeader("ACCESS_TOKEN");
		String refreshToken = request.getHeader("REFRESH_TOKEN");

		if (authorizations.size() == 0) {
			return true;
		}

		if (accessToken == null) {
			if (refreshToken == null) {
				response.setStatus(HttpStatus.UNAUTHORIZED.value());
				return false;
			}
			try {
				UserJwtDto userJwtDto = userAuthenticationService.refreshUserJwtToken(refreshToken);
				response.addHeader("Set-Cookie", "ACCESS_TOKEN=" + userJwtDto.getAccessToken());
				response.addHeader("Set-Cookie", "REFRESH_TOKEN=" + userJwtDto.getRefreshToken());
				accessToken = userJwtDto.getAccessToken();
				refreshToken = userJwtDto.getRefreshToken();
			} catch (Exception e) {
				response.setStatus(HttpStatus.UNAUTHORIZED.value());
				return false;
			}
		} else {
			try {
				UserAccessTokenInfoDto userAccessTokenInfoDto = userAuthenticationService.verifyUserAccessToken(accessToken);
				boolean fail = false;
				for (AuthorizationAbstract a : authorizations) {
					if (!userAccessTokenInfoDto.getPermissions().contains(a.getPermission())) {
						fail = true;
						break;
					}
				}
				if (fail) {
					response.setStatus(HttpStatus.UNAUTHORIZED.value());
					return false;
				}
				return true;
			} catch (Exception e) {
				response.setStatus(HttpStatus.UNAUTHORIZED.value());
				return false;
			}
		}
		response.setStatus(HttpStatus.UNAUTHORIZED.value());
		return false;
	}
	public List<AuthorizationAbstract> uriFilter(String uri) {
		List<AuthorizationAbstract> authorizations = new LinkedList<>();
		uri = uri.strip();
		for (String s : uriPermission.keySet()) {
			if (s.endsWith("*")) {
				if (s.endsWith("/*")) {
					if (uri.startsWith(s.substring(0, s.length()-2)) && (uri.length() == s.length()-2 || uri.charAt(s.length()-1) == '/'))
						authorizations.add(uriPermission.get(s));
					continue;
				}
				if (uri.startsWith(s.substring(0, s.length()-1)))
					authorizations.add(uriPermission.get(s));
				continue;
			}
			if (uri.startsWith(s) && (s.length() == uri.length() || uri.charAt(s.length()) == '/')) {
				authorizations.add(uriPermission.get(s));
			}
		}
		return authorizations;
	}
}
