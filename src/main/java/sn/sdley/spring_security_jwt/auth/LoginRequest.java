package sn.sdley.spring_security_jwt.auth;

public record LoginRequest(String username, String password, String role) {
}

