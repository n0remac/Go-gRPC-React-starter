package model

import (
	"reflect"
)

func ProtoToDB(protoMsg interface{}, dbStruct interface{}) interface{} {
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

func DbToProto(dbStruct interface{}, protoMsg interface{}) interface{} {
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
