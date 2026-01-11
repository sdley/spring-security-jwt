# Spring Boot JWT Authentication & Authorization Demo

A production-ready demonstration of JWT (JSON Web Token) based authentication and authorization using Spring Boot and Spring Security.

## 🎯 Overview

This project showcases best practices for implementing secure JWT-based authentication and authorization in Spring Boot applications. It demonstrates how to:

- **Authenticate users** with JWT tokens
- **Authorize requests** based on user roles and permissions
- **Validate and refresh** JWT tokens
- **Handle security** with Spring Security integration
- **Protect endpoints** with custom security filters

## ✨ Features

- ✅ JWT token generation and validation
- ✅ Role-based access control (RBAC)
- ✅ Stateless authentication
- ✅ Token refresh mechanism
- ✅ Spring Security integration
- ✅ Custom authentication filters
- ✅ RESTful API endpoints
- ✅ Exception handling for security errors

## 🛠️ Tech Stack

| Technology | Version | Purpose |
|-----------|---------|---------|
| **Java** | 17 | Programming language |
| **Spring Boot** | 4.0.1 | Application framework |
| **Spring Security** | 4.0.1 | Security framework |
| **JWT (JJWT)** | 0.11.5 | Token generation & validation |
| **Maven** | Latest | Build tool |

## 📋 Prerequisites

Before running this project, ensure you have:

- **Java Development Kit (JDK)** 17 or higher
- **Maven** 3.6.0 or higher
- **Git** (optional, for cloning the repository)
- An IDE such as IntelliJ IDEA, VS Code, or Eclipse

### Verify Installation

```bash
java -version
mvn -version
```

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone <repository-url>
cd spring-security-jwt
```

### 2. Install Dependencies

```bash
mvn clean install
```

### 3. Run the Application

```bash
mvn spring-boot:run
```

Or build and run the JAR:

```bash
mvn clean package
java -jar target/spring-security-jwt-0.0.1-SNAPSHOT.jar
```

The application will start on **http://localhost:8080**

## 📡 API Endpoints

### Public Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/auth/register` | Register a new user |
| `POST` | `/api/auth/login` | Authenticate user and get JWT token |
| `GET` | `/hello` | Welcome endpoint (no authentication required) |

### Protected Endpoints

| Method | Endpoint | Required Role | Description |
|--------|----------|--------------|-------------|
| `GET` | `/api/user/profile` | `USER` | Get authenticated user profile |
| `GET` | `/api/admin/dashboard` | `ADMIN` | Access admin dashboard |
| `POST` | `/api/user/refresh-token` | `USER` | Refresh JWT token |

## 🔐 Authentication Flow

```
┌──────────────┐
│   Client     │
└──────┬───────┘
       │
       ├─────────── POST /api/auth/login (credentials) ───────>
       │                                                  ┌──────────────┐
       │                                                  │ Spring Boot  │
       │                                         <────────┤   Service    │
       │ ◄────── 200 OK {token: "JWT_TOKEN"} ───────────┤              │
       │                                                  └──────────────┘
       │
       ├─ GET /api/user/profile (Authorization: Bearer JWT_TOKEN) ─>
       │                                                  ┌──────────────┐
       │                                                  │ JWT Filter   │
       │                                                  │ Validates    │
       │                                         <────────┤   Token      │
       │ ◄───────── 200 OK {user_data} ─────────────────┤              │
       │                                                  └──────────────┘
       │
       ├─ POST /api/user/refresh-token ─>
       │                                                  ┌──────────────┐
       │                                         <────────┤ New JWT      │
       │ ◄────── 200 OK {token: "NEW_JWT_TOKEN"} ───────┤ Generated    │
       │                                                  └──────────────┘
```

## 🔑 JWT Token Structure

JWT tokens consist of three parts separated by dots (`.`):

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1c2VyMTIzIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
│─────────────────────────────────────────────────┘ │───────────────────────────────────────────────────┘ │──────────────────────────────────────────┘
         Header (Algorithm & Type)                              Payload (Claims)                                   Signature (Verification)
