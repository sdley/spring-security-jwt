package sn.sdley.spring_security_jwt;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloResource {

    @GetMapping("/hello")
    public String hello() {
        return "Welcome to Spring Security with JWT";
    }
}
