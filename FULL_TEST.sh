#!/bin/bash

# Kill any existing process
pkill -f "java -jar" 2>/dev/null

# Wait
sleep 2

# Start fresh
cd /Users/sdley/Documents/Dev/Java/spring-security-jwt

echo "🔨 Building application..."
mvn clean package -DskipTests -q

if [ $? -ne 0 ]; then
  echo "❌ Build failed"
  exit 1
fi

echo "✅ Build successful"
echo ""

echo "🚀 Starting application..."
java -jar target/spring-security-jwt-0.0.1-SNAPSHOT.jar > /tmp/jwt-app.log 2>&1 &
APP_PID=$!

sleep 5

if ! kill -0 $APP_PID 2>/dev/null; then
  echo "❌ Application failed to start"
  echo "Log:"
  tail -30 /tmp/jwt-app.log
  exit 1
fi

echo "✅ Application started (PID: $APP_PID)"
echo ""

# Test 1: Login
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔐 TEST 1: Login to get JWT token"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

TOKEN=$(curl -s -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","password":"pass","role":"USER"}' \
  | grep -o '"token":"[^"]*' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
  echo "❌ FAIL: Could not get token"
  echo "Response:"
  curl -s -X POST http://localhost:8080/api/auth/login \
    -H "Content-Type: application/json" \
    -d '{"username":"testuser","password":"pass","role":"USER"}'
  exit 1
fi

echo "✅ PASS: Token obtained"
echo "Token: ${TOKEN:0:50}..."
echo ""

# Test 2: /hello without token
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔒 TEST 2: GET /hello WITHOUT token (should be 403)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/hello)

if [ "$CODE" = "403" ]; then
  echo "✅ PASS: Got 403 Forbidden (endpoint is protected)"
else
  echo "❌ FAIL: Expected 403 but got $CODE"
fi
echo ""

# Test 3: /hello with valid token
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔓 TEST 3: GET /hello WITH valid token (should be 200)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

RESPONSE=$(curl -s -H "Authorization: Bearer $TOKEN" http://localhost:8080/hello)
CODE=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer $TOKEN" http://localhost:8080/hello)

if [ "$CODE" = "200" ]; then
  echo "✅ PASS: Got 200 OK"
  echo "Response: $RESPONSE"
else
  echo "❌ FAIL: Expected 200 but got $CODE"
  echo "Response: $RESPONSE"
fi
echo ""

# Test 4: /hello with invalid token
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚫 TEST 4: GET /hello WITH invalid token (should be 403)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

CODE=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer invalid.token.here" http://localhost:8080/hello)

if [ "$CODE" = "403" ]; then
  echo "✅ PASS: Got 403 Forbidden (invalid token rejected)"
else
  echo "❌ FAIL: Expected 403 but got $CODE"
fi
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 ALL TESTS COMPLETED!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ JWT Authentication is working!"
echo ""
echo "Server is running on: http://localhost:8080"
echo "Logs: tail -f /tmp/jwt-app.log"
echo ""

