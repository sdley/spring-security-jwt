# Testing Secured /hello Endpoint with JWT

This guide shows how to test your Spring Boot JWT authentication with the secured `/hello` endpoint.

## Prerequisites

- Application running on `http://localhost:8080`
- Postman or curl installed
- The app has been rebuilt with the latest security config changes

## 🚀 Testing Workflow

### Step 1: Login to Get JWT Token

**Request:**
```
POST http://localhost:8080/api/auth/login
Content-Type: application/json

{
  "username": "testuser",
  "password": "password123",
  "role": "USER"
}
```

**Response (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ0ZXN0dXNlciIsInJvbGVzIjoiVVNFUiIsImlhdCI6MTczNjYxNDQyMCwiZXhwIjoxNzM2NjE4MDIwfQ.abc123..."
}
```

**⚠️ Important:** Copy the entire `token` value (the long JWT string). You'll need this for the next step.

---

### Step 2: Test /hello WITHOUT Token (Should Fail)

**Request:**
```
GET http://localhost:8080/hello
```

**No Authorization Header**

**Expected Response (403 Forbidden):**
```
403 Forbidden
```

**Why?** The `/hello` endpoint is now secured and requires a valid JWT token.

---

### Step 3: Test /hello WITH Valid Token (Should Succeed)

**Request:**
```
GET http://localhost:8080/hello
Authorization: Bearer <paste_token_from_step_1_here>
Content-Type: application/json
```

**Example with actual token:**
```
GET http://localhost:8080/hello
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ0ZXN0dXNlciIsInJvbGVzIjoiVVNFUiIsImlhdCI6MTczNjYxNDQyMCwiZXhwIjoxNzM2NjE4MDIwfQ.abc123...
```

**Expected Response (200 OK):**
```
200 OK

"Welcome to Spring Security with JWT"
```

**✅ Success!** You authenticated with JWT and accessed a secured endpoint.

---

## 📌 Postman Step-by-Step Guide

### 1. Create Login Request

1. Open Postman
2. Create a new request (Ctrl+Shift+N or Cmd+Shift+N)
3. Set method to **POST**
4. Set URL to `http://localhost:8080/api/auth/login`
5. Go to **Headers** tab
   - Add: `Content-Type: application/json`
6. Go to **Body** tab
   - Select **raw** and **JSON**
   - Paste:
   ```json
   {
     "username": "testuser",
     "password": "password123",
     "role": "USER"
   }
   ```
7. Click **Send**
8. You'll see the token in the response

### 2. Save Token to Variable

1. In the response, right-click on the `token` value
2. Select **Set: jwt_token** (or create a new variable)
3. Or manually copy the token value

### 3. Create Secured Endpoint Request (Without Token)

1. Create a new request
2. Set method to **GET**
3. Set URL to `http://localhost:8080/hello`
4. **DO NOT add Authorization header**
5. Click **Send**
6. **Expected:** 403 Forbidden

### 4. Create Secured Endpoint Request (With Token)

1. Create another GET request to `http://localhost:8080/hello`
2. Go to **Headers** tab
3. Add header:
   - Key: `Authorization`
   - Value: `Bearer {{jwt_token}}` (if using variable) OR paste the full token
4. Click **Send**
5. **Expected:** 200 OK with message

---

## 🔧 cURL Testing

If you prefer command line, use curl:

### Login and Save Token

```bash
# Login and extract token
TOKEN=$(curl -s -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","password":"password123","role":"USER"}' \
  | grep -o '"token":"[^"]*' | cut -d'"' -f4)

echo "Token: $TOKEN"
```

### Test Without Token (Should Fail)

```bash
curl -v http://localhost:8080/hello
# Expected: 403 Forbidden
```

### Test With Token (Should Succeed)

```bash
curl -v http://localhost:8080/hello \
  -H "Authorization: Bearer $TOKEN"
# Expected: 200 OK with "Welcome to Spring Security with JWT"
```

### Combined One-Liner

```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","password":"password123","role":"USER"}' \
  | python3 -m json.tool

# Then use the token from above response in:
curl http://localhost:8080/hello \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

---

## 🧪 Test Scenarios

| Scenario | Request | Expected Result |
|----------|---------|-----------------|
| No authentication | `GET /hello` (no token) | **403 Forbidden** ❌ |
| Valid JWT token | `GET /hello` with Bearer token | **200 OK** ✅ |
| Expired token | `GET /hello` with expired token | **403/401 Unauthorized** ❌ |
| Malformed token | `GET /hello` with invalid format | **403 Forbidden** ❌ |
| Login successful | `POST /api/auth/login` with credentials | **200 OK** + token ✅ |

---

## 🔍 How JWT Validation Works

1. **Request arrives** → `/hello` endpoint
2. **JWT Filter intercepts** → `JwtAuthenticationFilter`
3. **Filter checks path** → Not `/api/auth/**`, so validates JWT
4. **Extract Authorization header** → Look for `Bearer <token>`
5. **Parse JWT token** → Decode and verify signature
6. **Set Security Context** → If valid, add to Spring Security context
7. **Continue request** → If invalid, 403 Forbidden
8. **Controller processes** → If authenticated, returns 200 OK

---

## ⏱️ Token Expiration

- **Expiration time:** 1 hour (from `JwtUtil.java`)
- **Generated at:** When you login
- **Expires at:** 1 hour after generation

After expiration, you'll get **403 Forbidden** and need to login again to get a new token.

---

## 🐛 Troubleshooting

### Getting 403 on /hello even with token?

**Possible causes:**
1. Token has expired → Login again to get new token
2. Wrong Authorization header format → Must be `Bearer <token>` (with space)
3. Token copy/paste error → Paste the full token value
4. Server not rebuilt → Run `mvn clean package` and restart

### Getting 401 instead of 403?

- 401 = Unauthorized (no credentials provided)
- 403 = Forbidden (credentials invalid/expired)
- Both mean you need valid JWT to access

### Token is very long, is that normal?

**Yes!** JWT tokens in format `header.payload.signature` are typically 200-500+ characters.

---

## 📊 Quick Reference

```
ENDPOINT        METHOD  AUTH     STATUS
/api/auth/login POST    ❌ None  200 OK (returns token)
/hello          GET     ✅ JWT   200 OK (secured)
/hello          GET     ❌ None  403 Forbidden
```

---

## Next Steps

- Test with Postman using the step-by-step guide above
- Try curl commands for automation
- Create more secured endpoints following the same `/hello` pattern
- Add role-based authorization (e.g., `/admin` requires ADMIN role)
- Implement token refresh mechanism

