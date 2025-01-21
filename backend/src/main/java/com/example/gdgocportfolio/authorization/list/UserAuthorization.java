package com.example.gdgocportfolio.authorization.list;

import com.example.gdgocportfolio.authorization.Authentication;
import com.example.gdgocportfolio.authorization.AuthorizationAbstract;

@Authentication
public class UserAuthorization extends AuthorizationAbstract {
	public UserAuthorization() {
		super("user.user", "/api/v1/user");
	}
}
