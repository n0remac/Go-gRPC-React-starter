package product

import (
	"Go-gRPC-React-starter/gen/proto/product"
	"context"
	"fmt"

	"github.com/bufbuild/connect-go"
)

type ProductService struct {
	// Add any fields if needed
}

func (s *ProductService) CreateProduct(ctx context.Context, req *connect.Request[product.CreateProductRequest]) (*connect.Response[product.CreateProductResponse], error) {
	fmt.Println("CreateProduct called")
	newProduct, err := createProduct(req.Msg.Product)
	fmt.Println("newProduct", newProduct)
	if err != nil {
		return nil, err
	}

	return connect.NewResponse(&product.CreateProductResponse{
		Product: newProduct,
	}), nil
}

func (s *ProductService) GetProduct(ctx context.Context, req *connect.Request[product.GetProductRequest]) (*connect.Response[product.GetProductResponse], error) {
	u, err := getProductFromDB(req.Msg.Id)
	if err != nil {
		return nil, err
	}

	return connect.NewResponse(&product.GetProductResponse{
		Product: u,
	}), nil
}

func (s *ProductService) UpdateProduct(ctx context.Context, req *connect.Request[product.UpdateProductRequest]) (*connect.Response[product.UpdateProductResponse], error) {
	fmt.Println("req.msg", req.Msg)
	updatedProduct, err := updateProductInDB(req.Msg.Product)
	fmt.Println("updatedProduct", updatedProduct)
	if err != nil {
		return nil, err
	}

	return connect.NewResponse(&product.UpdateProductResponse{
		Product: updatedProduct,
	}), nil
}

func (s *ProductService) DeleteProduct(ctx context.Context, req *connect.Request[product.DeleteProductRequest]) (*connect.Response[product.DeleteProductResponse], error) {
	err := deleteProductFromDB(req.Msg.Id)
	if err != nil {
		return nil, err
	}

	return connect.NewResponse(&product.DeleteProductResponse{
		Success: true,
	}), nil
}
