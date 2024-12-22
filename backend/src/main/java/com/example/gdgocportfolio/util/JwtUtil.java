package com.example.gdgocportfolio.util;

import com.example.gdgocportfolio.exceptions.InvalidJwtException;
import io.jsonwebtoken.JwtBuilder;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import io.jsonwebtoken.security.MacAlgorithm;
import jakarta.annotation.PostConstruct;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

@Component
public class JwtUtil {

	private String secretKey;
	private Long expireTime;
	private SecretKey key;
	private MacAlgorithm alg;

	public JwtUtil(@Value("${jwt.secret}") String secretKey, @Value("${jwt.expireTime}") Long expireTime) {
		this.secretKey = secretKey;
		this.expireTime = expireTime;
	}

	@PostConstruct
	public void init() {
		alg = Jwts.SIG.HS256;
		key = Keys.hmacShaKeyFor(secretKey.getBytes(StandardCharsets.UTF_8));
	}

	public Map<String, String> parseJwtToken(final String token, final Set<String> keys) {
		byte[] payloadBytes = Jwts
				.parser()
				.verifyWith(key)
				.build()
//				.parseEncryptedClaims(token)
				.parseSignedContent(token)
				.getPayload();
		JSONObject payload = new JSONObject(new String(payloadBytes, StandardCharsets.UTF_8));
		HashMap<String, String> result = new HashMap<>();
		for (String key : keys) {
			String val = payload.getString(key);
			if (val == null) {
				throw new InvalidJwtException();
			}
			result.put(key, val);
		}
		return result;
	}

	public String generateJwtToken(final Map<String, String> payload) {
//		Map<String, String> checkedHeader = headerCheck(header);
		final JwtBuilder builder = Jwts.builder();
		final byte[] contents = new JSONObject(payloadCheck(payload)).toString().getBytes(StandardCharsets.UTF_8);
		builder.header().type("JWT");
		return builder
				.content(contents, "application/json")
//				.encryptWith(key, enc)
				.signWith(key, alg)
				.compact();
	}

	private Map<String, String> payloadCheck(final Map<String, String> payload) {
		Map<String, String> result;
		if (payload == null) {
			result = new HashMap<>();
		} else {
			result = new HashMap<>(payload);
		}
		if (!result.containsKey("exp")) {
			result.put("exp", String.valueOf(System.currentTimeMillis() + expireTime));
		}
		if (!result.containsKey("iat")) {
			result.put("iat", String.valueOf(System.currentTimeMillis()));
		}
		return result;
	}

	private Map<String, String> headerCheck(final Map<String, String> header)  {
		Map<String, String> result;
		if (header == null) {
			result = new HashMap<>();
			result.put("typ", "JWT");
			result.put("alg", "HS256");
		} else {
			result = new HashMap<>(header);
			if (!result.containsKey("typ")) {
				result.put("typ", "JWT");
			}
			if (!result.containsKey("alg")) {
				result.put("alg", "HS256");
			}
		}
		return result;
	}


//	public String createJwt(HttpServletRequest request) throws Exception {
//		SecretKey key = Jwts.SIG.HS256.key().build();
//
//		String jws = Jwts.builder().subject("Joe").signWith(key).compact();
//
//		Map<String, Object> headerMap = new HashMap<String, Object>();
//		headerMap.put("typ", "JWT");
//		headerMap.put("alg", "HS256");
//
//		Map<String, Object> claims = new HashMap<String, Object>();
//		claims.put("name", request.getParameter("name"));
//		claims.put("id", request.getParameter("id"));
//
//		Date expireTime = new Date();
//		expireTime.setTime(expireTime.getTime() + 1000 * 60 * 1);
//
//		JwtBuilder builder = Jwts.builder()
//				.setHeader(headerMap)
//				.setClaims(claims)
//				.setExpiration(expireTime)
//				.signWith(createKey(), signatureAlgorithm);
//
//		String result = builder.compact();
//		System.out.println("serviceTester " + result);
//		return result;
//	}
}
