// template.go.tpl
package {{.ImportAlias}}

import (
    "context"
    "reflect"
    "{{.ProtoImportPath}}"
    "Go-gRPC-React-starter/pkg/core/service"
    "github.com/bufbuild/connect-go"
)

type {{.ServiceName}}Handler struct {
    service service.CRUDService[{{.ImportAlias}}.{{.ServiceType}}]
}

func New{{.ServiceName}}Handler(svc service.CRUDService[{{.ImportAlias}}.{{.ServiceType}}]) *{{.ServiceName}}Handler {
    return &{{.ServiceName}}Handler{service: svc}
}

func (h *{{.ServiceName}}Handler) handleRequest(ctx context.Context, req interface{}, handlerFunc interface{}) (interface{}, error) {
    handlerValue := reflect.ValueOf(handlerFunc)
    result := handlerValue.Call([]reflect.Value{reflect.ValueOf(ctx), reflect.ValueOf(req)})

    if err := result[1].Interface(); err != nil {
        return nil, err.(error)
    }
    return result[0].Interface(), nil
}

func (h *{{.ServiceName}}Handler) Create{{.ServiceType}}(ctx context.Context, req *connect.Request[{{.ImportAlias}}.Create{{.ServiceType}}Request]) (*connect.Response[{{.ImportAlias}}.Create{{.ServiceType}}Response], error) {
    res, err := h.handleRequest(ctx, req.Msg, h.service.Create)
    if err != nil {
        return nil, err
    }
    return connect.NewResponse(res.(*{{.ImportAlias}}.Create{{.ServiceType}}Response)), nil
}

func (h *{{.ServiceName}}Handler) Get{{.ServiceType}}(ctx context.Context, req *connect.Request[{{.ImportAlias}}.Get{{.ServiceType}}Request]) (*connect.Response[{{.ImportAlias}}.Get{{.ServiceType}}Response], error) {
    res, err := h.handleRequest(ctx, req.Msg, h.service.Get)
    if err != nil {
        return nil, err
    }
    return connect.NewResponse(res.(*{{.ImportAlias}}.Get{{.ServiceType}}Response)), nil
}

func (h *{{.ServiceName}}Handler) Update{{.ServiceType}}(ctx context.Context, req *connect.Request[{{.ImportAlias}}.Update{{.ServiceType}}Request]) (*connect.Response[{{.ImportAlias}}.Update{{.ServiceType}}Response], error) {
    res, err := h.handleRequest(ctx, req.Msg, h.service.Update)
    if err != nil {
        return nil, err
    }
    return connect.NewResponse(res.(*{{.ImportAlias}}.Update{{.ServiceType}}Response)), nil
}

func (h *{{.ServiceName}}Handler) Delete{{.ServiceType}}(ctx context.Context, req *connect.Request[{{.ImportAlias}}.Delete{{.ServiceType}}Request]) (*connect.Response[{{.ImportAlias}}.Delete{{.ServiceType}}Response], error) {
    res, err := h.handleRequest(ctx, req.Msg, h.service.Remove)
    if err != nil {
        return nil, err
    }
    return connect.NewResponse(res.(*{{.ImportAlias}}.Delete{{.ServiceType}}Response)), nil
}
