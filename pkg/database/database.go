package database

import (
	"fmt"
	"log"

	"github.com/upper/db/v4"
	"github.com/upper/db/v4/adapter/sqlite"
)

var (
	sess         db.Session
	initCommands []func()
)

func InitDB() {
	var err error
	var settings = sqlite.ConnectionURL{
		Database: `mydatabase.db`, // Your SQLite database file
	}

	// Open a session to your SQLite database
	sess, err = sqlite.Open(settings)
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}

	// Run all init commands
	for _, cmd := range initCommands {
		cmd()
	}
	
	// Now, let's create the Users table
	createUsersTable()
}

// RegisterInitCommand registers a function to be run after the database is initialized
func RegisterInitCommand(cmd func()) {
	initCommands = append(initCommands, cmd)
}

func createUsersTable() {
	fmt.Println("Creating the Users table...")
	// SQL command to create the Users table
	sqlCommand := `
CREATE TABLE IF NOT EXISTS Users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT NOT NULL,
  email TEXT NOT NULL,
  password TEXT NOT NULL
);`

	createTable(sqlCommand)
}

func createTable(sqlCommand string) {
	// Execute the SQL command
	_, err := sess.SQL().Exec(sqlCommand)
	if err != nil {
		log.Fatalf("Failed to create table: %v", err)
	} else {
		log.Println("Table created successfully")
	}
}

func GetSession() db.Session {
	return sess
}
