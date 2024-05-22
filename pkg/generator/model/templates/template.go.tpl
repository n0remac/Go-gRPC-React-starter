package {{.PackageName}}

import (
    "Go-gRPC-React-starter/pkg/core/model"
    "Go-gRPC-React-starter/gen/proto/{{.PackageName}}"
)

type {{.ModelName}} struct {
{{- range .Fields }}
    {{ .Name | title }} {{ .Type }} `db:"{{ .Name }}"` 
{{- end }}
}

type {{.ModelName}}Model struct {
    genericModel *model.GenericModel[{{.ModelName}}]
}

func New{{.ModelName}}Model() *{{.ModelName}}Model {
    return &{{.ModelName}}Model{genericModel: model.NewGenericModel[{{.ModelName}}]("{{ .TableName }}")}
}

func (m *{{.ModelName}}Model) Create(item *{{.PackageName}}.{{.ModelName}}) (*{{.PackageName}}.{{.ModelName}}, error) {
    dbItem := &{{.ModelName}}{
{{- range .Fields }}
        {{ .Name | title }}: item.{{ .Name | title }},
{{- end }}
    }
    createdItem, err := m.genericModel.Create(*dbItem)
    if err != nil {
        return nil, err
    }
    return &{{.PackageName}}.{{.ModelName}}{
{{- range .Fields }}
        {{ .Name | title }}: createdItem.{{ .Name | title }},
{{- end }}
    }, nil
}

func (m *{{.ModelName}}Model) GetByID(id int32) (*{{.PackageName}}.{{.ModelName}}, error) {
    dbItem, err := m.genericModel.GetByID(id)
    if err != nil {
        return nil, err
    }
    return &{{.PackageName}}.{{.ModelName}}{
{{- range .Fields }}
        {{ .Name | title }}: dbItem.{{ .Name | title }},
{{- end }}
    }, nil
}

func (m *{{.ModelName}}Model) Update(item *{{.PackageName}}.{{.ModelName}}) (*{{.PackageName}}.{{.ModelName}}, error) {
    dbItem := &{{.ModelName}}{
{{- range .Fields }}
        {{ .Name | title }}: item.{{ .Name | title }},
{{- end }}
    }
    updatedItem, err := m.genericModel.Update(*dbItem)
    if err != nil {
        return nil, err
    }
    return &{{.PackageName}}.{{.ModelName}}{
{{- range .Fields }}
        {{ .Name | title }}: updatedItem.{{ .Name | title }},
{{- end }}
    }, nil
}

func (m *{{.ModelName}}Model) Delete(id int32) error {
    return m.genericModel.Delete(id)
}
