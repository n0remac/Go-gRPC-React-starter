package service

import (
	"{{.ProjectName}}/pkg/model"
	"{{.ProjectName}}/gen/proto/{{.ServiceName | lower}}"
	"{{.ProjectName}}/gen/proto/{{.ServiceName | lower}}/{{.ServiceName | lower}}connect"
	"context"
	"fmt"
	"net/http"

	"github.com/bufbuild/connect-go"
)

type {{.ServiceName}}Service struct {
	// Add any fields if needed
}

func init() {
	fmt.Println("Registering {{.ServiceName}}Service")
	RegisterService(&{{.ServiceName}}Service{})
}

func (s *{{.ServiceName}}Service) Register(interceptors connect.Option) (string, http.Handler) {
	return {{.ServiceName | lower}}connect.New{{.ServiceName}}ServiceHandler(s, interceptors)
}

func (s *{{.ServiceName}}Service) Create{{.ServiceName}}(ctx context.Context, req *connect.Request[{{.ServiceName | lower}}.Create{{.ServiceName}}Request]) (*connect.Response[{{.ServiceName | lower}}.Create{{.ServiceName}}Response], error) {
	new{{.ServiceName}}, err := model.Create{{.ServiceName}}(req.Msg.{{.ServiceName}})
	if err != nil {
		return nil, err
	}

	return connect.NewResponse(&{{.ServiceName | lower}}.Create{{.ServiceName}}Response{
		{{.ServiceName}}: new{{.ServiceName}},
	}), nil
}

func (s *{{.ServiceName}}Service) Get{{.ServiceName}}(ctx context.Context, req *connect.Request[{{.ServiceName | lower}}.Get{{.ServiceName}}Request]) (*connect.Response[{{.ServiceName | lower}}.Get{{.ServiceName}}Response], error) {
	u, err := model.Get{{.ServiceName}}FromDB(req.Msg.Id)
	if err != nil {
		return nil, err
	}

	return connect.NewResponse(&{{.ServiceName | lower}}.Get{{.ServiceName}}Response{
		{{.ServiceName}}: u,
	}), nil
}

func (s *{{.ServiceName}}Service) Update{{.ServiceName}}(ctx context.Context, req *connect.Request[{{.ServiceName | lower}}.Update{{.ServiceName}}Request]) (*connect.Response[{{.ServiceName | lower}}.Update{{.ServiceName}}Response], error) {
	updated{{.ServiceName}}, err := model.Update{{.ServiceName}}InDB(req.Msg.{{.ServiceName}})
	if err != nil {
		return nil, err
	}

	return connect.NewResponse(&{{.ServiceName | lower}}.Update{{.ServiceName}}Response{
		{{.ServiceName}}: updated{{.ServiceName}},
	}), nil
}

func (s *{{.ServiceName}}Service) Delete{{.ServiceName}}(ctx context.Context, req *connect.Request[{{.ServiceName | lower}}.Delete{{.ServiceName}}Request]) (*connect.Response[{{.ServiceName | lower}}.Delete{{.ServiceName}}Response], error) {
	err := model.Delete{{.ServiceName}}FromDB(req.Msg.Id)
	if err != nil {
		return nil, err
	}

	return connect.NewResponse(&{{.ServiceName | lower}}.Delete{{.ServiceName}}Response{
		Success: true,
	}), nil
}
