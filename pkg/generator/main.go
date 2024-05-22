package main

import (
	"os"
	"path/filepath"
	"text/template"
)

type HandlerData struct {
	ProtoImportPath   string
	ServiceImportPath string
	ImportAlias       string
	ServiceName       string
	ServiceType       string
}

func main() {
	data := HandlerData{
		ProtoImportPath:   "Go-gRPC-React-starter/gen/proto/user",
		ServiceImportPath: "Go-gRPC-React-starter/pkg/generated/user",
		ImportAlias:       "user",
		ServiceName:       "UserService",
		ServiceType:       "User",
	}

	templates := []struct {
		tmplPath       string
		outputFilePath string
	}{
		{"service/templates/template.go.tpl", "../generated/user/service.go"},
		{"service/templates/template_test.go.tpl", "../generated/user/service_test.go"},
	}

	for _, t := range templates {
		tmpl, err := template.ParseFiles(t.tmplPath)
		if err != nil {
			panic(err)
		}

		outputDir := filepath.Dir(t.outputFilePath)
		if err := os.MkdirAll(outputDir, 0755); err != nil {
			panic(err)
		}

		file, err := os.Create(t.outputFilePath)
		if err != nil {
			panic(err)
		}
		defer file.Close()

		err = tmpl.Execute(file, data)
		if err != nil {
			panic(err)
		}
	}
}
