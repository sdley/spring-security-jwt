package sn.sdley.spring_security_jwt.auth;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import sn.sdley.spring_security_jwt.security.JwtUtil;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @PostMapping("/login")
    public ResponseEntity<Map<String, String>> login(@RequestBody LoginRequest request) {
        // NOTE: Stubbed authentication; replace with real user lookup and password verification
        if (request.username() == null || request.username().isBlank()) {
            return ResponseEntity.badRequest().build();
        }

        Map<String, Object> claims = new HashMap<>();
        claims.put("roles", request.role());
        String token = JwtUtil.generateToken(request.username(), claims);

        Map<String, String> body = new HashMap<>();
        body.put("token", token);
        return ResponseEntity.ok(body);
    }
}

