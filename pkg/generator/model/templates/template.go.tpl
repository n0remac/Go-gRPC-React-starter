package {{.PackageName}}

import (
    "context"
    "github.com/upper/db/v4"
    "Go-gRPC-React-starter/pkg/core/model"
    "Go-gRPC-React-starter/gen/proto/{{.PackageName}}"
)

type {{.ModelName}} struct {
{{- range .Fields }}
    {{ .Name | title }} {{ .Type }} `db:"{{ .Name }}"` 
{{- end }}
}

func New{{.ModelName}}Model(sess db.Session) *model.GenericModel[{{.ModelName}}] {
    return model.NewGenericModel[{{.ModelName}}]("{{ .TableName }}", sess)
}

func create{{.ModelName}}(ctx context.Context, sess db.Session, item *{{.PackageName}}.{{.ModelName}}) (*{{.PackageName}}.{{.ModelName}}, error) {
    m := New{{.ModelName}}Model(sess)
    dbItem := &{{.ModelName}}{
{{- range .Fields }}
        {{ .Name | title }}: item.{{ .Name | title }},
{{- end }}
    }
    createdItem, err := m.Create(ctx, *dbItem)
    if err != nil {
        return nil, err
    }
    return &{{.PackageName}}.{{.ModelName}}{
{{- range .Fields }}
        {{ .Name | title }}: createdItem.{{ .Name | title }},
{{- end }}
    }, nil
}

func get{{.ModelName}}ByID(ctx context.Context, sess db.Session, id int32) (*{{.PackageName}}.{{.ModelName}}, error) {
    m := New{{.ModelName}}Model(sess)
    dbItem, err := m.GetByID(ctx, id)
    if err != nil {
        return nil, err
    }
    return &{{.PackageName}}.{{.ModelName}}{
{{- range .Fields }}
        {{ .Name | title }}: dbItem.{{ .Name | title }},
{{- end }}
    }, nil
}

func update{{.ModelName}}(ctx context.Context, sess db.Session, item *{{.PackageName}}.{{.ModelName}}) (*{{.PackageName}}.{{.ModelName}}, error) {
    m := New{{.ModelName}}Model(sess)
    dbItem := &{{.ModelName}}{
{{- range .Fields }}
        {{ .Name | title }}: item.{{ .Name | title }},
{{- end }}
    }
    updatedItem, err := m.Update(ctx, *dbItem)
    if err != nil {
        return nil, err
    }
    return &{{.PackageName}}.{{.ModelName}}{
{{- range .Fields }}
        {{ .Name | title }}: updatedItem.{{ .Name | title }},
{{- end }}
    }, nil
}

func delete{{.ModelName}}(ctx context.Context, sess db.Session, id int32) error {
    m := New{{.ModelName}}Model(sess)
    return m.Delete(ctx, id)
}
