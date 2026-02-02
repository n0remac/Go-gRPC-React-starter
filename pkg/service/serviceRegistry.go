package service

import (
	"fmt"
	"net/http"

	"github.com/bufbuild/connect-go"
)

type Service interface {
	Register(interceptors connect.Option) (string, http.Handler)
}

var serviceRegistry []Service

func RegisterService(s Service) {
	serviceRegistry = append(serviceRegistry, s)
}

func InitServices(apiRoot *http.ServeMux, interceptors connect.Option) {
	for _, service := range serviceRegistry {
		fmt.Println("Registering service")
		apiRoot.Handle(service.Register(interceptors))
	}
}
