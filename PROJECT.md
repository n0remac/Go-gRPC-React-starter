# PROJECT.md

## Overview

This is a modern full-stack web application boilerplate that combines Go backend with React frontend, communicating via gRPC-Web using the Connect protocol. The project is designed as a starter template for building scalable, type-safe web applications with a robust client-server architecture.

## Purpose

The application serves as a production-ready starter kit that demonstrates:
- Modern gRPC-Web communication between frontend and backend
- Type-safe API contracts using Protocol Buffers
- User authentication and CRUD operations
- SQLite database integration
- Hot-reload development workflow

## Architecture

The application follows a three-tier architecture:

```
┌─────────────────┐
│  React Frontend │ (Port 8000)
│   (TypeScript)  │
└────────┬────────┘
         │ gRPC-Web/Connect
         │ HTTP/2
         ▼
┌─────────────────┐
│   Go Backend    │ (Port 8080)
│  (Connect-Go)   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ SQLite Database │
│  (mydatabase.db)│
└─────────────────┘
```

### Communication Flow

1. Frontend generates type-safe TypeScript clients from Protobuf definitions
2. Backend implements gRPC services using Connect-Go framework
3. Communication uses Connect protocol (gRPC-Web compatible) over HTTP/2
4. H2C (HTTP/2 Cleartext) is used for local development
5. CORS middleware enables cross-origin requests during development

## Technical Stack

### Backend
- **Language**: Go 1.21.4
- **Framework**: Connect-Go (v1.10.0) - Modern gRPC framework
- **Database ORM**: Upper.io (v4.7.0) for SQLite
- **Database**: SQLite 3 (go-sqlite3 driver)
- **Authentication**: JWT (dgrijalva/jwt-go) with bcrypt password hashing
- **Protocol**: HTTP/2 with H2C wrapper
- **Code Generation**: Buf CLI for Protocol Buffers

### Frontend
- **Framework**: React 18.2.0 with TypeScript
- **Routing**: React Router DOM v6
- **Styling**:
  - TailwindCSS 3.3.5
  - DaisyUI 4.4.19 (Tailwind component library)
  - Bootstrap 5.3.2 / React-Bootstrap
- **RPC Client**: Bufbuild Connect-Web (v0.13.0)
- **Build Tool**: esbuild (v0.19.5) with custom build script
- **Type Safety**: Full TypeScript support with generated types from Protobuf

### Communication Layer
- **Protocol Buffers**: Version 3 syntax
- **Code Generation Tools**:
  - `protoc-gen-go`: Generate Go structs
  - `protoc-gen-connect-go`: Generate Go service handlers
  - `protoc-gen-es`: Generate TypeScript types
  - `protoc-gen-connect-es`: Generate TypeScript service clients
- **Transport**: gRPC-Web via Connect protocol
- **Reflection**: gRPC reflection enabled for debugging (v1 and v1alpha)

## Major Components

### Backend Structure

#### 1. Main Server (`main.go`)
- HTTP/2 server setup with H2C
- Service registration and routing
- Global middleware:
  - CORS middleware (permissive for local dev)
  - Logging interceptor
  - Panic recovery
- Static file serving for images
- gRPC reflection endpoints

#### 2. User Service (`pkg/user/`)
- **Service Implementation** (`service.go`):
  - `CreateUser`: Register new users with password hashing
  - `GetUser`: Retrieve user by ID
  - `UpdateUser`: Update user information
  - `DeleteUser`: Remove user from database
  - `Login`: Authenticate users and issue JWT tokens
- **Data Model** (`model.go`):
  - User entity with username, email, password fields
  - Database CRUD operations
  - Password hashing with bcrypt (cost 10)

#### 3. Database Layer (`pkg/database/`)
- SQLite connection management using Upper.io
- Automatic table creation on initialization
- Users table schema with auto-incrementing IDs
- Session management for database operations

#### 4. Generated Code (`gen/`)
- Auto-generated from `.proto` files
- Go service interfaces and message types
- Connect-Go service handlers

### Frontend Structure

#### 1. Application Core
- **Entry Point** (`index.tsx`): React root mounting
- **Main App** (`App.tsx`):
  - React Router configuration
  - Navigation bar with Login/Register links
  - Route definitions

#### 2. Pages (`src/pages/`)
- **Login Page**: User authentication form
- **Register Page**: New user registration form

#### 3. RPC Layer (`src/rpc/`)
- Auto-generated TypeScript clients from Protobuf
- Type-safe service methods
- Request/Response message types

