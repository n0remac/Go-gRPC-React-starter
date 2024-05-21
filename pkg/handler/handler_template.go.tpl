// handler_template.go.tpl
package handler

import (
    "context"
    "reflect"
    "{{.ProtoPackage}}"
    "{{.ServicePackage}}"
    "github.com/bufbuild/connect-go"
)

type {{.ServiceName}}Handler struct {
    service {{.ServicePackage}}.CRUDService[{{.ProtoPackage}}.{{.ServiceType}}]
}

func New{{.ServiceName}}Handler(svc {{.ServicePackage}}.CRUDService[{{.ProtoPackage}}.{{.ServiceType}}]) *{{.ServiceName}}Handler {
    return &{{.ServiceName}}Handler{service: svc}
}

func (h *{{.ServiceName}}Handler) handleRequest[T any, R any](ctx context.Context, req *connect.Request[T], handlerFunc interface{}) (*connect.Response[R], error) {
    handlerValue := reflect.ValueOf(handlerFunc)
    result := handlerValue.Call([]reflect.Value{reflect.ValueOf(ctx), reflect.ValueOf(req.Msg)})

    if err := result[1].Interface(); err != nil {
        return nil, err.(error)
    }
    return connect.NewResponse(result[0].Interface().(R)), nil
}

func (h *{{.ServiceName}}Handler) Create{{.ServiceType}}(ctx context.Context, req *connect.Request[{{.ProtoPackage}}.Create{{.ServiceType}}Request]) (*connect.Response[{{.ProtoPackage}}.Create{{.ServiceType}}Response], error) {
    return h.handleRequest(ctx, req, h.service.Create)
}

func (h *{{.ServiceName}}Handler) Get{{.ServiceType}}(ctx context.Context, req *connect.Request[{{.ProtoPackage}}.Get{{.ServiceType}}Request]) (*connect.Response[{{.ProtoPackage}}.Get{{.ServiceType}}Response], error) {
    return h.handleRequest(ctx, req, h.service.Get)
}

func (h *{{.ServiceName}}Handler) Update{{.ServiceType}}(ctx context.Context, req *connect.Request[{{.ProtoPackage}}.Update{{.ServiceType}}Request]) (*connect.Response[{{.ProtoPackage}}.Update{{.ServiceType}}Response], error) {
    return h.handleRequest(ctx, req, h.service.Update)
}

func (h *{{.ServiceName}}Handler) Delete{{.ServiceType}}(ctx context.Context, req *connect.Request[{{.ProtoPackage}}.Delete{{.ServiceType}}Request]) (*connect.Response[{{.ProtoPackage}}.Delete{{.ServiceType}}Response], error) {
    return h.handleRequest(ctx, req, h.service.Remove)
}
