package com.example.gdgocportfolio.authorization.list;

import com.example.gdgocportfolio.authorization.AuthorizationAbstract;

public class UserResumeAuthorization extends AuthorizationAbstract {
	public UserResumeAuthorization() {
		super("user.resume", "/api/v1/resume/*");
	}
}
