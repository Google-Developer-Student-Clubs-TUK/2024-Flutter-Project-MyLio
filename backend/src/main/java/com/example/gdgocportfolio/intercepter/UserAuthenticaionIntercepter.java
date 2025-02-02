package com.example.gdgocportfolio.intercepter;

import com.example.gdgocportfolio.authorization.AuthorizationAbstract;
import com.example.gdgocportfolio.authorization.AuthorizationManager;
import com.example.gdgocportfolio.dto.UserAccessTokenInfoDto;
import com.example.gdgocportfolio.dto.UserJwtDto;
import com.example.gdgocportfolio.service.UserAuthenticationService;
import jakarta.servlet.http.Cookie;
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
		this.authorizationManager.getAll().forEach(this::add);
	}

	private void add(AuthorizationAbstract authorization) {
		this.uriPermission.put(authorization.getUri(), authorization);
	}

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		System.out.println("=== [JWT Authentication Start] ===");
		System.out.println("Request URI: " + request.getRequestURI());

		if (!verify) {
			System.out.println("Authentication verification disabled (verify = false) → Request allowed");
			return true;
		}

		List<AuthorizationAbstract> authorizations = uriFilter(request.getRequestURI());
		if (authorizations.isEmpty()) {
			System.out.println("No authorization check required for this URI → Request allowed");
			return true;
		}

		String accessToken = null;
		String refreshToken = null;

		// Check for cookies in the request
		if (request.getCookies() == null) {
			System.out.println("No cookies found in request → Returning 401 Unauthorized");
			response.setStatus(HttpStatus.UNAUTHORIZED.value());
			return false;
		}

		for (Cookie cookie : request.getCookies()) {
			System.out.println("Checking cookie - Name: " + cookie.getName() + ", Value: " + cookie.getValue());
			if (cookie.getName().equals("ACCESS_TOKEN")) {
				accessToken = cookie.getValue();
			}
			if (cookie.getName().equals("REFRESH_TOKEN")) {
				refreshToken = cookie.getValue();
			}
		}

		if (accessToken == null) {
			System.out.println("No ACCESS_TOKEN found → Checking refreshToken");
			if (refreshToken == null) {
				System.out.println("No REFRESH_TOKEN found either → Returning 401 Unauthorized");
				response.setStatus(HttpStatus.UNAUTHORIZED.value());
				response.getWriter().write("Unauthorized: No ACCESS_TOKEN or REFRESH_TOKEN found");
				return false;
			}

			// Issue new accessToken using refreshToken
			try {
				System.out.println("Attempting to issue new ACCESS_TOKEN using REFRESH_TOKEN");
				UserJwtDto userJwtDto = userAuthenticationService.refreshUserJwtToken(refreshToken);
				response.addHeader("Set-Cookie", "ACCESS_TOKEN=" + userJwtDto.getAccessToken() + "; HttpOnly; Secure; SameSite=None");
				response.addHeader("Set-Cookie", "REFRESH_TOKEN=" + userJwtDto.getRefreshToken() + "; HttpOnly; Secure; SameSite=None");
				accessToken = userJwtDto.getAccessToken();
				refreshToken = userJwtDto.getRefreshToken();
			} catch (Exception e) {
				System.out.println("REFRESH_TOKEN is also invalid → Returning 401 Unauthorized");
				response.setStatus(HttpStatus.UNAUTHORIZED.value());
				response.getWriter().write("Unauthorized: Invalid Refresh Token");
				return false;
			}
		}

		// ACCESS_TOKEN validation
		for (int i = 0; i < 2; i++) {
			try {
				System.out.println("Verifying ACCESS_TOKEN: " + accessToken);
				UserAccessTokenInfoDto userAccessTokenInfoDto = userAuthenticationService.verifyUserAccessToken(accessToken);
				request.setAttribute("ACCESS_TOKEN", userAccessTokenInfoDto);
				System.out.println("ACCESS_TOKEN verification successful");

				boolean fail = false;
				for (AuthorizationAbstract a : authorizations) {
					if (!userAccessTokenInfoDto.getPermissions().contains(a.getPermission())) {
						fail = true;
						break;
					}
				}
				if (fail) {
					System.out.println("User does not have required permissions → Returning 401 Unauthorized");
					response.setStatus(HttpStatus.UNAUTHORIZED.value());
					return false;
				}
				System.out.println("Final authentication success → Request allowed");
				return true;
			} catch (Exception e) {
				System.out.println("ACCESS_TOKEN verification failed (might be expired)");
				if (i == 0) {
					System.out.println("Attempting to refresh ACCESS_TOKEN using REFRESH_TOKEN");
					try {
						UserJwtDto userJwtDto = userAuthenticationService.refreshUserJwtToken(refreshToken);
						response.addHeader("Set-Cookie", "ACCESS_TOKEN=" + userJwtDto.getAccessToken() + "; HttpOnly; Secure; SameSite=None");
						response.addHeader("Set-Cookie", "REFRESH_TOKEN=" + userJwtDto.getRefreshToken() + "; HttpOnly; Secure; SameSite=None");
						accessToken = userJwtDto.getAccessToken();
						refreshToken = userJwtDto.getRefreshToken();
					} catch (Exception ex) {
						System.out.println("REFRESH_TOKEN is also invalid → Returning 401 Unauthorized");
						response.setStatus(HttpStatus.UNAUTHORIZED.value());
						response.getWriter().write("Unauthorized: Invalid Refresh Token");
						return false;
					}
				}
			}
		}

		System.out.println("All authentication attempts failed → Returning 401 Unauthorized");
		response.setStatus(HttpStatus.UNAUTHORIZED.value());
		return false;
	}

	public List<AuthorizationAbstract> uriFilter(String uri) {
		List<AuthorizationAbstract> authorizations = new LinkedList<>();
		uri = uri.strip();
		for (String pattern : uriPermission.keySet()) {
			System.out.println("Checking against registered pattern: " + pattern);

			// 패턴이 '*'로 끝나는 경우 (예: "/api/v1/resume/*")
			if (pattern.endsWith("/*")) {
				String basePattern = pattern.substring(0, pattern.length() - 2);
				if (uri.startsWith(basePattern)) {
					System.out.println("✅ Matched pattern: " + pattern);
					authorizations.add(uriPermission.get(pattern));
				}
				continue;
			}

			// 패턴이 '*'로 끝나는 경우 (예: "/api/v1/resume*")
			if (pattern.endsWith("*")) {
				String basePattern = pattern.substring(0, pattern.length() - 1);
				if (uri.startsWith(basePattern)) {
					System.out.println("✅ Matched pattern: " + pattern);
					authorizations.add(uriPermission.get(pattern));
				}
				continue;
			}

			// 완전 일치하는 경우 (예: "/api/v1/resume/1/1")
			if (uri.equals(pattern) || (uri.startsWith(pattern) && (uri.length() == pattern.length() || uri.charAt(pattern.length()) == '/'))) {
				System.out.println("✅ Exact match found: " + pattern);
				authorizations.add(uriPermission.get(pattern));
			}
		}

		if (authorizations.isEmpty()) {
			System.out.println("🚨 No matching authorization found for URI: " + uri);
		}

		return authorizations;
	}
}