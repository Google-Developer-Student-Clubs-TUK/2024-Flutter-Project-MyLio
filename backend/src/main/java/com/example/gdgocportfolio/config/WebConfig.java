package com.example.gdgocportfolio.config;

import com.example.gdgocportfolio.authorization.AuthorizationHandlerMethodArgumentResolver;
import com.example.gdgocportfolio.authorization.AuthorizationManager;
import com.example.gdgocportfolio.intercepter.UserAuthenticaionIntercepter;
import com.example.gdgocportfolio.service.UserAuthenticationService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.util.List;

@Configuration
public class WebConfig implements WebMvcConfigurer {

	private final UserAuthenticaionIntercepter userAuthenticaionIntercepter;
	private final AuthorizationHandlerMethodArgumentResolver authorizationHandlerMethodArgumentResolver;

	public WebConfig(UserAuthenticationService userAuthenticationService, AuthorizationManager authorizationManager, @Value("${jwt.verify}") Boolean verify, AuthorizationHandlerMethodArgumentResolver authorizationHandlerMethodArgumentResolver) {
		this.authorizationHandlerMethodArgumentResolver = authorizationHandlerMethodArgumentResolver;
		this.userAuthenticaionIntercepter = new UserAuthenticaionIntercepter(userAuthenticationService, authorizationManager, verify);
	}

	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(userAuthenticaionIntercepter)
				.addPathPatterns("/api/**");
//				.excludePathPatterns("/api/v1/auth/**");
	}

	@Override
	public void addArgumentResolvers(List<HandlerMethodArgumentResolver> resolvers) {
		resolvers.add(authorizationHandlerMethodArgumentResolver);
	}
}
