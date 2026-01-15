# Visual Postman Testing Guide - JWT Secured /hello Endpoint

## 📋 Overview

This guide provides step-by-step visual instructions for testing your JWT-secured `/hello` endpoint using Postman.

---

## 🔐 Architecture Recap

```
┌─────────────┐
│   Postman   │
└──────┬──────┘
       │
       ├─── (1) POST /api/auth/login ────────────┐
       │                                          │
       │                                    ┌─────▼──────────┐
       │                                    │ AuthController │
       │                                    │ (Generates JWT)│
       │                                    └─────┬──────────┘
       │                                          │
       │◄─── (1) {token: "JWT......"} ───────────┘
       │
       ├─── (2) GET /hello (NO Token) ──────────┐
       │                                        │
       │                                  ┌─────▼────────────────┐
       │                                  │ JwtAuthenticationFilter
       │                                  │ (Validates Token)    │
       │                                  └─────┬────────────────┘
       │                                        │
       │◄─── (2) 403 Forbidden ─────────────────┘ (No token found)
       │
       ├─── (3) GET /hello (WITH Token) ──────┐
       │        Authorization: Bearer JWT...   │
       │                                       │
       │                                 ┌─────▼────────────────┐
       │                                 │ JwtAuthenticationFilter
       │                                 │ (Validates Token)    │
       │                                 │ ✓ Token valid        │
       │                                 └─────┬────────────────┘
       │                                       │
       │                                 ┌─────▼──────────┐
       │                                 │HelloResource   │
       │                                 │(Processes req) │
       │                                 └─────┬──────────┘
       │                                       │
       │◄─── (3) 200 OK ─────────────────────┘
       │    "Welcome to Spring Security..."
```

---

## 🚀 Test 1: Login to Get JWT Token

### Postman Setup

**Step 1.1:** Create new request
- Click **+ New** → **Request**
- Name: "Login - Get JWT Token"
- Save to appropriate folder

**Step 1.2:** Configure HTTP Method
```
Method: POST
```

**Step 1.3:** Enter URL
```
URL: http://localhost:8080/api/auth/login
```

**Step 1.4:** Add Headers
```
Tab: Headers
┌─────────────────┬────────────────────┐
│ Key             │ Value              │
├─────────────────┼────────────────────┤
│ Content-Type    │ application/json   │
└─────────────────┴────────────────────┘
```

**Step 1.5:** Add Request Body
```
Tab: Body → Select "raw" → Select "JSON" from dropdown

{
  "username": "testuser",
  "password": "password123",
  "role": "USER"
}
```

**Step 1.6:** Send Request
- Click blue **Send** button
- Status should show **200 OK**

**Step 1.7:** Examine Response
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ0ZXN0dXNlciIsInJvbGVzIjoiVVNFUiIsImlhdCI6MTczNjYxNDQyMCwiZXhwIjoxNzM2NjE4MDIwfQ.abc123..."
}
```

**⭐ ACTION:** Copy the entire `token` value (including the quotes removal)
- Select the token string (long JWT value)
- Copy it (Ctrl+C or Cmd+C)
- Save it somewhere temporarily

---

## ❌ Test 2: Access /hello WITHOUT Token (Should Fail)

### Purpose
Verify that the endpoint is protected and rejects unauthenticated requests.

### Postman Setup

**Step 2.1:** Create new request
- Click **+ New** → **Request**
- Name: "Test /hello - NO Token (Should Fail 403)"

**Step 2.2:** Configure HTTP Method
```
Method: GET
```

**Step 2.3:** Enter URL
```
URL: http://localhost:8080/hello
```

**Step 2.4:** Headers (Leave EMPTY - NO Authorization header)
```
Tab: Headers
(Should be empty)
```

**Step 2.5:** Send Request
- Click blue **Send** button
- Status should show **403 Forbidden** (red)

**Expected Result:**
```
403 Forbidden

(empty or error body)
```

**✅ Success!** This confirms the endpoint is protected.

---

## ✅ Test 3: Access /hello WITH Valid Token (Should Succeed)

### Purpose
Verify that authenticated requests with valid JWT can access the secured endpoint.

### Postman Setup

**Step 3.1:** Create new request
- Click **+ New** → **Request**
- Name: "Test /hello - WITH Valid Token (Should Succeed 200)"

**Step 3.2:** Configure HTTP Method
```
Method: GET
```

**Step 3.3:** Enter URL
```
URL: http://localhost:8080/hello
```

**Step 3.4:** Add Authorization Header
```
Tab: Headers
┌────────────────┬──────────────────────────────────────────────────┐
│ Key            │ Value                                            │
├────────────────┼──────────────────────────────────────────────────┤
│ Authorization  │ Bearer <PASTE_YOUR_TOKEN_HERE>                  │
└────────────────┴──────────────────────────────────────────────────┘

