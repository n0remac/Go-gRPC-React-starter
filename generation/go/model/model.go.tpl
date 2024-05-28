package model

import (
	"{{.ProjectName}}/gen/proto/{{.ModelName | lower}}"
	"{{.ProjectName}}/pkg/database"
	"reflect"

	"github.com/upper/db/v4"
)

type {{.ModelName}} struct {
{{- range .Fields }}
	{{ if eq .Name "id" }}ID int `db:"id,omitempty"`{{ else }}{{ .Name | title }} {{ sqlType .Type }} `db:"{{ .Name | lower }}"`{{ end }}
{{- end }}
}

func protoToDB(protoMsg interface{}, dbStruct interface{}) interface{} {
	protoVal := reflect.ValueOf(protoMsg).Elem()
	dbVal := reflect.ValueOf(dbStruct).Elem()

	for i := 0; i < protoVal.NumField(); i++ {
		protoField := protoVal.Field(i)
		dbField := dbVal.FieldByName(protoVal.Type().Field(i).Name)

		if dbField.IsValid() && dbField.CanSet() {
			switch dbField.Kind() {
			case reflect.Int, reflect.Int32:
				dbField.SetInt(protoField.Int())
			case reflect.String:
				dbField.SetString(protoField.String())
			}
		}
	}

	return dbStruct
}

func dbToProto(dbStruct interface{}, protoMsg interface{}) interface{} {
	dbVal := reflect.ValueOf(dbStruct).Elem()
	protoVal := reflect.ValueOf(protoMsg).Elem()

	for i := 0; i < dbVal.NumField(); i++ {
		dbField := dbVal.Field(i)
		protoField := protoVal.FieldByName(dbVal.Type().Field(i).Name)

		if protoField.IsValid() && protoField.CanSet() {
			switch protoField.Kind() {
			case reflect.Int32:
				protoField.SetInt(dbField.Int())
			case reflect.String:
				protoField.SetString(dbField.String())
			}
		}
	}

	return protoMsg
}

func Create{{.ModelName}}(m *{{.ModelName | lower}}.{{.ModelName}}) (*{{.ModelName | lower}}.{{.ModelName}}, error) {
	sess := database.GetSession()
	new{{.ModelName}} := protoToDB(m, &{{.ModelName}}{}).(*{{.ModelName}})

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

	m := dbToProto(&db{{.ModelName}}, &{{.ModelName | lower}}.{{.ModelName}}{}).(*{{.ModelName | lower}}.{{.ModelName}})
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

	updated{{.ModelName}} := protoToDB(m, &db{{.ModelName}}).(*{{.ModelName}})
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
