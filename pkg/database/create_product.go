package database

import "fmt"

func init() {
	fmt.Println("Registering the  the Product table creation...")
	RegisterInitCommand(createProductTable)
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
