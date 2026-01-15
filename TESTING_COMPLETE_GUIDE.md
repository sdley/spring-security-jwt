# 🧪 Complete Testing Guide - Secured /hello Endpoint

## 📚 Documentation Files Created

I've created several comprehensive testing guides for you:

### Quick References
1. **QUICK_START_TESTING.md** ← START HERE
   - TL;DR version
   - 3 simple steps
   - Common issues & solutions

2. **POSTMAN_VISUAL_GUIDE.md**
   - Step-by-step Postman setup
   - Visual mockups in text
   - Screenshots description

3. **POSTMAN_ASCII_REFERENCE.md**
   - ASCII art representations
   - Keyboard shortcuts
   - Token inspection guide

### Detailed Guides
4. **TESTING_GUIDE.md**
   - Comprehensive testing scenarios
   - cURL examples
   - Test results table
   - Troubleshooting section

5. **test-jwt.sh**
   - Automated testing script
   - Colored output
   - All 4 tests in one command

6. **Spring-Security-JWT-Postman-Collection.json**
   - Ready-to-import Postman collection
   - Pre-configured requests
   - Auto-token extraction

---

## 🚀 Quick Start (5 Minutes)

### Prerequisites
- ✅ Application running: `java -jar target/spring-security-jwt-0.0.1-SNAPSHOT.jar`
- ✅ Port 8080 available
- ✅ Postman installed (or curl available)

### The 3-Step Test

#### Step 1️⃣: Get JWT Token
```
POST http://localhost:8080/api/auth/login
Headers: Content-Type: application/json
Body: {
  "username": "testuser",
  "password": "password123",
  "role": "USER"
}

Expected: 200 OK
Response: { "token": "eyJ..." }
```

#### Step 2️⃣: Test Without Token (Should Fail)
```
GET http://localhost:8080/hello
(No Authorization header)

Expected: 403 Forbidden ❌
```

#### Step 3️⃣: Test With Token (Should Succeed)
```
GET http://localhost:8080/hello
Headers: Authorization: Bearer <PASTE_TOKEN_HERE>

Expected: 200 OK ✅
Response: "Welcome to Spring Security with JWT"
```

---

## 🔧 Choose Your Testing Method

### Method A: Postman GUI (Recommended for Learning)

**Pros:**
- ✅ User-friendly interface
- ✅ Visual request builder
- ✅ Save requests for reuse
- ✅ Environment variables
- ✅ Pre-request scripts

**Steps:**
1. Open Postman
2. Click: File → Import
3. Select: `Spring-Security-JWT-Postman-Collection.json`
4. Follow: `POSTMAN_VISUAL_GUIDE.md`

### Method B: cURL Commands (Fastest)

**Pros:**
- ✅ No GUI needed
- ✅ Fast execution
- ✅ Easily scriptable
- ✅ Works anywhere

**Steps:**
```bash
# Get token and save
TOKEN=$(curl -s -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","password":"password123","role":"USER"}' \
  | grep -o '"token":"[^"]*' | cut -d'"' -f4)

# Test with token
curl -H "Authorization: Bearer $TOKEN" http://localhost:8080/hello
```

### Method C: Automated Script (Comprehensive)

**Pros:**
- ✅ Tests all scenarios
- ✅ Colored output
- ✅ Passes/fails clearly
- ✅ No manual token copying

**Steps:**
```bash
chmod +x test-jwt.sh
./test-jwt.sh
```

---

## 📊 What Gets Tested

### Test Suite Breakdown

```
Test 1: Authentication
├─ POST /api/auth/login
├─ Provides: username, password, role
└─ Result: Get JWT token ✓

Test 2: Authorization - No Token
├─ GET /hello
├─ No Authorization header
└─ Result: 403 Forbidden ✓ (Protected!)

Test 3: Authorization - Valid Token
├─ GET /hello
├─ Authorization: Bearer <valid_token>
└─ Result: 200 OK ✓ (Authenticated!)

Test 4: Authorization - Invalid Token
├─ GET /hello
├─ Authorization: Bearer <invalid_token>
└─ Result: 403 Forbidden ✓ (Rejected!)
```

---

## 🔐 How JWT Authentication Works

### Request Flow

```
Client Request
    ↓
JwtAuthenticationFilter
    ├─ Is it /api/auth/** ?
    │  └─ Yes: Skip validation, continue
    │  └─ No: Check Authorization header
    │
    ├─ Has Authorization header?
    │  └─ No: Continue without auth (403 later)
    │  └─ Yes: Extract token
    │
    ├─ Is token valid?
    │  └─ No: Continue without auth (403 later)
    │  └─ Yes: Set SecurityContext
    │
    └─ Continue to Controller
        ├─ Controller runs
        └─ Response sent
```

### Security Components

| Component | File | Purpose |
|-----------|------|---------|
| JWT Util | `JwtUtil.java` | Generate & validate tokens |
| Filter | `JwtAuthenticationFilter.java` | Intercept requests |
| Config | `SecurityConfig.java` | Configure security rules |
| Controller | `AuthController.java` | Issue tokens |

