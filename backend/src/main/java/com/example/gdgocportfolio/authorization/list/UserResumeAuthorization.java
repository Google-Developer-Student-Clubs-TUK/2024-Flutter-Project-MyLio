package com.example.gdgocportfolio.authorization.list;

import com.example.gdgocportfolio.authorization.Authentication;
import com.example.gdgocportfolio.authorization.AuthorizationAbstract;

@Authentication
public class UserResumeAuthorization extends AuthorizationAbstract {
	public UserResumeAuthorization() {
		super("user.resume", "/api/v1/resume/*");
	}
}
