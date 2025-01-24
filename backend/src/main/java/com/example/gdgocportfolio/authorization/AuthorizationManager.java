package com.example.gdgocportfolio.authorization;

import com.example.gdgocportfolio.authorization.list.UserCoverLetterAuthorization;
import com.example.gdgocportfolio.authorization.list.UserResumeAuthorization;
import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Component;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.InvocationTargetException;
import java.util.*;
import java.util.stream.Collectors;

@Component
public class AuthorizationManager {
	private Set<AuthorizationAbstract> authorizations = new HashSet<>();
	private String packagePath = this.getClass().getPackageName() + ".list";

	public AuthorizationManager() {
		init();
	}

	public void init() {
		InputStream resourceAsStream = getClass().getClassLoader().getResourceAsStream(packagePath.replaceAll("[.]", "/"));
		BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(resourceAsStream));
		Set<? extends Class<?>> collect = bufferedReader.lines().filter(line -> line.endsWith(".class")).map(line -> {
			try {
				return Class.forName(packagePath + "." + line.substring(0, line.lastIndexOf('.')));
			} catch (ClassNotFoundException e) {
				throw new RuntimeException(e);
			}
		}).collect(Collectors.toSet());
		collect.stream().filter(v -> v.isAnnotationPresent(Authentication.class)).forEach(v -> {
			try {
				this.registerPermission((AuthorizationAbstract) v.getConstructor().newInstance());
			} catch (InstantiationException | IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
				throw new RuntimeException("Fail to create instance with empty parameter");
			}
		});
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

	public Set<AuthorizationAbstract> getAll() {
		return Collections.unmodifiableSet(this.authorizations);
	}
}