---

## ✅ Success Criteria

You'll know it's working when:

- [ ] Login returns token
- [ ] Token starts with `eyJ` (base64 header)
- [ ] Without token: 403 Forbidden
- [ ] With token: 200 OK + message
- [ ] Invalid token: 403 Forbidden

---

## 🐛 Troubleshooting Matrix

| Problem | Cause | Solution |
|---------|-------|----------|
| 404 on /hello | Typo in URL | Check: `http://localhost:8080/hello` |
| 403 on login | Not POST request | Use POST, not GET |
| Empty token response | Auth failed | Check credentials in body |
| Invalid token error | Malformed header | Format: `Bearer <token>` with space |
| Port already in use | Old process running | `lsof -i :8080 \| awk 'NR==2 {print $2}' \| xargs kill -9` |
| Token doesn't work | Expired | Tokens expire after 1 hour; get new one |
| 401 instead of 403 | Minor difference | Both mean auth failed; 401=no creds, 403=invalid |

---

## 📈 Testing Progression

### Level 1: Basic (What You're Doing Now)
- ✅ Get token via login
- ✅ Test with/without token
- ✅ Verify 403/200 responses

### Level 2: Intermediate
- ✅ Add role-based endpoints
- ✅ Test @PreAuthorize("hasRole('ADMIN')")
- ✅ Verify role checking

### Level 3: Advanced
- ✅ Test token expiration
- ✅ Implement token refresh
- ✅ Test with multiple users
- ✅ Load testing

---

## 💾 Files Reference

```
Project Root
├── QUICK_START_TESTING.md          ← Read this first
├── TESTING_GUIDE.md                ← Comprehensive guide
├── POSTMAN_VISUAL_GUIDE.md         ← Postman step-by-step
├── POSTMAN_ASCII_REFERENCE.md      ← Visual mockups
├── test-jwt.sh                     ← Automated tests
├── Spring-Security-JWT-Postman-Collection.json  ← Import this
│
└── src/main/java/.../
    ├── security/
    │   ├── JwtUtil.java            ← Token generation
    │   └── JwtAuthenticationFilter.java  ← Token validation
    ├── config/
    │   └── SecurityConfig.java     ← Security rules
    ├── auth/
    │   └── AuthController.java     ← Login endpoint
    └── HelloResource.java          ← Secured /hello endpoint
```

---

## 🎯 Next Steps After Testing

### Short Term (Today)
1. ✅ Run all 4 tests successfully
2. ✅ Understand the request/response flow
3. ✅ Decode token at jwt.io to see payload

### Medium Term (This Week)
1. ✅ Create 2-3 more secured endpoints
2. ✅ Add role-based authorization
3. ✅ Test with different roles

### Long Term (Production Ready)
1. ✅ Replace stubbed auth with real user lookup
2. ✅ Add database (User, Role entities)
3. ✅ Hash passwords with BCrypt
4. ✅ Implement token refresh
5. ✅ Add token blacklist for logout
6. ✅ Implement rate limiting
7. ✅ Add comprehensive logging
8. ✅ Set up HTTPS/SSL

---

## 📞 Getting Help

### If Tests Fail

1. **Check Application Started**
   ```bash
   curl http://localhost:8080/hello
   # Should get 403 (not 404 or connection refused)
   ```

2. **Check Token Format**
   - Should be: `Bearer eyJhbGciOi...` (with space)
   - Not: `BearereyJhbGciOi...` (no space)

3. **Check Headers**
   - Postman: Go to Headers tab
   - cURL: Use `-H "Authorization: Bearer..."`

4. **Check URL**
   - http://localhost:8080 (not localhost:8080 or http://localhost)
   - /hello (not /Hello or /hello/)

### Debug Logs

Enable debug logging in `application.properties`:
```properties
logging.level.sn.sdley=DEBUG
logging.level.org.springframework.security=DEBUG
```

---

## 🎓 Learning Objectives

After completing these tests, you'll understand:

- ✅ How JWT tokens are structured (header.payload.signature)
- ✅ How Spring Security intercepts requests
- ✅ How @Component filters work in Spring
- ✅ Stateless vs stateful authentication
- ✅ Bearer token authentication
- ✅ Role-based authorization patterns
- ✅ How to test secured endpoints
- ✅ Security best practices (HTTPS, token expiry, etc.)

---

## 🏆 You've Successfully Built

✅ JWT-based authentication system  
✅ Spring Security configuration  
✅ Custom authentication filter  
✅ Secured REST endpoint  
✅ Complete testing suite  
✅ Production-ready code structure  

---

## 📚 Resources

- **Spring Security Docs:** https://spring.io/projects/spring-security
- **JJWT Library:** https://github.com/jwtk/jjwt
- **JWT Debugger:** https://jwt.io/
- **Postman Learning:** https://learning.postman.com/
- **REST Security Best Practices:** https://owasp.org/www-community/attacks/HTTP_Request_Smuggling

---

**Ready to test? Start with `QUICK_START_TESTING.md` 🚀**

