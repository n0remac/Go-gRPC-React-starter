package database

import "fmt"

func init() {
	fmt.Println("Registering the  the {{.ModelName}} table creation...")
	RegisterInitCommand(create{{.ModelName}}Table)
}

func create{{.ModelName}}Table() {
	// SQL command to create the {{.ModelName}} table
	sqlCommand := `
CREATE TABLE IF NOT EXISTS {{.ModelName | title}}s (
{{- range $index, $field := .Fields }}
  {{ if eq $field.Name "id" }}id INTEGER PRIMARY KEY AUTOINCREMENT{{ else }}{{ $field.Name | lower }} {{ sqlType $field.Type }} NOT NULL{{ end }}{{ if not (eq $index (minus1 (len $.Fields))) }},{{ end }}
{{- end }}
);`

	createTable(sqlCommand)
}
