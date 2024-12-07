package com.example.gdgocportfolio.util;

import org.springframework.stereotype.Component;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

@Component
public class HashConvertor {
	public String convertToHash(String data) {
		try {
			MessageDigest digest = null;
			digest = MessageDigest.getInstance("SHA-256");
			byte[] encodedhash = digest.digest(
					data.getBytes(StandardCharsets.UTF_8));
			return new String(encodedhash);
		} catch (NoSuchAlgorithmException e) {
			throw new RuntimeException(e);
		}
	}
}
