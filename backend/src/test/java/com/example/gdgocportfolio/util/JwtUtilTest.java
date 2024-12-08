package com.example.gdgocportfolio.util;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import java.util.Map;
import java.util.Set;

public class JwtUtilTest {
	JwtUtil jwtUtil = new JwtUtil("q394huerisgr39uerihs3289hiaep9uq823rp9h8waq", 100000000L);

	@Test
	public void createTokenTest() {
		String email = "string";
		String userId = "string";
		jwtUtil.init();
		String jwt = jwtUtil.generateJwtToken(Map.of("email", email, "userId", userId));
		Map<String, String> map = jwtUtil.parseJwtToken(jwt, Set.of("email", "userId"));
		Assertions.assertEquals(map.get("email"), email);
		Assertions.assertEquals(map.get("userId"), userId);
	}
}
