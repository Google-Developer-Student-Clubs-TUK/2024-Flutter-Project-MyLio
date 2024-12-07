package com.example.gdgocportfolio.config;

import com.example.gdgocportfolio.intercepter.UserAuthenticaionIntercepter;
import com.example.gdgocportfolio.service.UserAuthenticationService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.DependsOn;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

	private final UserAuthenticaionIntercepter userAuthenticaionIntercepter;

	public WebConfig(UserAuthenticationService userAuthenticationService, @Value("${jwt.verify}") Boolean verify) {
		this.userAuthenticaionIntercepter = new UserAuthenticaionIntercepter(userAuthenticationService, verify);
	}

	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(userAuthenticaionIntercepter)
				.addPathPatterns("/api/**")
				.excludePathPatterns("/api/v1/auth/**");
	}
}
