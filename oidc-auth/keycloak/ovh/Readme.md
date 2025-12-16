# Keycloak OIDC Auth Provider

    Create new client in your Keycloak realm with Access Type 'confidental', Client protocol 'openid-connect' and Valid Redirect URIs 'https://internal.yourcompany.com/oauth2/callback'
    Take note of the Secret in the credential tab of the client
    Create a mapper with Mapper Type 'Group Membership' and Token Claim Name 'groups'.
    Create a mapper with Mapper Type 'Audience' and Included Client Audience and Included Custom Audience set to your client name.

# Make sure you set the following to the appropriate url:

    --provider=keycloak-oidc
    --client-id=<your client's id>
    --client-secret=<your client's secret>
    --redirect-url=https://myapp.com/oauth2/callback
    --oidc-issuer-url=https://<keycloak host>/auth/realms/<your realm>
    --allowed-role=<realm role name> // Optional, required realm role
    --allowed-role=<client id>:<client role name> // Optional, required client role


email must be verified