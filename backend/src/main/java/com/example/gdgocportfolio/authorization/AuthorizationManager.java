package com.example.gdgocportfolio.authorization;

import com.example.gdgocportfolio.authorization.list.UserCoverLetterAuthorization;
import com.example.gdgocportfolio.authorization.list.UserResumeAuthorization;
import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Component;

import java.util.*;
import java.util.stream.Collectors;

@Component
public class AuthorizationManager {
	private Set<AuthorizationAbstract> authorizations = new HashSet<>();


	public AuthorizationManager() {
		init();
	}

	public void init() {
		this.registerPermission(new UserResumeAuthorization());
		this.registerPermission(new UserCoverLetterAuthorization());
	}

	public void registerPermission(AuthorizationAbstract authorization) {
		this.authorizations.add(authorization);
	}

	public Set<AuthorizationAbstract> find(final String permission) {
		if (permission == null || permission.length() == 0) return null;

		String prefix;
		if (permission.strip().endsWith("*")) {
			prefix = permission.substring(0, permission.length()-1);
		} else {
			prefix = permission;
		}

		return new HashSet<>(authorizations.stream().filter(authorizationAbstract -> authorizationAbstract.getPermission().startsWith(prefix)).collect(Collectors.toSet()));
	}

	public AuthorizationAbstract find(final Class<?> clazz) {
		return authorizations.stream().filter(authorizationAbstract -> (authorizationAbstract.getClass() == clazz)).findFirst().orElseThrow();
	}
}
