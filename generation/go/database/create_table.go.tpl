package database

import "fmt"

func init() {
	fmt.Println("Registering the {{.ModelName}} table creation...")
	RegisterInitCommand(create{{.ModelName}}Table)
}

func create{{.ModelName}}Table() {
	// SQL command to create the {{.ModelName}} table
	sqlCommand := `
CREATE TABLE IF NOT EXISTS {{.ModelName | title}}s (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  data TEXT NOT NULL
);`

	createTable(sqlCommand)
}
