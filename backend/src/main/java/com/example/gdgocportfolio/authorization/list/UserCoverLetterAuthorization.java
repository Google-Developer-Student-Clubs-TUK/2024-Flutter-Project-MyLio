package com.example.gdgocportfolio.authorization.list;

import com.example.gdgocportfolio.authorization.AuthorizationAbstract;

public class UserCoverLetterAuthorization extends AuthorizationAbstract {
	public UserCoverLetterAuthorization() {
		super("user.coverletter", "/api/v1/coverletter/*");
	}
}
