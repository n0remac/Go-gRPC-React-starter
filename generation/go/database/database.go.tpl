package database

func create{{.ModelName}}Table() {
	// SQL command to create the {{.ModelName}} table
	sqlCommand := `
CREATE TABLE IF NOT EXISTS {{.ModelName | title}}s (
{{- range .Fields }}
  {{ if eq .Name "id" }}id INTEGER PRIMARY KEY AUTOINCREMENT{{ else }}{{ .Name | lower }} {{ sqlType .Type }} {{ if not .PrimaryKey }}NOT NULL{{ end }}{{ end }},
{{- end }}
);`

	createTable(sqlCommand)
}
