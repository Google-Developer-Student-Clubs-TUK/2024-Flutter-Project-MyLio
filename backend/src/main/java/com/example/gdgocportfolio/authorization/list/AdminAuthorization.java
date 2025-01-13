package com.example.gdgocportfolio.authorization.list;

import com.example.gdgocportfolio.authorization.AuthorizationAbstract;

public class AdminAuthorization extends AuthorizationAbstract {
	protected AdminAuthorization() {
		super("admin", "/api/v1/admin/*");
	}
}
