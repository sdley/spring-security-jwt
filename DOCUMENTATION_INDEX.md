# 📖 Spring Security JWT - Complete Documentation Index

## 🎯 Quick Navigation

### 🚀 I Want to Get Started NOW (5 Minutes)
👉 Read: [`QUICK_START_TESTING.md`](./QUICK_START_TESTING.md)
- TL;DR version
- 3 simple steps
- Copy-paste examples

### 📱 I Prefer Using Postman (Visual)
👉 Read: [`POSTMAN_VISUAL_GUIDE.md`](./POSTMAN_VISUAL_GUIDE.md)
- Step-by-step instructions
- Visual mockups
- No code needed

### 💻 I Prefer Command Line (cURL)
👉 Read: [`TESTING_GUIDE.md`](./TESTING_GUIDE.md)
- cURL commands
- Shell scripts
- Automation examples

### 🤖 I Want Automated Testing
👉 Run: [`test-jwt.sh`](./test-jwt.sh)
```bash
chmod +x test-jwt.sh
./test-jwt.sh
```

### 📚 I Want Deep Understanding
👉 Read: [`TESTING_COMPLETE_GUIDE.md`](./TESTING_COMPLETE_GUIDE.md)
- Architecture diagrams
- Component breakdown
- Troubleshooting matrix

### 🎓 I Want to Learn the Code
👉 Read: [`README.md`](./README.md)
- Project overview
- Technology stack
- Best practices

---

## 📋 Document Overview

| Document | Purpose | Length | Level |
|----------|---------|--------|-------|
| QUICK_START_TESTING.md | Get running fast | 5 min | Beginner |
| POSTMAN_VISUAL_GUIDE.md | Visual step-by-step | 15 min | Beginner |
| POSTMAN_ASCII_REFERENCE.md | ASCII mockups | 10 min | Beginner |
| TESTING_GUIDE.md | Complete reference | 20 min | Intermediate |
| TESTING_COMPLETE_GUIDE.md | Deep dive | 30 min | Advanced |
| README.md | Project overview | 15 min | All levels |

---

## 🗂️ File Structure

```
spring-security-jwt/
│
├── 📖 Documentation
│   ├── README.md                          (Project overview)
│   ├── QUICK_START_TESTING.md            (Fast start)
│   ├── TESTING_GUIDE.md                  (Complete testing)
│   ├── TESTING_COMPLETE_GUIDE.md         (Deep dive)
│   ├── POSTMAN_VISUAL_GUIDE.md           (Postman steps)
│   ├── POSTMAN_ASCII_REFERENCE.md        (ASCII mockups)
│   └── DOCUMENTATION_INDEX.md            (This file)
│
├── 🧪 Testing Tools
│   ├── test-jwt.sh                       (Automated tests)
│   └── Spring-Security-JWT-Postman-Collection.json (Import)
│
├── 📦 Source Code
│   ├── src/main/java/sn/sdley/.../
│   │   ├── security/
│   │   │   ├── JwtUtil.java              (Token generation/validation)
│   │   │   └── JwtAuthenticationFilter.java (Request interception)
│   │   ├── config/
│   │   │   └── SecurityConfig.java       (Security configuration)
│   │   ├── auth/
│   │   │   ├── AuthController.java       (Login endpoint)
│   │   │   └── LoginRequest.java         (Login DTO)
│   │   └── HelloResource.java            (Secured endpoint)
│   │
│   └── src/main/resources/
│       └── application.properties        (Configuration)
│
└── 🔧 Build Configuration
    ├── pom.xml                           (Maven dependencies)
    └── mvnw / mvnw.cmd                   (Maven wrapper)
```

---

## 📚 Reading Guide by Use Case

### Use Case 1: "I Just Want to Test It"
```
1. Start reading: QUICK_START_TESTING.md
2. If not clear: POSTMAN_VISUAL_GUIDE.md
3. If want automation: test-jwt.sh
4. If problems: TESTING_GUIDE.md (troubleshooting)
```

### Use Case 2: "I Want to Understand How It Works"
```
1. Start reading: README.md (overview)
2. Read: TESTING_COMPLETE_GUIDE.md (architecture)
3. Review code: src/main/java/.../security/
4. Experiment: Try different requests in Postman
```

