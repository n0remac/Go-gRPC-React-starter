package product

import (
	"Go-gRPC-React-starter/gen/proto/product"
	"Go-gRPC-React-starter/pkg/database"
	"fmt"
	"reflect"

	"github.com/upper/db/v4"
)

type Product struct {
	ID          int    `db:"id,omitempty"`
	Name        string `db:"name"`
	Amount      int    `db:"amount"`
	Description string `db:"description"`
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

func createProduct(m *product.Product) (*product.Product, error) {
	sess := database.GetSession()
	newProduct := protoToDB(m, &Product{}).(*Product)

	_, err := sess.Collection("products").Insert(newProduct)
	if err != nil {
		return nil, err
	}
	return m, nil
}

func getProductFromDB(id int32) (*product.Product, error) {
	sess := database.GetSession()
	var dbProduct Product

	res := sess.Collection("products").Find(db.Cond{"id": id})
	err := res.One(&dbProduct)
	if err != nil {
		return nil, err
	}

	m := dbToProto(&dbProduct, &product.Product{}).(*product.Product)
	return m, nil
}

func updateProductInDB(m *product.Product) (*product.Product, error) {
	sess := database.GetSession()
	var dbProduct Product
	fmt.Println("m", m)
	res := sess.Collection("products").Find(db.Cond{"id": m.Id})
	err := res.One(&dbProduct)
	if err != nil {
		return nil, err
	}

	updatedProduct := protoToDB(m, &dbProduct).(*Product)
	err = res.Update(updatedProduct)
	if err != nil {
		return nil, err
	}

	return m, nil
}

func deleteProductFromDB(id int32) error {
	sess := database.GetSession()

	res := sess.Collection("products").Find(db.Cond{"id": id})
	err := res.Delete()
	return err
}
