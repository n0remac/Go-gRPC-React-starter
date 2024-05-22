package model

import (
    "context"
)

type ModelCRUD[T any] interface {
    Create(ctx context.Context, item T) (T, error)
    GetByID(ctx context.Context, id int32) (T, error)
    GetByField(ctx context.Context, field string, value interface{}) (T, error)
    Update(ctx context.Context, item T) (T, error)
    Delete(ctx context.Context, id int32) error
}