```

### Token Claims

```json
{
  "sub": "user123",
  "name": "John Doe",
  "email": "john@example.com",
  "roles": ["USER", "ADMIN"],
  "iat": 1516239022,
  "exp": 1516242622
}
```

## 📝 Configuration

### Application Properties

Create or update `src/main/resources/application.properties`:

```properties
# Server Configuration
server.port=8080

# JWT Configuration
jwt.secret=your-super-secret-key-change-this-in-production
jwt.expiration=3600000
jwt.refresh-expiration=604800000

# Spring Security
spring.security.user.name=admin
spring.security.user.password=password

# Logging
logging.level.root=INFO
logging.level.sn.sdley=DEBUG
```

### Environment Variables

For production, use environment variables instead of hardcoding secrets:

```bash
export JWT_SECRET="your-production-secret"
export JWT_EXPIRATION=3600000
```

## 🔐 Security Best Practices

### 1. **Secret Management**
- Never hardcode JWT secrets
- Use environment variables or config servers
- Rotate secrets periodically

### 2. **Token Expiration**
- Set appropriate expiration times (typically 15 minutes to 1 hour)
- Implement refresh token mechanism
- Invalidate tokens on logout

### 3. **HTTPS**
- Always use HTTPS in production
- Configure SSL/TLS certificates

### 4. **CORS Configuration**
```properties
spring.web.cors.allowed-origins=https://yourdomain.com
spring.web.cors.allowed-methods=GET,POST,PUT,DELETE
spring.web.cors.allowed-headers=*
spring.web.cors.allow-credentials=true
```

### 5. **Password Security**
- Hash passwords using BCrypt or Argon2
- Enforce strong password policies
- Implement rate limiting on login attempts

## 🧪 Testing

### Run Unit Tests

```bash
mvn test
```

### Run Integration Tests

```bash
mvn test -P integration-tests
```

### Manual API Testing with cURL

**Login:**
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"user123","password":"password123"}'
```

**Access Protected Endpoint:**
```bash
curl -X GET http://localhost:8080/api/user/profile \
  -H "Authorization: Bearer <JWT_TOKEN_HERE>"
```

### Using Postman

1. Import the provided Postman collection (if available)
2. Set the `{{jwt_token}}` variable in environments
3. Use pre-request scripts to automatically update tokens

## 📚 Project Structure

```
spring-security-jwt/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── sn/sdley/spring_security_jwt/
│   │   │       ├── SpringSecurityJwtApplication.java    # Main application class
│   │   │       ├── HelloResource.java                   # Sample resource
│   │   │       ├── controller/
│   │   │       │   ├── AuthController.java              # Authentication endpoints
│   │   │       │   └── UserController.java              # User endpoints
│   │   │       ├── service/
│   │   │       │   ├── UserService.java                 # User business logic
│   │   │       │   └── JwtService.java                  # JWT operations
│   │   │       ├── security/
│   │   │       │   ├── JwtFilter.java                   # JWT validation filter
│   │   │       │   ├── SecurityConfig.java              # Security configuration
│   │   │       │   └── JwtUtil.java                     # JWT utility methods
│   │   │       ├── entity/
│   │   │       │   └── User.java                        # User entity
│   │   │       ├── dto/
│   │   │       │   ├── LoginRequest.java                # Login request DTO
│   │   │       │   ├── LoginResponse.java               # Login response DTO
│   │   │       │   └── UserDTO.java                     # User DTO
│   │   │       └── exception/
│   │   │           └── JwtException.java                # JWT exceptions
│   │   └── resources/
│   │       ├── application.properties                   # Configuration
│   │       ├── static/                                  # Static assets
│   │       └── templates/                               # Template files
│   └── test/
│       └── java/
│           └── sn/sdley/spring_security_jwt/
│               └── SpringSecurityJwtApplicationTests.java
├── pom.xml                                              # Maven configuration
├── README.md                                            # This file
└── .gitignore                                           # Git ignore rules
```

