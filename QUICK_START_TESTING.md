# Quick Start: Testing Your Secured /hello Endpoint

## 🎯 TL;DR (The Quick Version)

### 3 Simple Steps:

**Step 1: Get JWT Token**
```bash
POST http://localhost:8080/api/auth/login
Body: {"username":"testuser","password":"password123","role":"USER"}
```
→ Copy the `token` from response

**Step 2: Test WITHOUT Token (Should Fail)**
```bash
GET http://localhost:8080/hello
(No Authorization header)
```
→ Expect: **403 Forbidden** ❌

**Step 3: Test WITH Token (Should Succeed)**
```bash
GET http://localhost:8080/hello
Headers: Authorization: Bearer <YOUR_TOKEN>
```
→ Expect: **200 OK** ✅ with message "Welcome to Spring Security with JWT"

---

## 📱 Testing Options

### Option 1: Postman (GUI - Easiest for Beginners)

1. Download Postman: https://www.postman.com/downloads/
2. Import collection: `Spring-Security-JWT-Postman-Collection.json`
3. Follow the visual guide: See `POSTMAN_VISUAL_GUIDE.md`

**Pros:** User-friendly, saves requests, auto-extracts tokens
**Best for:** Learning and manual testing

### Option 2: cURL (Command Line - Fastest)

```bash
# Get token
TOKEN=$(curl -s -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","password":"password123","role":"USER"}' \
  | grep -o '"token":"[^"]*' | cut -d'"' -f4)

# Test with token
curl -H "Authorization: Bearer $TOKEN" http://localhost:8080/hello
```

**Pros:** Fast, scriptable, no GUI needed
**Best for:** Automation and CI/CD

### Option 3: Automated Script

```bash
chmod +x test-jwt.sh
./test-jwt.sh
```

**Pros:** Automated, tests all scenarios, colored output
**Best for:** Comprehensive testing

---

## 🔍 What's Actually Happening

### Flow Diagram

```
You (Client)
    ↓
    ├─→ POST /api/auth/login
    │   AuthController generates JWT ✓
    │   Returns token
    │
    ├─→ GET /hello (WITHOUT token)
    │   JwtAuthenticationFilter checks: No Authorization header
    │   Returns: 403 Forbidden ❌
    │
    └─→ GET /hello (WITH token)
        JwtAuthenticationFilter checks: Valid Bearer token
        Sets authentication in Spring Security ✓
        HelloResource processes request
        Returns: 200 OK + "Welcome to Spring Security with JWT" ✓
```

### Key Components

1. **AuthController** (`/api/auth/login`)
   - Takes username, password, role
   - Generates JWT token
   - Returns token to client

2. **JwtAuthenticationFilter**
   - Intercepts **all** incoming requests
   - Skips `/api/auth/**` endpoints (no validation)
   - For other endpoints: validates Bearer token
   - Sets Spring Security context if valid
   - Rejects if token missing/invalid → 403 Forbidden

3. **HelloResource** (`/hello`)
   - Secured endpoint
   - Requires valid JWT to access
   - Returns welcome message if authenticated

---

## ⚙️ Configuration

### Secured vs Public Endpoints

**Public (No JWT Required):**
- `POST /api/auth/login` - Get token
- `POST /api/auth/register` - Create account

**Secured (JWT Required):**
- `GET /hello` - Welcome message
- Any other endpoint (by default)

### How It Works

```java
// SecurityConfig.java
.authorizeHttpRequests(auth -> auth
    .requestMatchers("/api/auth/**").permitAll()  // Public
    .anyRequest().authenticated()                  // Secured
)
```

---

## 🧪 Expected Test Results

### Test 1: Login
```
Request:  POST /api/auth/login
Status:   200 OK ✅
Response: {
            "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
          }
```

### Test 2: /hello WITHOUT Token
```
Request:  GET /hello
Headers:  (none)
Status:   403 Forbidden ❌
Response: (empty or error)
```

### Test 3: /hello WITH Valid Token
```
Request:  GET /hello
Headers:  Authorization: Bearer <token>
Status:   200 OK ✅
Response: "Welcome to Spring Security with JWT"
```

### Test 4: /hello WITH Invalid Token
```
Request:  GET /hello
Headers:  Authorization: Bearer invalid.token
Status:   403 Forbidden ❌
Response: (empty or error)
```

---

## 🚀 Running Tests

### Step 1: Start the Application

```bash
# Terminal 1
cd /Users/sdley/Documents/Dev/Java/spring-security-jwt
mvn clean package -DskipTests
java -jar target/spring-security-jwt-0.0.1-SNAPSHOT.jar
```

Wait for: `Started SpringSecurityJwtApplication`

### Step 2: Run Tests

**Using Postman:**
- Open Postman
- Import `Spring-Security-JWT-Postman-Collection.json`
- Run each request in order

**Using cURL:**
```bash
# Terminal 2
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","password":"password123","role":"USER"}'
```

**Using Script:**
```bash
# Terminal 2
chmod +x test-jwt.sh
./test-jwt.sh
```

---

## ✅ Success Checklist

- [ ] Application running on port 8080
- [ ] Can login and get JWT token
- [ ] GET /hello WITHOUT token returns 403 Forbidden
- [ ] GET /hello WITH token returns 200 OK
- [ ] Response contains "Welcome to Spring Security with JWT"
- [ ] Token expires after 1 hour (can test later)

---

## 🐛 Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| Getting 404 on /hello | Check URL: should be `http://localhost:8080/hello` |
| Getting 403 on login | Use POST (not GET), rebuild with `mvn clean package` |
| Token doesn't work | Ensure "Bearer " prefix in Authorization header |
| Port 8080 in use | Kill process: `lsof -i :8080 \| grep LISTEN \| awk '{print $2}' \| xargs kill -9` |
| 401 vs 403 | Both mean auth failed; 401 = no creds, 403 = invalid creds |

---

## 📖 Detailed Guides

- **Full Testing Guide:** See `TESTING_GUIDE.md`
- **Visual Postman Steps:** See `POSTMAN_VISUAL_GUIDE.md`
- **Project README:** See `README.md`

---

## 💡 What's Next?

1. **Add More Endpoints**
   ```java
   @GetMapping("/api/user/profile")
   public UserProfile getProfile() { ... }
   ```

2. **Add Role-Based Access**
   ```java
   @PreAuthorize("hasRole('ADMIN')")
   @GetMapping("/api/admin/dashboard")
   public Dashboard getAdminDashboard() { ... }
   ```

3. **Implement Token Refresh**
   ```java
   @PostMapping("/api/auth/refresh")
   public Map<String, String> refresh(@RequestBody RefreshRequest req) { ... }
   ```

4. **Add Database Integration**
   - Store users in DB
   - Hash passwords with BCrypt
   - Manage roles and permissions

---

## 📞 Support

- Check logs: Look for Spring Security error messages in console
- Test endpoint: Use simple curl first before Postman
- Verify token: Decode at https://jwt.io/
- Read code comments: See `JwtUtil.java` and `JwtAuthenticationFilter.java`

---

**Happy Testing! 🎉**