### Use Case 3: "I Need to Troubleshoot"
```
1. Check: QUICK_START_TESTING.md (common issues)
2. Check: TESTING_GUIDE.md (troubleshooting section)
3. Check: TESTING_COMPLETE_GUIDE.md (debug matrix)
4. Review logs: Check application console output
```

### Use Case 4: "I Need to Integrate This"
```
1. Read: README.md (overview & security)
2. Read: TESTING_GUIDE.md (API reference)
3. Review: src/main/java/.../security/JwtUtil.java
4. Review: src/main/java/.../config/SecurityConfig.java
5. Customize: application.properties and code for your needs
```

---

## 🚀 Getting Started Checklist

### Prerequisites
- [ ] Java 17+ installed: `java -version`
- [ ] Maven installed: `mvn -version`
- [ ] Application built: `mvn clean package`
- [ ] Application running: `java -jar target/spring-security-jwt-0.0.1-SNAPSHOT.jar`
- [ ] Port 8080 available
- [ ] Postman or curl installed

### First Time Setup
- [ ] Read: `QUICK_START_TESTING.md`
- [ ] Have: Token from login response
- [ ] Test: GET /hello without token (should fail 403)
- [ ] Test: GET /hello with token (should succeed 200)
- [ ] Celebrate: JWT authentication works! 🎉

### Learning Path
- [ ] Understand: JWT token structure
- [ ] Understand: How filter intercepts requests
- [ ] Understand: How roles are used
- [ ] Read: Complete code in src/main/java/.../security/
- [ ] Experiment: Try creating new secured endpoints

---

## 🔑 Key Concepts

### JWT Token (JSON Web Token)

**Structure:** `header.payload.signature`

**Example:**
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.
eyJzdWIiOiJ0ZXN0dXNlciIsInJvbGVzIjoiVVNFUiIsImlhdCI6MTczNjYxNDQyMCwiZXhwIjoxNzM2NjE4MDIwfQ.
abc123...
```

**Decode at:** https://jwt.io/

### Authentication vs Authorization

- **Authentication:** "Who are you?" (Login with credentials → Get token)
- **Authorization:** "What can you access?" (Check roles/permissions → Allow/Deny)

### Stateless Security

- No session stored on server
- Token contains user info
- Client sends token with each request
- Server validates token without looking up user data

---

## 🧪 Testing Summary

### Test Scenarios

```
Test 1: Login
  POST /api/auth/login
  → 200 OK + JWT token
  
Test 2: Secured endpoint WITHOUT token
  GET /hello (no header)
  → 403 Forbidden ❌
  
Test 3: Secured endpoint WITH valid token
  GET /hello + Authorization: Bearer <token>
  → 200 OK ✅
  
Test 4: Secured endpoint WITH invalid token
  GET /hello + Authorization: Bearer invalid
  → 403 Forbidden ❌
```

### Expected Results

| Test | Method | Endpoint | Header | Expected |
|------|--------|----------|--------|----------|
| 1 | POST | /api/auth/login | Content-Type | 200 OK + token |
| 2 | GET | /hello | (none) | 403 Forbidden |
| 3 | GET | /hello | Bearer token | 200 OK ✓ |
| 4 | GET | /hello | Bearer invalid | 403 Forbidden |

---

## 🛠️ Common Tasks

### Task 1: Test the Application
```bash
# Option A: Use Postman
1. Import: Spring-Security-JWT-Postman-Collection.json
2. Follow: POSTMAN_VISUAL_GUIDE.md

# Option B: Use Automated Script
./test-jwt.sh

