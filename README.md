# Go, gRPC, and React starter boilerplate.

## Features
- **SQL light backend**
- **Connect and wire framework**

## Getting Started

### Prerequisites
- Node.js
- Go (Golang)

### Setting Up the Project

1. **Set Up the Frontend (React)**
   - Install dependencies:
     ```bash
     npm install
     ```
   - Start the React development server:
     ```bash
     npm run dev
     ```

2. **Set Up the Backend (Go)**
   - Ensure you are in the project's root directory.
   - Install Go dependencies:
     ```bash
     go mod tidy
     ```
   - Run the Go server:
     ```bash
     go run main.go
     ```

3. **Set Up SQL**
  - Install sqlite
  - Set up `users` database
  - Create table:
  ```sql
  CREATE TABLE Users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL
);
  ```


3. **Access the Site**
   - Open your browser and navigate to `http://localhost:8000` (or the port specified for your React app).



