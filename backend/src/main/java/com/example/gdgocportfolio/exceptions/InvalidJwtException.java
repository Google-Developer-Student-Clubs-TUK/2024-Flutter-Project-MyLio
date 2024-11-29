package com.example.gdgocportfolio.exceptions;

import io.jsonwebtoken.JwtException;

public class InvalidJwtException extends JwtException {
	public InvalidJwtException() {
		super("Invalid token");
	}
}
