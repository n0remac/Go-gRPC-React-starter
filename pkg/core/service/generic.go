package service

import (
    "fmt"
    "context"
    "reflect"
)

type GenericService[T any] struct {
    store map[int32]T
    nextID int32
}

func NewGenericService[T any]() *GenericService[T] {
    return &GenericService[T]{store: make(map[int32]T)}
}

func (s *GenericService[T]) Create(ctx context.Context, item T) (T, error) {
    s.nextID++
    s.store[s.nextID] = item
    return item, nil
}

func (s *GenericService[T]) Get(ctx context.Context, id int32) (T, error) {
    item, exists := s.store[id]
    if !exists {
        return item, fmt.Errorf("item not found")
    }
    return item, nil
}

func (s *GenericService[T]) Update(ctx context.Context, item T) (T, error) {
    id := extractID(item)
    s.store[id] = item
    return item, nil
}

func (s *GenericService[T]) Remove(ctx context.Context, id int32) (bool, error) {
    if _, exists := s.store[id]; !exists {
        return false, fmt.Errorf("item not found")
    }
    delete(s.store, id)
    return true, nil
}

func extractID[T any](item T) int32 {
    v := reflect.ValueOf(item)
    if v.Kind() == reflect.Ptr {
        v = v.Elem()
    }
    if v.Kind() != reflect.Struct {
        panic("extractID expects a struct or a pointer to a struct")
    }
    field := v.FieldByName("Id")
    if !field.IsValid() {
        panic("Id field not found")
    }
    if field.Kind() != reflect.Int32 {
        panic("Id field is not of type int32")
    }
    return int32(field.Int())
}
