package com.example.gdgocportfolio.exceptions;

import io.jsonwebtoken.JwtException;

public class InvalidJwtException extends JwtException {
	public InvalidJwtException(String message) {
		super(message);
	}

	public InvalidJwtException() {
		super("Invalid token");
	}
}
