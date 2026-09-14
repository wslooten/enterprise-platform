# Azure API Management (APIM)

## Overview

Azure API Management (APIM) is the API Gateway used within this Enterprise Integration Platform.

It provides a centralized entry point for API traffic and enables enterprise capabilities such as authentication, authorization, routing, policy enforcement, rate limiting, monitoring and security.

---

## Objectives

This APIM implementation demonstrates:

- API Gateway functionality
- OpenAPI import
- Backend integration with AKS
- API Products
- API Subscriptions
- Subscription Keys
- Rate Limiting
- OAuth 2.0 Client Credentials
- Microsoft Entra ID integration
- JWT Authentication
- Application Role Authorization
- API Policies
- Enterprise API Security

---

## Architecture

```text
API Client
    |
    | OAuth 2.0 Client Credentials
    v
Microsoft Entra ID
    |
    | JWT Access Token
    v
Azure API Management
    |
    |-- Products / Subscriptions
    |-- API Policies
    |-- JWT Validation
    |-- Application Role Authorization
    |-- Rate Limiting
    |
    v
NGINX Ingress Controller
    |
    v
Azure Kubernetes Service
    |
    v
FastAPI Orders API
```

---

## Implemented Features

### API Import

- OpenAPI Specification
- Automatic API creation
- API Operations

### Backend

- Azure Kubernetes Service
- NGINX Ingress
- FastAPI Orders API

### Products

Implemented Product:

- Enterprise Platform

### Subscriptions

Implemented:

- William Test Subscription

Subscription keys can be used as an additional APIM access-control mechanism.

---

## Microsoft Entra ID Authentication

The Enterprise Orders API is protected using Microsoft Entra ID and OAuth 2.0 Client Credentials.

The client application requests an access token from Entra ID using:

```text
grant_type = client_credentials
scope      = api://<orders-api-application-id>/.default
```

The returned JWT access token is sent to APIM using:

```text
Authorization: Bearer <access-token>
```

APIM validates the JWT before forwarding the request to the backend.

---

## JWT Validation

The `validate-jwt` policy validates the access token.

The policy verifies that the token is valid and intended for the Enterprise Orders API.

A validated JWT is made available to subsequent APIM policies:

```xml
<validate-jwt
    header-name="Authorization"
    require-scheme="Bearer"
    failed-validation-httpcode="401"
    failed-validation-error-message="Unauthorized. Invalid or missing access token."
    output-token-variable-name="jwt">
    ...
</validate-jwt>
```

A missing or invalid access token results in:

```text
HTTP 401 Unauthorized
```

---

## Application Role Authorization

Authentication and authorization are handled separately.

After JWT validation, APIM checks whether the calling application contains the required Entra ID application role:

```text
Orders.Read
```

The role is present in the JWT as a `roles` claim.

APIM uses a `choose` policy to perform this authorization check.

If the JWT is valid but the required role is missing, APIM returns:

```text
HTTP 403 Forbidden
```

This provides a clear separation between:

```text
Authentication failure -> 401 Unauthorized
Authorization failure  -> 403 Forbidden
```

---

## Authorization Test Results

Three security scenarios have been successfully tested.

| Scenario | Expected Result | Test Result |
|---|---|---|
| Missing or invalid JWT | 401 Unauthorized | Passed |
| Valid JWT without `Orders.Read` | 403 Forbidden | Passed |
| Valid JWT with `Orders.Read` | 200 OK | Passed |

The successful authorized request returns:

```json
{
  "message": "Enterprise Orders API"
}
```

---

## Rate Limiting

The following inbound policy limits API traffic:

```xml
<rate-limit calls="5" renewal-period="60" />
```

After five requests within sixty seconds APIM returns:

```text
HTTP 429 Too Many Requests
```

This behavior has been successfully tested.

---

## Current Inbound Policy Flow

The Get Orders operation currently follows this policy flow:

```text
Request
   |
   v
base
   |
   v
validate-jwt
   |
   | invalid/missing JWT
   +----------------------> 401 Unauthorized
   |
   v
choose
   |
   | missing Orders.Read
   +----------------------> 403 Forbidden
   |
   v
rate-limit
   |
   v
AKS Orders API
   |
   v
200 OK
```

The `<base />` policy inherits policies configured at the parent API scope.

---

## Authentication and Authorization Status

| Feature | Status |
|---|---|
| Products | Complete |
| Subscriptions | Complete |
| Subscription Keys | Complete |
| Rate Limiting | Complete |
| Microsoft Entra ID | Complete |
| OAuth 2.0 Client Credentials | Complete |
| JWT Validation | Complete |
| Application Role `Orders.Read` | Complete |
| 401 Authentication Test | Complete |
| 403 Authorization Test | Complete |
| 200 Authorized Request Test | Complete |

---

## Security

Client secrets and access tokens are not stored in this repository.

Local PowerShell token-generation scripts containing credentials are excluded through `.gitignore`.

In a production environment, secrets should be stored using an approved secrets-management solution such as Azure Key Vault or replaced by stronger identity mechanisms where appropriate.

---

## IBM DataPower Comparison

| IBM DataPower | Azure API Management |
|---|---|
| Multi Protocol Gateway | API Gateway |
| Processing Policy | APIM Policy |
| AAA Policy | JWT Authentication / Authorization Policies |
| Header Rewrite | set-header |
| URL Rewrite | rewrite-uri |
| Rate Limit | rate-limit |
| Backend URL | Backend Service |

Although the implementation differs, many enterprise integration and API security concepts remain comparable.

For example:

```text
DataPower AAA
     |
     +-- Authentication
     +-- Authorization

APIM
     |
     +-- validate-jwt
     +-- App Role Authorization
```

---

## Learning Goals

This part of the project demonstrates how Azure API Management can replace or complement traditional enterprise API gateways.

Topics include:

- API Gateway Design
- Enterprise API Security
- OAuth 2.0
- JWT
- Authentication vs Authorization
- Microsoft Entra ID App Roles
- Policy Management
- Rate Limiting
- Backend Routing
- Cloud-native API Management

---

## Next Steps

Planned enterprise platform improvements include:

- Enterprise naming conventions
- Azure resource tagging
- Infrastructure as Code
- Azure Key Vault integration
- Monitoring and observability
- Network security and APIM-to-AKS hardening