## 🔄 Workflow Example

### 1. User Registration

```json
POST /api/auth/register
Content-Type: application/json

{
  "username": "john_doe",
  "email": "john@example.com",
  "password": "SecurePassword123!"
}
```

**Response:**
```json
{
  "id": 1,
  "username": "john_doe",
  "email": "john@example.com",
  "roles": ["USER"]
}
```

### 2. User Login

```json
POST /api/auth/login
Content-Type: application/json

{
  "username": "john_doe",
  "password": "SecurePassword123!"
}
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expiresIn": 3600,
  "user": {
    "id": 1,
    "username": "john_doe",
    "email": "john@example.com",
    "roles": ["USER"]
  }
}
```

### 3. Access Protected Resource

```
GET /api/user/profile
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 4. Refresh Token

```json
POST /api/user/refresh-token
Content-Type: application/json

{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

## 🐛 Troubleshooting

### Issue: "Invalid JWT token" error

**Solution:**
- Verify token hasn't expired
- Check JWT secret matches between generation and validation
- Ensure token format is correct (Bearer prefix)

### Issue: "401 Unauthorized" on protected endpoints

**Solution:**
- Confirm you're including the Authorization header
- Format: `Authorization: Bearer <token>`
- Verify user has required roles

### Issue: CORS errors

**Solution:**
- Configure CORS in `SecurityConfig`
- Add allowed origins to `application.properties`
- Check browser console for specific errors

### Issue: "Secret key too short"

**Solution:**
- Use a secret key with at least 256 bits (32 characters)
- Generate a secure key: `openssl rand -base64 32`

## 📈 Performance Optimization

1. **Token Caching:** Cache decoded tokens to reduce CPU usage
2. **Database Queries:** Index user lookups by username/email
3. **Connection Pooling:** Configure HikariCP for database connections
4. **Rate Limiting:** Implement rate limiting on authentication endpoints

```properties
# HikariCP Configuration
spring.datasource.hikari.maximum-pool-size=10
spring.datasource.hikari.minimum-idle=5
```

## 🚀 Deployment

### Docker

```dockerfile
FROM openjdk:17-slim
COPY target/spring-security-jwt-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
```

### Build and Run:

```bash
docker build -t spring-security-jwt .
docker run -p 8080:8080 -e JWT_SECRET=your-secret spring-security-jwt
```

### Kubernetes

See `k8s/` directory for Kubernetes manifests.

## 📖 Additional Resources

- [Spring Security Documentation](https://spring.io/projects/spring-security)
- [JJWT GitHub](https://github.com/jwtk/jjwt)
- [JWT.io Debugger](https://jwt.io/)
- [OAuth 2.0 RFC 6749](https://tools.ietf.org/html/rfc6749)
- [Spring Boot Best Practices](https://docs.spring.io/spring-boot/docs/current/reference/html/)

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Please ensure:
- Code follows Spring conventions
- All tests pass
- Security best practices are maintained
- Documentation is updated

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**sdley**  
Email: [sdley2020@gmail.com]  
GitHub: [@sdley](https://github.com/sdley)

## 🎓 Learning Outcomes

After studying this project, you'll understand:

- ✅ How JWT tokens work and their structure
- ✅ Implementing authentication with Spring Security
- ✅ Creating authorization rules with role-based access control
- ✅ Building stateless APIs
- ✅ Securing endpoints with custom filters
- ✅ Handling security exceptions gracefully
- ✅ Testing security implementations
- ✅ Deploying secure Spring Boot applications

## 📞 Support & Questions

For questions or issues:
1. Check existing GitHub issues
2. Review the troubleshooting section
3. Create a new GitHub issue with detailed information
4. Contact the maintainer

---

**Last Updated:** January 2026  
**Version:** 0.0.1-SNAPSHOT