#### 4. Service Configuration (`service.ts`)
- Connect transport configuration
- Service client initialization (UserService)
- Base URL management from environment variables

#### 5. Build System (`esbuild.mjs`)
- Custom esbuild configuration
- Development/Production mode switching
- Hot-reload for development
- TailwindCSS integration

### Database Schema

```sql
CREATE TABLE Users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT NOT NULL,
  email TEXT NOT NULL,
  password TEXT NOT NULL  -- bcrypt hashed
);
```

## Unique Features

### 1. **Modern gRPC Stack**
   - Uses Connect protocol, which is compatible with gRPC but more browser-friendly
   - No need for proxy (Envoy) unlike traditional gRPC-Web
   - Works over standard HTTP/1.1 and HTTP/2

### 2. **Full Type Safety End-to-End**
   - Single source of truth in `.proto` files
   - Auto-generated types for both Go and TypeScript
   - Compile-time type checking across the entire stack
   - Eliminates API contract mismatches

### 3. **Automatic Code Generation**
   - `go generate` command regenerates all code from Protobuf
   - Buf CLI manages Protobuf compilation
   - Consistent types across frontend and backend

### 4. **Developer-Friendly Setup**
   - Simple cloning and renaming process
   - Hot-reload for frontend during development
   - Automatic database initialization
   - Built-in CORS handling for local development

### 5. **Production-Ready Security**
   - JWT-based authentication
   - Bcrypt password hashing
   - Token expiration (24-hour default)
   - Structured error handling with proper status codes

### 6. **Lightweight and Fast**
   - SQLite for zero-configuration database
   - esbuild for extremely fast frontend builds
   - No heavy ORM overhead
   - Minimal dependencies

### 7. **gRPC Reflection Support**
   - Both v1 and v1alpha reflection protocols
   - Enables debugging with tools like grpcurl and Postman
   - Service introspection without documentation

## Project Structure

```
.
├── main.go                    # Backend entry point
├── go.mod                     # Go dependencies
├── package.json               # Node.js dependencies
├── buf.gen.yaml              # Protobuf code generation config
├── proto/                    # Protocol Buffer definitions
│   └── user/
│       └── user.proto        # User service definition
├── pkg/                      # Backend packages
│   ├── database/
│   │   └── database.go       # Database initialization
│   └── user/
│       ├── model.go          # User data access layer
│       └── service.go        # User service implementation
├── gen/                      # Generated Go code (auto-generated)
│   └── proto/
│       └── user/
├── frontend/                 # React application
│   ├── esbuild.mjs          # Build configuration
│   ├── tailwind.config.js   # TailwindCSS config
│   ├── tsconfig.json        # TypeScript config
│   └── src/
│       ├── index.tsx        # React entry point
│       ├── App.tsx          # Main application component
│       ├── service.ts       # RPC client setup
│       ├── pages/           # React pages
│       │   └── user/
│       │       ├── Login.tsx
│       │       └── Register.tsx
│       ├── rpc/             # Generated TypeScript code
│       │   └── proto/
│       │       └── user/
│       └── styles/
│           └── tailwind.css
└── mydatabase.db            # SQLite database (created at runtime)
```

## Development Workflow

### Adding New Services

1. Define service in `proto/<service>/<service>.proto`
2. Run `go generate .` to generate code
3. Create service implementation in `pkg/<service>/service.go`
4. Register service handler in `main.go`
5. Add service client to `frontend/src/service.ts`
6. Create React components to consume the service

### Key Commands

```bash
# Frontend
npm run dev          # Start development server with hot reload
npm run build        # Production build

# Backend
go run main.go       # Start Go server
go generate .        # Regenerate Protobuf code
go mod tidy          # Update Go dependencies

# Code Generation
npx buf generate     # Manually trigger Protobuf generation
```

## Configuration

### Environment Variables
- `BASE_URL`: Backend API endpoint (frontend)
- `DEV`: Development mode flag for esbuild

### Ports
- Frontend: 8000 (esbuild dev server)
- Backend: 8080 (Go HTTP server)

### Security Notes
- JWT secret key should be replaced in production (`pkg/user/service.go:18`)
- CORS is currently permissive for development and should be restricted in production
- HTTPS should be enabled for production deployments

## Future Enhancements

Potential areas for extension:
- Add more authentication methods (OAuth, social login)
- Implement refresh token mechanism
- Add rate limiting and request validation
- Database migrations system
- Docker containerization
- CI/CD pipeline configuration
- Environment-specific configuration management
- Unit and integration tests
- WebSocket support for real-time features
- File upload handling
- Pagination for list endpoints
