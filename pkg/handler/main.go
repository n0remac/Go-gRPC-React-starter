package main

import (
    "os"
    "text/template"
)

type HandlerData struct {
    ProtoImportPath   string
    ServiceImportPath string
    ProtoImportAlias  string
    ServiceImportAlias string
    ServiceName       string
    ServiceType       string
}

func main() {
    data := HandlerData{
        ProtoImportPath:   "Go-gRPC-React-startergen/proto/user",
        ServiceImportPath: "Go-gRPC-React-starterservice",
        ProtoImportAlias:  "user",
        ServiceImportAlias: "userservice",
        ServiceName:       "UserService",
        ServiceType:       "User",
    }

    tmpl, err := template.ParseFiles("handler_template.go.tpl")
    if err != nil {
        panic(err)
    }

    file, err := os.Create("user_service_handler.go")
    if err != nil {
        panic(err)
    }
    defer file.Close()

    err = tmpl.Execute(file, data)
    if err != nil {
        panic(err)
    }
}
