// test_template.go.tpl
package {{.ImportAlias}}

import (
    "context"
    "testing"
    "{{.ProtoImportPath}}"
    "Go-gRPC-React-starter/pkg/core/service"
    "github.com/bufbuild/connect-go"
)

func Test{{.ServiceName}}(t *testing.T) {
    genericService := service.NewGenericService[{{.ImportAlias}}.{{.ServiceType}}]()
    handler := New{{.ServiceName}}(genericService)

    ctx := context.Background()

    // Test Create{{.ServiceType}}
    createReq := &{{.ImportAlias}}.Create{{.ServiceType}}Request{
        {{.ServiceType}}: &{{.ImportAlias}}.{{.ServiceType}}{
            Id:       1,
            Username: "testuser",
        },
    }
    createResp, err := handler.Create{{.ServiceType}}(ctx, &connect.Request[{{.ImportAlias}}.Create{{.ServiceType}}Request]{Msg: createReq})
    if err != nil {
        t.Fatalf("Create{{.ServiceType}} failed: %v", err)
    }
    if createResp.Msg.Get{{.ServiceType}}().GetUsername() != "testuser" {
        t.Errorf("Create{{.ServiceType}} returned wrong username: got %v want %v",
            createResp.Msg.Get{{.ServiceType}}().GetUsername(), "testuser")
    }

    // Test Get{{.ServiceType}}
    getReq := &{{.ImportAlias}}.Get{{.ServiceType}}Request{Id: 1}
    getResp, err := handler.Get{{.ServiceType}}(ctx, &connect.Request[{{.ImportAlias}}.Get{{.ServiceType}}Request]{Msg: getReq})
    if err != nil {
        t.Fatalf("Get{{.ServiceType}} failed: %v", err)
    }
    if getResp.Msg.Get{{.ServiceType}}().GetUsername() != "testuser" {
        t.Errorf("Get{{.ServiceType}} returned wrong username: got %v want %v",
            getResp.Msg.Get{{.ServiceType}}().GetUsername(), "testuser")
    }

    // Test Update{{.ServiceType}}
    updateReq := &{{.ImportAlias}}.Update{{.ServiceType}}Request{
        {{.ServiceType}}: &{{.ImportAlias}}.{{.ServiceType}}{
            Id:       1,
            Username: "updateduser",
        },
    }
    updateResp, err := handler.Update{{.ServiceType}}(ctx, &connect.Request[{{.ImportAlias}}.Update{{.ServiceType}}Request]{Msg: updateReq})
    if err != nil {
        t.Fatalf("Update{{.ServiceType}} failed: %v", err)
    }
    if updateResp.Msg.Get{{.ServiceType}}().GetUsername() != "updateduser" {
        t.Errorf("Update{{.ServiceType}} returned wrong username: got %v want %v",
            updateResp.Msg.Get{{.ServiceType}}().GetUsername(), "updateduser")
    }

    // Test Delete{{.ServiceType}}
    deleteReq := &{{.ImportAlias}}.Delete{{.ServiceType}}Request{Id: 1}
    deleteResp, err := handler.Delete{{.ServiceType}}(ctx, &connect.Request[{{.ImportAlias}}.Delete{{.ServiceType}}Request]{Msg: deleteReq})
    if err != nil {
        t.Fatalf("Delete{{.ServiceType}} failed: %v", err)
    }
    if !deleteResp.Msg.GetSuccess() {
        t.Errorf("Delete{{.ServiceType}} returned wrong success: got %v want %v",
            deleteResp.Msg.GetSuccess(), true)
    }
}
