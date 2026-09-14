\# Entra ID Authentication \& Authorization



This lab uses Microsoft Entra ID to secure access to the Enterprise Orders API.



The authentication flow is based on OAuth 2.0 Client Credentials.  

The client application requests an access token from Entra ID and sends that token to Azure API Management.



\## Components



\### Orders API



App registration for the protected API.



\- Application name: `Orders API`

\- App role: `Orders.Read`

\- Allowed member type: `Applications`



The app role is used for machine-to-machine authorization.



\### Orders Client



Authorized client application.



This client has the `Orders.Read` application permission assigned and admin consent granted.



Result:



```text

Valid JWT + Orders.Read role → HTTP 200 OK

