package service

import (
	"Go-gRPC-React-starter/pkg/model"
	"Go-gRPC-React-starter/gen/proto/product"
	"Go-gRPC-React-starter/gen/proto/product/productconnect"
	"context"
	"fmt"
	"net/http"

	"github.com/bufbuild/connect-go"
)

type ProductService struct {
	// Add any fields if needed
}

func init() {
	fmt.Println("Registering ProductService")
	RegisterService(&ProductService{})
}

func (s *ProductService) Register(interceptors connect.Option) (string, http.Handler) {
	return productconnect.NewProductServiceHandler(s, interceptors)
}

func (s *ProductService) CreateProduct(ctx context.Context, req *connect.Request[product.CreateProductRequest]) (*connect.Response[product.CreateProductResponse], error) {
	newProduct, err := model.CreateProduct(req.Msg.Product)
	if err != nil {
		return nil, err
	}

	return connect.NewResponse(&product.CreateProductResponse{
		Product: newProduct,
	}), nil
}

func (s *ProductService) GetProduct(ctx context.Context, req *connect.Request[product.GetProductRequest]) (*connect.Response[product.GetProductResponse], error) {
	u, err := model.GetProductFromDB(req.Msg.Id)
	if err != nil {
		return nil, err
	}

	return connect.NewResponse(&product.GetProductResponse{
		Product: u,
	}), nil
}

func (s *ProductService) UpdateProduct(ctx context.Context, req *connect.Request[product.UpdateProductRequest]) (*connect.Response[product.UpdateProductResponse], error) {
	updatedProduct, err := model.UpdateProductInDB(req.Msg.Product)
	if err != nil {
		return nil, err
	}

	return connect.NewResponse(&product.UpdateProductResponse{
		Product: updatedProduct,
	}), nil
}

func (s *ProductService) DeleteProduct(ctx context.Context, req *connect.Request[product.DeleteProductRequest]) (*connect.Response[product.DeleteProductResponse], error) {
	err := model.DeleteProductFromDB(req.Msg.Id)
	if err != nil {
		return nil, err
	}

	return connect.NewResponse(&product.DeleteProductResponse{
		Success: true,
	}), nil
}
