package {{.ImportAlias}}

import (
    "context"
    "reflect"
    "{{.ProtoImportPath}}"
    "Go-gRPC-React-starter/pkg/core/service"
    "github.com/bufbuild/connect-go"
)

type {{.ServiceName}} struct {
    service service.CRUDService[{{.ImportAlias}}.{{.ServiceType}}]
}

func New{{.ServiceName}}(svc service.CRUDService[{{.ImportAlias}}.{{.ServiceType}}]) *{{.ServiceName}} {
    return &{{.ServiceName}}{service: svc}
}

func (h *{{.ServiceName}}) handleRequest(ctx context.Context, req interface{}, handlerFunc interface{}) (interface{}, error) {
    handlerValue := reflect.ValueOf(handlerFunc)
    result := handlerValue.Call([]reflect.Value{reflect.ValueOf(ctx), reflect.ValueOf(req)})
    if err := result[1].Interface(); err != nil {
        return nil, err.(error)
    }
    return result[0].Interface(), nil
}

func (h *{{.ServiceName}}) CreateUser(ctx context.Context, req *connect.Request[{{.ImportAlias}}.Create{{.ServiceType}}Request]) (*connect.Response[{{.ImportAlias}}.Create{{.ServiceType}}Response], error) {
    // Extract the user from the request
    item := req.Msg.GetUser()
    res, err := h.service.Create(ctx, *item)
    if err != nil {
        return nil, err
    }
    return connect.NewResponse(&{{.ImportAlias}}.Create{{.ServiceType}}Response{User: &res}), nil
}

func (h *{{.ServiceName}}) GetUser(ctx context.Context, req *connect.Request[{{.ImportAlias}}.Get{{.ServiceType}}Request]) (*connect.Response[{{.ImportAlias}}.Get{{.ServiceType}}Response], error) {
    res, err := h.service.Get(ctx, req.Msg.GetId())
    if err != nil {
        return nil, err
    }
    return connect.NewResponse(&{{.ImportAlias}}.Get{{.ServiceType}}Response{User: &res}), nil
}

func (h *{{.ServiceName}}) UpdateUser(ctx context.Context, req *connect.Request[{{.ImportAlias}}.Update{{.ServiceType}}Request]) (*connect.Response[{{.ImportAlias}}.Update{{.ServiceType}}Response], error) {
    item := req.Msg.GetUser()
    res, err := h.service.Update(ctx, *item)
    if err != nil {
        return nil, err
    }
    return connect.NewResponse(&{{.ImportAlias}}.Update{{.ServiceType}}Response{User: &res}), nil
}

func (h *{{.ServiceName}}) DeleteUser(ctx context.Context, req *connect.Request[{{.ImportAlias}}.Delete{{.ServiceType}}Request]) (*connect.Response[{{.ImportAlias}}.Delete{{.ServiceType}}Response], error) {
    success, err := h.service.Remove(ctx, req.Msg.GetId())
    if err != nil {
        return nil, err
    }
    return connect.NewResponse(&{{.ImportAlias}}.Delete{{.ServiceType}}Response{Success: success}), nil
}
