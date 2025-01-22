package com.example.gdgocportfolio.exceptions;

public class UnauthorizedException extends RuntimeException {
	public UnauthorizedException() {
		super("Unauhtorized");
	}

	public UnauthorizedException(String message) {
		super(message);
	}
}
