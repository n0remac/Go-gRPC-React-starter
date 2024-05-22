package {{.PackageName}}

import (
    "context"
    "github.com/upper/db/v4"
    "Go-gRPC-React-starter/pkg/core/model"
)

type {{.ModelName}} struct {
{{- range .Fields }}
    {{ .Name }} {{ .Type }} ` + "`db:\"{{ .Name }}\"`" + `
{{- end }}
}

func New{{.ModelName}}Model(sess db.Session) *model.GenericModel[{{.ModelName}}] {
    return model.NewGenericModel[{{.ModelName}}]("{{ .TableName }}", sess)
}
