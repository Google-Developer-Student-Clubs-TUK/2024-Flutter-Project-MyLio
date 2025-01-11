package com.example.gdgocportfolio.util;

import com.example.gdgocportfolio.exceptions.InvalidJwtException;
import io.jsonwebtoken.JwtBuilder;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import io.jsonwebtoken.security.MacAlgorithm;
import jakarta.annotation.PostConstruct;
import lombok.AllArgsConstructor;
import lombok.Getter;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

@Component
public class JwtProvider {

	private String secretKey;
	private SecretKey key;
	private MacAlgorithm alg;

	@Getter
	private Long expireTime = 31L * 24 * 60 * 60 * 1000;

	public JwtProvider(@Value("${jwt.secret}") String secretKey, @Value("${jwt.expire_time}") final Long expireTime) {
		this.secretKey = secretKey;
		this.expireTime = expireTime;
	}

	@PostConstruct
	public void init() {
		alg = Jwts.SIG.HS256;
		key = Keys.hmacShaKeyFor(secretKey.getBytes(StandardCharsets.UTF_8));
	}

	public Long getCurrentTime() {
		return System.currentTimeMillis();
	}
	/**
	 * @return Return Payload
	 * @throws InvalidJwtException
	 */
	public Map<String, String> parseJwtToken(final String token, final Set<String> keys) {
		byte[] payloadBytes = Jwts
				.parser()
				.verifyWith(key)
				.build()
				.parseSignedContent(token)
				.getPayload();
		JSONObject payload = new JSONObject(new String(payloadBytes, StandardCharsets.UTF_8));
		HashMap<String, String> result = new HashMap<>();
		for (String key : keys) {
			String val;
			try {
				val = payload.getString(key);
			} catch (JSONException e) {
				throw new InvalidJwtException();
			}
			if (val == null) {
				throw new InvalidJwtException();
			}
			result.put(key, val);
		}
		return result;
	}

	public Token generateJwtToken(final Map<String, String> payload) {
		final JwtBuilder builder = Jwts.builder();
		final long currentTime = getCurrentTime();
		final byte[] contents = new JSONObject(payloadCheck(payload, currentTime)).toString().getBytes(StandardCharsets.UTF_8);
		builder.header().type("JWT");
		return new Token(builder
				.content(contents, "application/json")
				.signWith(key, alg)
				.compact(), (currentTime + expireTime));
	}

	private Map<String, String> payloadCheck(final Map<String, String> payload, long currentTime) {
		Map<String, String> result;
		if (payload == null) {
			result = new HashMap<>();
		} else {
			result = new HashMap<>(payload);
		}
		if (!result.containsKey("exp")) {
			result.put("exp", String.valueOf(currentTime + expireTime));
		}
		if (!result.containsKey("iat")) {
			result.put("iat", String.valueOf(currentTime));
		}
		return result;
	}

	@Getter
	@AllArgsConstructor
	public class Token {
		private String token;
		private long expire;
	}
}
