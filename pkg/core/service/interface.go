package service

import (
    "context"
)

type CRUDService[T any] interface {
    Create(ctx context.Context, item T) (T, error)
    Get(ctx context.Context, id int32) (T, error)
    Update(ctx context.Context, item T) (T, error)
    Remove(ctx context.Context, id int32) (bool, error)
}