# Option C: Use cURL
TOKEN=$(curl -s -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","password":"password123","role":"USER"}' \
  | grep -o '"token":"[^"]*' | cut -d'"' -f4)
curl -H "Authorization: Bearer $TOKEN" http://localhost:8080/hello
```

### Task 2: Create New Secured Endpoint
```java
@RestController
@RequestMapping("/api/user")
public class UserController {
    
    @GetMapping("/profile")
    public UserProfile getProfile() {
        // Automatically secured by JwtAuthenticationFilter
        return new UserProfile(...);
    }
}
```

### Task 3: Add Role-Based Authorization
```java
@RestController
@RequestMapping("/api/admin")
public class AdminController {
    
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/dashboard")
    public Dashboard getAdminDashboard() {
        return new Dashboard(...);
    }
}
```

### Task 4: Change Token Expiration
Edit `src/main/java/.../security/JwtUtil.java`:
```java
private static final long EXPIRATION_MILLIS = 1000 * 60 * 60; // 1 hour
// Change to:
private static final long EXPIRATION_MILLIS = 1000 * 60 * 15; // 15 minutes
```

---

## 🔍 Code Files Reference

### JwtUtil.java
**Location:** `src/main/java/.../security/JwtUtil.java`
**Provides:**
- `generateToken()` - Create JWT
- `extractAllClaims()` - Parse JWT
- `isTokenValid()` - Validate JWT

### JwtAuthenticationFilter.java
**Location:** `src/main/java/.../security/JwtAuthenticationFilter.java`
**Does:**
- Intercepts every request
- Checks Authorization header
- Validates JWT token
- Sets Spring Security context

### SecurityConfig.java
**Location:** `src/main/java/.../config/SecurityConfig.java`
**Configures:**
- Public endpoints: `/api/auth/**`
- Secured endpoints: Everything else
- Registers JWT filter

### AuthController.java
**Location:** `src/main/java/.../auth/AuthController.java`
**Provides:**
- `POST /api/auth/login` - Authenticate user, return JWT

### HelloResource.java
**Location:** `src/main/java/.../HelloResource.java`
**Provides:**
- `GET /hello` - Secured endpoint (requires JWT)

---

## 📊 Architecture Diagram

```
CLIENT
  │
  ├─→ POST /api/auth/login (credentials)
  │   AuthController
  │   └─ Generates JWT
  │   ← Returns token
  │
  ├─→ GET /hello (Authorization: Bearer JWT)
  │   JwtAuthenticationFilter
  │   ├─ Is /api/auth/**? NO
  │   ├─ Has Authorization header? YES
  │   ├─ Is token valid? YES
  │   └─ Set SecurityContext ✓
  │   HelloResource
  │   └─ Process request
  │   ← Returns 200 OK + message
  │
  └─→ GET /hello (no Authorization header)
      JwtAuthenticationFilter
      ├─ Is /api/auth/**? NO
      ├─ Has Authorization header? NO
      ├─ Skip validation
      └─ No authentication
      Spring Security
      └─ Access denied
      ← Returns 403 Forbidden
```

---

## 🎓 Learning Outcomes

After completing this project, you'll understand:

✅ How JWT tokens work and their structure  
✅ How to implement authentication with Spring Security  
✅ How to create authorization rules with role-based access control  
✅ How to build stateless APIs  
✅ How to secure endpoints with custom filters  
✅ How to handle security exceptions gracefully  
✅ How to test security implementations  
✅ How to deploy secure Spring Boot applications  

---

## 🚨 Important Security Notes

### ⚠️ For Development Only (Current Code)

- ❌ JWT secret is hardcoded
- ❌ No password hashing
- ❌ No user validation in database
- ❌ HTTP only (no HTTPS)
- ❌ No rate limiting

### ✅ For Production

- ✅ Externalize JWT secret to environment variables
- ✅ Hash passwords with BCrypt/Argon2
- ✅ Validate users in database
- ✅ Enable HTTPS/SSL
- ✅ Implement rate limiting
- ✅ Add CORS configuration
- ✅ Implement token refresh
- ✅ Add logout with token blacklist
- ✅ Enable audit logging

See `README.md` Security section for details.

---

## 📞 Quick Links

- **Project README:** `README.md`
- **Testing Quick Start:** `QUICK_START_TESTING.md`
- **Automated Tests:** `test-jwt.sh`
- **Postman Collection:** `Spring-Security-JWT-Postman-Collection.json`
- **JWT Debugger:** https://jwt.io/
- **Spring Security Docs:** https://spring.io/projects/spring-security

---

## 🎉 You're All Set!

Choose your starting point:

- 🚀 **Fast Start:** `QUICK_START_TESTING.md`
- 📱 **Postman:** `POSTMAN_VISUAL_GUIDE.md`
- 💻 **Command Line:** `TESTING_GUIDE.md`
- 🤖 **Automation:** Run `test-jwt.sh`
- 📚 **Deep Dive:** `TESTING_COMPLETE_GUIDE.md`

**Happy Testing! 🎊**

