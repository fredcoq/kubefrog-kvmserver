# Default Format of proxy logs

[%START_TIME%] \"%REQ(:METHOD)% %REQ(X-ENVOY-ORIGINAL-PATH?:PATH)% %PROTOCOL%\" %RESPONSE_CODE% %RESPONSE_FLAGS% %RESPONSE_CODE_DETAILS% %CONNECTION_TERMINATION_DETAILS%
\"%UPSTREAM_TRANSPORT_FAILURE_REASON%\" %BYTES_RECEIVED% %BYTES_SENT% %DURATION% %RESP(X-ENVOY-UPSTREAM-SERVICE-TIME)% \"%REQ(X-FORWARDED-FOR)%\" \"%REQ(USER-AGENT)%\" \"%REQ(X-REQUEST-ID)%\"
\"%REQ(:AUTHORITY)%\" \"%UPSTREAM_HOST%\" %UPSTREAM_CLUSTER% %UPSTREAM_LOCAL_ADDRESS% %DOWNSTREAM_LOCAL_ADDRESS% %DOWNSTREAM_REMOTE_ADDRESS% %REQUESTED_SERVER_NAME% %ROUTE_NAME%\n

## log examples

```
Proxy 1
[2024-06-02T13:24:57.930Z] "GET /resources/ik3tm/welcome/keycloak/img/favicon.ico HTTP/2" 0 - http2.remote_reset - "-" 0 0 0 - "192.168.0.24" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:126.0) Gecko/20100101 Firefox/126.0" "9f69865b-eed1-409b-8c12-12436234a191" "auth.kubefrog.fr" "10.0.0.159:8080" outbound|80||keycloak.auth.svc.cluster.local 10.0.1.244:35794 10.0.1.244:8443 192.168.0.24:8459 auth.kubefrog.
fr
Proxy 2
Requête kubeflow with redirection which fails with 404
[2024-06-02T13:35:27.054Z] "GET / HTTP/2" 302 UAEX ext_authz_denied - "-" 0 387 16 - "192.168.0.24" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:126.0) Gecko/20100101 Firefox/126.0" "1d3ec87f-d974-4521-b5ac-23404817a56a" "kubeflow.kubefrog.fr" "-" outbound|80||centraldashboard.kubeflow.svc.cluster.local - 10.0.0.196:8443 192.168.0.24:41604 kubeflow.kubefrog.fr -
[2024-06-02T13:35:27.116Z] "GET /realms/kubeflow/protocol/openid-connect/auth?approval_prompt=force&client_id=3d36c09c69f4742960599330d5b796a9&nonce=unbso0L930OzafqDFd6D7I_sDsTFx_1pUsHzm_j11TI&redirect_uri=https%3A%2F%2Fkubeflow.kubefrog.fr%2Foauth2%2Fcallback&response_type=code&scope=openid&state=yrD_380ezS299jLCYU4n135fR8Yhe07GQ9VNqOlf94E%3A%2F HTTP/2" 404 NR route_not_found - "-" 0 0 0 - "192.168.0.24" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:126.0) Gecko/20100101 Firefox/126.0" "0b60ced5-f525-45e5-9233-171eb33b7c95" "auth.kubefrog.fr" "-" - - 10.0.0.196:8443 192.168.0.24:41604 kubeflow.kubefrog.fr - 
```
