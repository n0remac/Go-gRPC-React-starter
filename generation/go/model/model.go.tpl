package model

import (
	"{{.ProjectName}}/gen/proto/{{.ModelName | lower}}"
	"{{.ProjectName}}/pkg/database"

	"github.com/upper/db/v4"
)

type {{.ModelName}} struct {
{{- range .Fields }}
	{{ if eq .Name "id" }}ID int `db:"id,omitempty"`{{ else }}{{ .Name | title }} {{ sqlType .Type }} `db:"{{ .Name | lower }}"`{{ end }}
{{- end }}
}

func Create{{.ModelName}}(m *{{.ModelName | lower}}.{{.ModelName}}) (*{{.ModelName | lower}}.{{.ModelName}}, error) {
	sess := database.GetSession()
	new{{.ModelName}} := ProtoToDB(m, &{{.ModelName}}{}).(*{{.ModelName}})

	err := sess.Collection("{{.ModelName | lower}}s").InsertReturning(new{{.ModelName}})
	if err != nil {
		return nil, err
	}

	m.Id = int32(new{{.ModelName}}.ID)
	return m, nil
}

func Get{{.ModelName}}FromDB(id int32) (*{{.ModelName | lower}}.{{.ModelName}}, error) {
	sess := database.GetSession()
	var db{{.ModelName}} {{.ModelName}}

	res := sess.Collection("{{.ModelName | lower}}s").Find(db.Cond{"id": id})
	err := res.One(&db{{.ModelName}})
	if err != nil {
		return nil, err
	}

	m := DbToProto(&db{{.ModelName}}, &{{.ModelName | lower}}.{{.ModelName}}{}).(*{{.ModelName | lower}}.{{.ModelName}})
	m.Id = int32(db{{.ModelName}}.ID)
	return m, nil
}

func Update{{.ModelName}}InDB(m *{{.ModelName | lower}}.{{.ModelName}}) (*{{.ModelName | lower}}.{{.ModelName}}, error) {
	sess := database.GetSession()
	var db{{.ModelName}} {{.ModelName}}

	res := sess.Collection("{{.ModelName | lower}}s").Find(db.Cond{"id": m.Id})
	err := res.One(&db{{.ModelName}})
	if err != nil {
		return nil, err
	}

	updated{{.ModelName}} := ProtoToDB(m, &db{{.ModelName}}).(*{{.ModelName}})
	err = res.Update(updated{{.ModelName}})
	if err != nil {
		return nil, err
	}

	return m, nil
}

func Delete{{.ModelName}}FromDB(id int32) error {
	sess := database.GetSession()

	res := sess.Collection("{{.ModelName | lower}}s").Find(db.Cond{"id": id})
	err := res.Delete()
	return err
}
