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

	tmplPath := "service/templates/template.go.tpl"
	outputFilePath := "../generated/user/service.go"

	tmpl, err := template.ParseFiles(tmplPath)
	if err != nil {
		panic(err)
	}

	outputDir := filepath.Dir(outputFilePath)
	if err := os.MkdirAll(outputDir, 0755); err != nil {
		panic(err)
	}

	file, err := os.Create(outputFilePath)
	if err != nil {
		panic(err)
	}
	defer file.Close()

	err = tmpl.Execute(file, data)
	if err != nil {
		panic(err)
	}
}
