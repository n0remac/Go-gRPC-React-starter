package main

import (
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strings"
	"text/template"

	"golang.org/x/text/cases"
	"golang.org/x/text/language"
	"gopkg.in/yaml.v3"
)

type Field struct {
	Name          string `yaml:"name"`
	Type          string `yaml:"type"`
	PrimaryKey    bool   `yaml:"primary_key,omitempty"`
	AutoIncrement bool   `yaml:"auto_increment,omitempty"`
}

type Model struct {
	Name   string  `yaml:"name"`
	Fields []Field `yaml:"fields"`
}

type Schema struct {
	Models []Model `yaml:"models"`
}

func titleCase(s string) string {
	c := cases.Title(language.English)
	return c.String(s)
}

func main() {
	file, err := os.Open("../schema.yaml")
	if err != nil {
		panic(err)
	}
	defer file.Close()

	yamlData, err := io.ReadAll(file)
	if err != nil {
		panic(err)
	}

	var schema Schema
	err = yaml.Unmarshal(yamlData, &schema)
	if err != nil {
		panic(err)
	}

	tmplPath := "templates/template.go.tpl"
	tmpl, err := template.New("template.go.tpl").Funcs(template.FuncMap{
		"lower": strings.ToLower,
		"title": titleCase,
	}).ParseFiles(tmplPath)
	if err != nil {
		panic(err)
	}

	for _, model := range schema.Models {
		outputFilePath := filepath.Join("../../", "generated", strings.ToLower(model.Name), "model.go")
		outputDir := filepath.Dir(outputFilePath)
		if err := os.MkdirAll(outputDir, 0755); err != nil {
			panic(err)
		}

		file, err := os.Create(outputFilePath)
		if err != nil {
			panic(err)
		}
		defer file.Close()

		data := map[string]interface{}{
			"PackageName": strings.ToLower(model.Name),
			"ModelName":   model.Name,
			"Fields":      model.Fields,
			"TableName":   strings.ToLower(model.Name) + "s", // Assuming table name is plural of model name
		}

		err = tmpl.Execute(file, data)
		if err != nil {
			panic(err)
		}

		fmt.Printf("Generated %s\n", outputFilePath)
	}
}
