package main

import (
    "os"
    "text/template"
)

type HandlerData struct {
    ProtoPackage   string
    ServicePackage string
    ServiceName    string
    ServiceType    string
}

func main() {
    data := HandlerData{
        ProtoPackage:   "user/gen/proto/user",
        ServicePackage: "user/service",
        ServiceName:    "UserService",
        ServiceType:    "User",
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
