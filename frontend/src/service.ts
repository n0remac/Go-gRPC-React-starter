import {
    createConnectTransport,
  } from "@bufbuild/connect-web";
  import {createPromiseClient} from "@bufbuild/connect";
  import { UserService } from "@/rpc/proto/user/user_connect";

  
  export const baseURL = process.env.BASE_URL;
  
  export const transport = createConnectTransport({
    baseUrl: `${baseURL}` || 'error',
    // credentials: "include",
  });
  
  export const userService = createPromiseClient(UserService, transport);
