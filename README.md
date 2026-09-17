# Enterprise Integration Platform on Microsoft Azure

![Azure](https://img.shields.io/badge/Microsoft_Azure-0078D4?logo=microsoftazure&logoColor=white)
![APIM](https://img.shields.io/badge/Azure_API_Management-0078D4)
![AKS](https://img.shields.io/badge/AKS-Kubernetes-326CE5?logo=kubernetes&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-009688?logo=fastapi&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?logo=github&logoColor=white)
![OAuth2](https://img.shields.io/badge/OAuth2-Complete-success)
![JWT](https://img.shields.io/badge/JWT-Complete-success)

## Overview

This repository documents a hands-on **Enterprise Integration Platform** built on Microsoft Azure.

The project demonstrates how traditional enterprise integration, middleware and API gateway concepts can be implemented using modern cloud-native technologies.

The platform combines:

- Azure API Management (APIM)
- Azure Kubernetes Service (AKS)
- Azure Container Registry (ACR)
- Microsoft Entra ID
- NGINX Ingress Controller
- Kubernetes
- Docker
- FastAPI
- OpenAPI
- OAuth 2.0
- JWT
- Git and GitHub

The lab is continuously expanded with enterprise security, automation, Infrastructure as Code, monitoring and CI/CD capabilities.

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
    |-- App Role Authorization
    |-- Rate Limiting
    |
    v
NGINX Ingress Controller
    |
    v
Azure Kubernetes Service
    |
    v
Orders API Pods
    |
    v
FastAPI
```

Container images are stored in **Azure Container Registry (ACR)** and deployed to **Azure Kubernetes Service (AKS)**.

---

## Request and Security Flow

The Enterprise Orders API is protected using Microsoft Entra ID and Azure API Management.

```text
API Client
    |
    | Client Credentials
    v
Microsoft Entra ID
    |
    | JWT
    v
Azure API Management
    |
    +-- Missing / invalid JWT ------> 401 Unauthorized
    |
    +-- Missing Orders.Read --------> 403 Forbidden
    |
    +-- Rate Limit
    |
    v
NGINX Ingress
    |
    v
AKS
    |
    v
FastAPI Orders API ---------------> 200 OK
```

Authentication and authorization are deliberately separated.

- Authentication verifies that the JWT is valid.
- Authorization verifies that the calling application has the required `Orders.Read` application role.

---

## Current Features

### API and Container Platform

- FastAPI REST API
- OpenAPI specification
- Docker containerization
- Azure Container Registry
- Kubernetes Deployment
- Multiple application replicas
- Kubernetes ClusterIP Service
- Azure Kubernetes Service
- NGINX Ingress Controller
- Path-based routing

### Azure API Management

- OpenAPI import
- AKS backend integration
- API operations
- API Products
- API Subscriptions
- Subscription keys
- Inbound API policies
- JWT validation
- Application role authorization
- Rate limiting
- HTTP 401 / 403 / 429 handling

### Microsoft Entra ID

- Orders API App Registration
- Orders Client App Registration
- Orders Unauthorized Client for negative testing
- Application ID URI
- OAuth 2.0 Client Credentials
- Application permissions
- App Role `Orders.Read`
- Admin consent
- JWT access token generation

### DevOps

- Git source control
- GitHub repository
- Docker build workflow
- Kubernetes manifests under version control
- Security-sensitive local scripts excluded through `.gitignore`

---

## Authentication and Authorization

The API uses **OAuth 2.0 Client Credentials** for machine-to-machine authentication.

The authorized client requests an access token from Microsoft Entra ID.

The token contains the application role:

```text
Orders.Read
```

Azure API Management validates the JWT and then performs a separate authorization check.

### Security Test Results

All three primary security scenarios have been successfully tested:

| Scenario | Result | Status |
|---|---|---|
| Missing or invalid JWT | `401 Unauthorized` | Passed |
| Valid JWT without `Orders.Read` | `403 Forbidden` | Passed |
| Valid JWT with `Orders.Read` | `200 OK` | Passed |

This provides a clear separation between authentication and authorization:

```text
401 = Authentication failure
403 = Authorization failure
200 = Authenticated and authorized
```

---

## APIM Policy Flow

The `Get Orders` operation uses the following inbound policy flow:

```text
base
 |
 v
validate-jwt
 |
 +-- Invalid token --> 401
 |
 v
choose
 |
 +-- Missing Orders.Read --> 403
 |
 v
rate-limit
 |
 v
Backend
```

The `<base />` policy inherits policies configured at the parent API scope.

The `validate-jwt` policy validates the access token.

The `choose` policy performs application-role authorization.

The rate-limit policy limits traffic:

```xml
<rate-limit calls="5" renewal-period="60" />
```

When the limit is exceeded APIM returns:

```text
HTTP 429 Too Many Requests
```

---

## DataPower to Azure APIM

One objective of this project is to translate existing enterprise integration experience into modern Azure API Management concepts.

| IBM DataPower | Azure API Management |
|---|---|
| Multi-Protocol Gateway | API Gateway |
| Processing Policy | APIM Policy Pipeline |
| AAA Policy | Entra ID + JWT + Authorization Policies |
| Backend URL | Backend Service |
| URL Rewrite | rewrite-uri |
| Header Manipulation | set-header |
| Rate Limiting | rate-limit |
| TLS / mTLS | APIM Certificate Policies |
| Monitoring / Logging | Azure Monitor / Application Insights |

Although the technologies differ, many enterprise integration and security principles remain comparable.

Conceptually:

```text
IBM DataPower AAA
       |
       +-- Authentication
       +-- Authorization

Azure API Management
       |
       +-- validate-jwt
       +-- App Role Authorization
```

---

## Repository Structure

```text
enterprise-platform/
|
|-- api/
|   |-- app.py
|   `-- requirements.txt
|
|-- docker/
|   `-- Dockerfile
|
|-- kubernetes/
|   `-- orders-api.yaml
|
|-- apim/
|   |-- policies/
|   |-- screenshots/
|   `-- README.md
|
|-- entra-id/
|   `-- README.md
|
|-- diagrams/
|-- docs/
|-- scripts/
|-- terraform/
|
|-- .gitignore
`-- README.md
```

---

## Lab Progress

| Component | Status |
|---|---|
| FastAPI | Complete |
| Docker | Complete |
| Azure Container Registry | Complete |
| Kubernetes | Complete |
| AKS | Complete |
| NGINX Ingress | Complete |
| OpenAPI | Complete |
| Azure API Management | Complete |
| APIM Product | Complete |
| APIM Subscription | Complete |
| Rate Limiting | Complete |
| Microsoft Entra ID API Registration | Complete |
| Microsoft Entra ID Client Registration | Complete |
| OAuth 2.0 Client Credentials | Complete |
| OAuth 2.0 Access Token | Complete |
| JWT Validation in APIM | Complete |
| App Role `Orders.Read` | Complete |
| Authentication Test - 401 | Complete |
| Authorization Test - 403 | Complete |
| Authorized API Test - 200 | Complete |
| Enterprise Naming & Tagging | Complete |
| Terraform Fundamentals | Complete |
| Terraform Variables / Locals / Outputs | Complete |
| Terraform Remote State | Complete |
| Terraform State Locking | Complete |
| Terraform Drift Management | Complete |
| Terraform Provider Versioning | Complete |
| Terraform-managed Resource Group | Complete |
| Terraform-managed ACR | Complete |
| AKS Managed Identity → ACR | Complete |
| Azure RBAC `AcrPull` | Complete |
| Terraform Import | Complete |
| Azure Key Vault Deployment | Complete |
| Key Vault Secrets Management | In Progress |
| Managed Identity → Key Vault | Planned |
| GitHub Actions | Planned |
| Azure Monitor | Planned |
| Application Insights | Planned |
---

## Roadmap

### Phase 1 - Platform Foundation

- FastAPI
- Docker
- Azure Container Registry
- Kubernetes
- AKS
- NGINX Ingress

**Status: Complete**

### Phase 2 - API Management

- Azure API Management
- OpenAPI import
- Products
- Subscriptions
- Rate limiting
- API policies

**Status: Complete**

### Phase 3 - Identity and Security

- Microsoft Entra ID
- OAuth 2.0 Client Credentials
- JWT validation
- Application roles
- Claims-based authorization
- 401 / 403 / 200 security testing

**Status: Complete**

### Phase 4 - Enterprise Standards

- Naming conventions
- Resource tagging
- Resource organization
- Environment separation

**Status: Complete**

### Phase 5 - Infrastructure as Code

- Terraform fundamentals
- AzureRM provider versioning
- Variables, locals and outputs
- Remote state in Azure Storage
- Microsoft Entra ID authentication for remote state
- Terraform state locking
- Drift detection and remediation
- Terraform-managed Resource Group
- Terraform-managed Azure Container Registry
- Terraform-managed Azure Key Vault
- Azure RBAC with Terraform
- Importing existing Azure resources into Terraform state
- APIM configuration as code (planned)
- AKS configuration as code (planned)

**Status: In Progress**

### Phase 6 - CI/CD and GitOps

- GitHub Actions
- Automated Docker builds
- Automated image push to ACR
- Automated AKS deployment
- ArgoCD / GitOps

**Status: Planned**

### Phase 7 - Observability and Security

- Azure Key Vault deployment - Complete
- Key Vault RBAC authorization - Complete
- Managed Identity integration - In Progress
- Secrets management - In Progress
- Azure Monitor - Planned
- Application Insights - Planned
- Centralized logging - Planned
- APIM-to-AKS network hardening - Planned

**Status: In Progress**

---

## Learning Journey

This project builds on many years of enterprise integration experience and explores how those principles translate to modern Azure platforms.

```text
IBM WebSphere
     |
IBM MQ
     |
IBM DataPower
     |
Enterprise API Integration
     |
     v
Azure API Management
     |
     v
Microsoft Entra ID
     |
     v
OAuth 2.0 / JWT
     |
     v
Kubernetes / AKS
     |
     v
Infrastructure as Code
     |
     v
Modern Enterprise Platform Engineering
```

---

## Project Goals

The goal is not only to deploy a working API.

The project is intended to demonstrate understanding of:

- Enterprise integration architecture
- API gateway design
- API security
- Authentication and authorization
- OAuth 2.0 and JWT
- Microsoft Entra ID application roles
- Kubernetes networking
- Container platforms
- Cloud-native application delivery
- DevOps
- Infrastructure as Code
- Monitoring and observability

---

## Security

Authentication is implemented using Microsoft Entra ID using the OAuth 2.0 Client Credentials flow.

The Orders API is protected by Azure API Management using JWT validation and application-role authorization.

Client secrets and access tokens are not stored in this repository.

Local PowerShell scripts containing credentials are excluded through `.gitignore`.

For production environments, secrets should be stored in an approved secrets-management solution such as Azure Key Vault or replaced with stronger identity mechanisms where appropriate.

---

## About

This repository is part of my continuous professional development in modern cloud-native integration platforms.

My background includes **25+ years of Enterprise IT experience**, with expertise in integration, middleware, API management, security and DevOps.

The project combines that experience with modern technologies including Azure API Management, Kubernetes, AKS and Microsoft Entra ID.

---

## Author

**William van Slooten**

**Senior Integration & Platform Engineer**

Focus areas:

- IBM DataPower
- Azure API Management
- Enterprise Integration
- Kubernetes / AKS
- API Security
- Middleware
- DevOps
- CI/CD
- Microsoft Entra ID
- OAuth 2.0 / JWT
- Platform Engineering

---

## Next Milestone

The next milestone is completing **Azure Key Vault and Managed Identity integration**.

The platform already includes a Terraform-managed Azure Key Vault with RBAC authorization enabled.

The next steps are:

- Store and retrieve secrets securely using Azure Key Vault
- Configure Managed Identity access to Key Vault
- Apply least-privilege Azure RBAC
- Introduce Azure Monitor and Application Insights
- Build CI/CD pipelines with GitHub Actions
- Automate container build and deployment workflows
- Continue APIM and AKS Infrastructure as Code
- Harden APIM-to-AKS network access

---

> **25+ years of enterprise integration experience - continuously evolving toward modern cloud-native platform engineering.**