Example with actual token:
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ0ZXN0dXNlciIsInJvbGVzIjoiVVNFUiIsImlhdCI6MTczNjYxNDQyMCwiZXhwIjoxNzM2NjE4MDIwfQ.abc123...
```

**⭐ IMPORTANT:** 
- Keep the **"Bearer "** prefix (with space)
- Paste the full token after "Bearer "
- No quotation marks around the token value

**Step 3.5:** Send Request
- Click blue **Send** button
- Status should show **200 OK** (green)

**Expected Result:**
```
200 OK

"Welcome to Spring Security with JWT"
```

**✅ Success!** You've authenticated with JWT and accessed the secured endpoint!

---

## 🔴 Test 4: Access /hello WITH Invalid Token (Should Fail)

### Purpose
Verify that the endpoint rejects malformed or invalid JWT tokens.

### Postman Setup

**Step 4.1:** Create new request
- Click **+ New** → **Request**
- Name: "Test /hello - WITH Invalid Token (Should Fail 403)"

**Step 4.2:** Configure HTTP Method
```
Method: GET
```

**Step 4.3:** Enter URL
```
URL: http://localhost:8080/hello
```

**Step 4.4:** Add Invalid Authorization Header
```
Tab: Headers
┌────────────────┬──────────────────────────────────┐
│ Key            │ Value                            │
├────────────────┼──────────────────────────────────┤
│ Authorization  │ Bearer invalid.token.here        │
└────────────────┴──────────────────────────────────┘
```

**Step 4.5:** Send Request
- Click blue **Send** button
- Status should show **403 Forbidden** (red)

**Expected Result:**
```
403 Forbidden

(empty or error body)
```

**✅ Success!** This confirms invalid tokens are rejected.

---

## 💾 Save Requests to Environment Variables (Optional but Recommended)

### Method 1: Manual Copy-Paste (Easy)

1. After Test 1 (Login), copy the token
2. In Test 3 & 4, paste it in the Authorization header

### Method 2: Auto-Extract Token (Advanced)

**In Test 1 (Login Request):**

1. Go to **Tests** tab
2. Paste this script:
```javascript
if (pm.response.code === 200) {
    var jsonData = pm.response.json();
    pm.environment.set('jwt_token', jsonData.token);
    console.log('✅ Token saved to environment');
}
```
3. Run the request

**In Test 3 & 4:**

Use `{{jwt_token}}` in the Authorization header:
```
Authorization: Bearer {{jwt_token}}
```

---

## 📊 Test Results Summary

| Test | Request | Expected | Result |
|------|---------|----------|--------|
| 1 | POST /api/auth/login | 200 OK + token | ✅ Pass |
| 2 | GET /hello (no token) | 403 Forbidden | ✅ Pass |
| 3 | GET /hello (valid token) | 200 OK + message | ✅ Pass |
| 4 | GET /hello (invalid token) | 403 Forbidden | ✅ Pass |

---

## 🔧 Troubleshooting Postman Issues

### Issue: Getting 401 instead of 403
**Solution:** Ensure your Authorization header is correctly formatted:
```
✗ Wrong:   Authorization: eyJhbGciOi... (no Bearer prefix)
✗ Wrong:   Authorization: Bearer " JWT..." (extra quotes)
✓ Correct: Authorization: Bearer eyJhbGciOi...
```

### Issue: Getting 404 on /hello
**Solution:** Check URL spelling:
```
✗ Wrong:   http://localhost:8080/Hello (capital H)
✗ Wrong:   http://localhost:8080/hello/ (trailing slash)
✓ Correct: http://localhost:8080/hello
```

### Issue: Token works once, then fails
**Cause:** JWT tokens expire after 1 hour
**Solution:** Run Test 1 again to get a fresh token

### Issue: "Unexpected end of JSON input"
**Solution:** Make sure you copied the full token without extra characters

---

## 🎯 Next Steps

After successfully testing:
1. ✅ Create additional secured endpoints (e.g., `/api/user/profile`)
2. ✅ Implement role-based authorization (e.g., `/admin` requires ADMIN role)
3. ✅ Add token refresh mechanism
4. ✅ Implement proper exception handling
5. ✅ Add logout functionality with token blacklisting

---

## 📚 Reference

- **JWT Token Format:** `header.payload.signature`
- **Token Lifetime:** 1 hour (configurable in `JwtUtil.java`)
- **Authorization Header Format:** `Bearer <token>`
- **Security Filter:** `JwtAuthenticationFilter.java` intercepts all requests except `/api/auth/**`

