package com.example.gdgocportfolio.authorization;

import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.core.type.classreading.MetadataReader;
import org.springframework.core.type.classreading.SimpleMetadataReaderFactory;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@Component
public class AuthorizationManager {
	private final Set<AuthorizationAbstract> authorizations = new HashSet<>();
	private final String packagePath = "com.example.gdgocportfolio.authorization.list";

	public AuthorizationManager() {
		init();
	}

	public void init() {
		System.out.println("🔍 AuthorizationManager: Initializing authorization classes...");
		try {
			Set<Class<?>> classes = scanClasses(packagePath);
			System.out.println("✅ Loaded classes: " + classes.size());

			for (Class<?> clazz : classes) {
				if (AuthorizationAbstract.class.isAssignableFrom(clazz) && !clazz.isInterface()) {
					AuthorizationAbstract instance = (AuthorizationAbstract) clazz.getDeclaredConstructor().newInstance();
					registerPermission(instance);
					System.out.println("✅ Registered permission: " + instance.getPermission());
				}
			}
			System.out.println("✅ AuthorizationManager initialization completed.");
		} catch (Exception e) {
			throw new RuntimeException("🚨 AuthorizationManager: Failed to initialize", e);
		}
	}

	private Set<Class<?>> scanClasses(String basePackage) throws IOException, ClassNotFoundException {
		Set<Class<?>> classes = new HashSet<>();
		PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
		String packageSearchPath = "classpath*:" + basePackage.replace(".", "/") + "/*.class";
		Resource[] resources = resolver.getResources(packageSearchPath);

		for (Resource resource : resources) {
			if (resource.isReadable()) {
				MetadataReader metadataReader = new SimpleMetadataReaderFactory().getMetadataReader(resource);
				String className = metadataReader.getClassMetadata().getClassName();
				classes.add(Class.forName(className));
			}
		}
		return classes;
	}

	public void registerPermission(AuthorizationAbstract authorization) {
		this.authorizations.add(authorization);
	}

	public Set<AuthorizationAbstract> find(final String permission) {
		if (permission == null || permission.isBlank()) return Collections.emptySet();

		String prefix = permission.strip().endsWith("*") ? permission.substring(0, permission.length() - 1) : permission;

		return authorizations.stream()
				.filter(auth -> auth.getPermission().startsWith(prefix))
				.collect(Collectors.toSet());
	}

	public AuthorizationAbstract find(final Class<?> clazz) {
		return authorizations.stream()
				.filter(auth -> auth.getClass() == clazz)
				.findFirst()
				.orElseThrow(() -> new NoSuchElementException("No authorization found for class: " + clazz.getName()));
	}

	public Set<AuthorizationAbstract> getAll() {
		return Collections.unmodifiableSet(this.authorizations);
	}
}