package com.example.gdgocportfolio.util;

import io.jsonwebtoken.JwtBuilder;
import io.jsonwebtoken.Jwts;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Component
public class JwtUtil {

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
