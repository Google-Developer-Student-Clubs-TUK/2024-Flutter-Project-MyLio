package com.example.gdgocportfolio.service;

import com.example.gdgocportfolio.authorization.AuthorizationAbstract;
import com.example.gdgocportfolio.authorization.AuthorizationManager;
import com.example.gdgocportfolio.entity.UserAuthentication;
import com.example.gdgocportfolio.exceptions.InvalidUserDataException;
import com.example.gdgocportfolio.repository.UserAuthenticationRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.Set;

@Service
public class AdminAuthenticationService {

	private final UserAuthenticationRepository userAuthenticationRepository;
	private final AuthorizationManager authorizationManager;

	public AdminAuthenticationService(UserAuthenticationRepository userAuthenticationRepository, AuthorizationManager authorizationManager) {
		this.userAuthenticationRepository = userAuthenticationRepository;
		this.authorizationManager = authorizationManager;
	}

	@Transactional
	public void addPermission(Long userId, Class<AuthorizationAbstract> permission) {
		UserAuthentication userAuthentication = userAuthenticationRepository.findById(userId).orElseThrow(InvalidUserDataException::new);
		Set<String> newPermissions = new HashSet<>(userAuthentication.getPermissions());
		newPermissions.add(authorizationManager.find(permission).getPermission());
		userAuthentication.setPermissions(newPermissions);
	}

	@Transactional
	public boolean deletePermission(Long userId, Class<AuthorizationAbstract> permission) {
		UserAuthentication userAuthentication = userAuthenticationRepository.findById(userId).orElseThrow(InvalidUserDataException::new);
		Set<String> newPermissions = new HashSet<>(userAuthentication.getPermissions());
		boolean result = newPermissions.remove(authorizationManager.find(permission).getPermission());
		if (!result) {
			return false;
		}
		userAuthentication.setPermissions(newPermissions);
		return true;
	}
}
