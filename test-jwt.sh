#!/bin/bash

# Spring Boot JWT Testing Script
# Tests the secured /hello endpoint with and without JWT token

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

API_URL="http://localhost:8080"

echo "================================"
echo "Spring Boot JWT Testing Script"
echo "================================"
echo ""

# Test 1: Login to get token
echo -e "${YELLOW}[Step 1]${NC} Logging in to get JWT token..."
LOGIN_RESPONSE=$(curl -s -X POST "$API_URL/api/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "password": "password123",
    "role": "USER"
  }')

TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"token":"[^"]*' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
  echo -e "${RED}❌ Failed to get token. Response: $LOGIN_RESPONSE${NC}"
  exit 1
fi

echo -e "${GREEN}✅ Successfully logged in!${NC}"
echo -e "${GREEN}Token: ${TOKEN:0:50}...${NC}"
echo ""

# Test 2: Access /hello WITHOUT token (should fail with 403)
echo -e "${YELLOW}[Step 2]${NC} Testing /hello WITHOUT token (should return 403)..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL/hello")

if [ "$HTTP_CODE" = "403" ]; then
  echo -e "${GREEN}✅ Correctly returned 403 Forbidden${NC}"
else
  echo -e "${RED}❌ Expected 403 but got $HTTP_CODE${NC}"
fi
echo ""

# Test 3: Access /hello WITH valid token (should succeed with 200)
echo -e "${YELLOW}[Step 3]${NC} Testing /hello WITH valid JWT token (should return 200)..."
RESPONSE=$(curl -s -w "\n%{http_code}" "$API_URL/hello" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json")

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | head -n1)

if [ "$HTTP_CODE" = "200" ]; then
  echo -e "${GREEN}✅ Correctly returned 200 OK${NC}"
  echo -e "${GREEN}Response: $BODY${NC}"
else
  echo -e "${RED}❌ Expected 200 but got $HTTP_CODE${NC}"
  echo "Response: $BODY"
fi
echo ""

# Test 4: Access /hello WITH invalid token (should fail with 403)
echo -e "${YELLOW}[Step 4]${NC} Testing /hello WITH invalid token (should return 403)..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL/hello" \
  -H "Authorization: Bearer invalid.token.here")

if [ "$HTTP_CODE" = "403" ]; then
  echo -e "${GREEN}✅ Correctly returned 403 Forbidden${NC}"
else
  echo -e "${RED}❌ Expected 403 but got $HTTP_CODE${NC}"
fi
echo ""

echo "================================"
echo -e "${GREEN}✅ All tests completed!${NC}"
echo "================================"

