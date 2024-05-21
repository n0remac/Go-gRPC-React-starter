// handler_template.go.tpl
package handler

import (
    "context"
    "reflect"
    "{{.ProtoImportPath}}"
    "{{.ServiceImportPath}}"
    "github.com/bufbuild/connect-go"
)

type {{.ServiceName}}Handler struct {
    service {{.ServiceImportAlias}}.CRUDService[{{.ProtoImportAlias}}.{{.ServiceType}}]
}

func New{{.ServiceName}}Handler(svc {{.ServiceImportAlias}}.CRUDService[{{.ProtoImportAlias}}.{{.ServiceType}}]) *{{.ServiceName}}Handler {
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

func (h *{{.ServiceName}}Handler) Create{{.ServiceType}}(ctx context.Context, req *connect.Request[{{.ProtoImportAlias}}.Create{{.ServiceType}}Request]) (*connect.Response[{{.ProtoImportAlias}}.Create{{.ServiceType}}Response], error) {
    res, err := h.handleRequest(ctx, req.Msg, h.service.Create)
    if err != nil {
        return nil, err
    }
    return connect.NewResponse(res.(*{{.ProtoImportAlias}}.Create{{.ServiceType}}Response)), nil
}

func (h *{{.ServiceName}}Handler) Get{{.ServiceType}}(ctx context.Context, req *connect.Request[{{.ProtoImportAlias}}.Get{{.ServiceType}}Request]) (*connect.Response[{{.ProtoImportAlias}}.Get{{.ServiceType}}Response], error) {
    res, err := h.handleRequest(ctx, req.Msg, h.service.Get)
    if err != nil {
        return nil, err
    }
    return connect.NewResponse(res.(*{{.ProtoImportAlias}}.Get{{.ServiceType}}Response)), nil
}

func (h *{{.ServiceName}}Handler) Update{{.ServiceType}}(ctx context.Context, req *connect.Request[{{.ProtoImportAlias}}.Update{{.ServiceType}}Request]) (*connect.Response[{{.ProtoImportAlias}}.Update{{.ServiceType}}Response], error) {
    res, err := h.handleRequest(ctx, req.Msg, h.service.Update)
    if err != nil {
        return nil, err
    }
    return connect.NewResponse(res.(*{{.ProtoImportAlias}}.Update{{.ServiceType}}Response)), nil
}

func (h *{{.ServiceName}}Handler) Delete{{.ServiceType}}(ctx context.Context, req *connect.Request[{{.ProtoImportAlias}}.Delete{{.ServiceType}}Request]) (*connect.Response[{{.ProtoImportAlias}}.Delete{{.ServiceType}}Response], error) {
    res, err := h.handleRequest(ctx, req.Msg, h.service.Remove)
    if err != nil {
        return nil, err
    }
    return connect.NewResponse(res.(*{{.ProtoImportAlias}}.Delete{{.ServiceType}}Response)), nil
}
