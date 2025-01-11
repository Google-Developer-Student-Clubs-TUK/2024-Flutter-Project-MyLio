package com.example.gdgocportfolio.authorization;

import lombok.Getter;

import java.util.Objects;

public abstract class AuthorizationAbstract {
	@Getter
	protected final String permission;

	protected AuthorizationAbstract(final String permission) {
		this.permission = permission;
	}

	@Override
	public boolean equals(Object o) {
		if (this == o) return true;
		if (o == null || getClass() != o.getClass()) return false;
		AuthorizationAbstract that = (AuthorizationAbstract) o;
		return Objects.equals(permission, that.permission);
	}

	@Override
	public int hashCode() {
		return Objects.hash(permission);
	}
}
