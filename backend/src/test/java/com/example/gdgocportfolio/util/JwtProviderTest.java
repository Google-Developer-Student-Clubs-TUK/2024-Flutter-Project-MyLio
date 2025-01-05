package com.example.gdgocportfolio.util;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import java.util.Map;
import java.util.Set;

public class JwtProviderTest {
	JwtProvider jwtProvider = new JwtProvider("q394huerisgr39uerihs3289hiaep9uq823rp9h8waq", 1000000L);

	@Test
	public void createTokenTest() {
		String email = "string";
		String userId = "string";
		jwtProvider.init();
		JwtProvider.Token jwt = jwtProvider.generateJwtToken(Map.of("email", email, "userId", userId));
		Map<String, String> map = jwtProvider.parseJwtToken(jwt.getToken(), Set.of("email", "userId"));
		Assertions.assertEquals(map.get("email"), email);
		Assertions.assertEquals(map.get("userId"), userId);
	}
}
