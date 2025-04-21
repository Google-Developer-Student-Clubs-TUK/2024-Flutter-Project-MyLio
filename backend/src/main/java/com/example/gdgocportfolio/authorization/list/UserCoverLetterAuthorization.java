package com.example.gdgocportfolio.authorization.list;

import com.example.gdgocportfolio.authorization.Authentication;
import com.example.gdgocportfolio.authorization.AuthorizationAbstract;

@Authentication
public class UserCoverLetterAuthorization extends AuthorizationAbstract {
	public UserCoverLetterAuthorization() {
		super("user.coverletter", "/api/v1/coverLetters/*");
	}
}
