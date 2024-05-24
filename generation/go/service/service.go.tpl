package {{.ServiceName  | lower}}

import (
	"{{.ProjectName}}/gen/proto/{{.ServiceName  | lower}}"
	"context"

	"github.com/bufbuild/connect-go"
)

type {{.ServiceType}} struct {
	// Add any fields if needed
}

func (s *{{.ServiceType}}) Create{{.ServiceName}}(ctx context.Context, req *connect.Request[{{.ServiceName | lower}}.Create{{.ServiceName}}Request]) (*connect.Response[{{.ServiceName | lower}}.Create{{.ServiceName}}Response], error) {
	new{{.ServiceName}}, err := create{{.ServiceName}}(req.Msg.{{.ServiceName}})
	if err != nil {
		return nil, err
	}

	return connect.NewResponse(&{{.ServiceName | lower}}.Create{{.ServiceName}}Response{
		{{.ServiceName}}: new{{.ServiceName}},
	}), nil
}

func (s *{{.ServiceType}}) Get{{.ServiceName}}(ctx context.Context, req *connect.Request[{{.ServiceName | lower}}.Get{{.ServiceName}}Request]) (*connect.Response[{{.ServiceName | lower}}.Get{{.ServiceName}}Response], error) {
	u, err := get{{.ServiceName}}FromDB(req.Msg.Id)
	if err != nil {
		return nil, err
	}

	return connect.NewResponse(&{{.ServiceName | lower}}.Get{{.ServiceName}}Response{
		{{.ServiceName}}: u,
	}), nil
}

func (s *{{.ServiceType}}) Update{{.ServiceName}}(ctx context.Context, req *connect.Request[{{.ServiceName | lower}}.Update{{.ServiceName}}Request]) (*connect.Response[{{.ServiceName | lower}}.Update{{.ServiceName}}Response], error) {
	updated{{.ServiceName}}, err := update{{.ServiceName}}InDB(req.Msg.{{.ServiceName}})
	if err != nil {
		return nil, err
	}

	return connect.NewResponse(&{{.ServiceName | lower}}.Update{{.ServiceName}}Response{
		{{.ServiceName}}: updated{{.ServiceName}},
	}), nil
}

func (s *{{.ServiceType}}) Delete{{.ServiceName}}(ctx context.Context, req *connect.Request[{{.ServiceName | lower}}.Delete{{.ServiceName}}Request]) (*connect.Response[{{.ServiceName | lower}}.Delete{{.ServiceName}}Response], error) {
	err := delete{{.ServiceName}}FromDB(req.Msg.Id)
	if err != nil {
		return nil, err
	}

	return connect.NewResponse(&{{.ServiceName | lower}}.Delete{{.ServiceName}}Response{
		Success: true,
	}), nil
}
