package database

import (
	"log"

	"github.com/upper/db/v4"
	"github.com/upper/db/v4/adapter/sqlite"
)

var sess db.Session

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

	// Now, let's create the Users table
	createUsersTable()
	createProductTable()
}

func createProductTable() {
	// SQL command to create the Product table
	sqlCommand := `
CREATE TABLE IF NOT EXISTS Products (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  amount INTEGER NOT NULL,
  description TEXT NOT NULL
);`

	createTable(sqlCommand)
}

func createUsersTable() {
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
