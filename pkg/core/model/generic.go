package model

import (
    "context"
    "github.com/upper/db/v4"
    "reflect"
)

type GenericModel[T any] struct {
    collection db.Collection
}

func NewGenericModel[T any](collectionName string, sess db.Session) *GenericModel[T] {
    return &GenericModel[T]{collection: sess.Collection(collectionName)}
}

func (m *GenericModel[T]) Create(ctx context.Context, item T) (T, error) {
    _, err := m.collection.Insert(item)
    return item, err
}

func (m *GenericModel[T]) GetByID(ctx context.Context, id int32) (T, error) {
    var item T
    err := m.collection.Find(db.Cond{"id": id}).One(&item)
    return item, err
}

func (m *GenericModel[T]) GetByField(ctx context.Context, field string, value interface{}) (T, error) {
    var item T
    err := m.collection.Find(db.Cond{field: value}).One(&item)
    return item, err
}

func (m *GenericModel[T]) Update(ctx context.Context, item T) (T, error) {
    id := extractID(item)
    err := m.collection.Find(db.Cond{"id": id}).Update(item)
    return item, err
}

func (m *GenericModel[T]) Delete(ctx context.Context, id int32) error {
    return m.collection.Find(db.Cond{"id": id}).Delete()
}

func extractID[T any](item T) int32 {
    v := reflect.ValueOf(item)
    if v.Kind() == reflect.Ptr {
        v = v.Elem()
    }
    if v.Kind() != reflect.Struct {
        panic("extractID expects a struct or a pointer to a struct")
    }
    field := v.FieldByName("ID")
    if !field.IsValid() {
        panic("ID field not found")
    }
    if field.Kind() != reflect.Int32 {
        panic("ID field is not of type int32")
    }
    return int32(field.Int())
}
