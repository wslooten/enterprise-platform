# Enterprise Integration Platform on Microsoft Azure

![Azure](https://img.shields.io/badge/Microsoft_Azure-0078D4?logo=microsoftazure&logoColor=white)
![APIM](https://img.shields.io/badge/Azure_API_Management-0078D4)
![AKS](https://img.shields.io/badge/AKS-Kubernetes-326CE5?logo=kubernetes&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-009688?logo=fastapi&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-IaC-844FBA?logo=terraform&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?logo=github&logoColor=white)
![OAuth2](https://img.shields.io/badge/OAuth2-Complete-success)
![JWT](https://img.shields.io/badge/JWT-Complete-success)
![Workload Identity](https://img.shields.io/badge/Workload_Identity-Complete-success)
![Key Vault](https://img.shields.io/badge/Key_Vault-Complete-success)

---

## Overview

This repository documents a hands-on **Enterprise Integration Platform** built on Microsoft Azure.

The project demonstrates how traditional enterprise integration, middleware and API gateway concepts can be implemented using modern cloud-native technologies.

The platform combines:

- Azure API Management (APIM)
- Azure Kubernetes Service (AKS)
- Azure Container Registry (ACR)
- Azure Key Vault
- Microsoft Entra ID
- AKS Workload Identity
- OpenID Connect (OIDC) federation
- User Assigned Managed Identity
- Azure RBAC
- NGINX Ingress Controller
- Kubernetes
- Docker
- FastAPI
- OpenAPI
- OAuth 2.0
- JWT
- Terraform
- Git and GitHub

The lab is continuously expanded with enterprise security, automation, Infrastructure as Code, monitoring, observability and CI/CD capabilities.

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
    | Kubernetes ServiceAccount
    | orders-api-sa
    v
AKS Workload Identity / OIDC
    |
    v
Federated Identity Credential
    |
    v
User Assigned Managed Identity
    |
    | Key Vault Secrets User
    v
Azure Key Vault
```

Container images are stored in **Azure Container Registry (ACR)** and deployed to **Azure Kubernetes Service (AKS)**.

The Orders API uses **AKS Workload Identity** to access Azure Key Vault without storing Azure credentials in the Kubernetes workload.

A Kubernetes ServiceAccount is federated through the AKS OIDC issuer with a User Assigned Managed Identity. Azure RBAC grants this identity the `Key Vault Secrets User` role using least-privilege access.

---

## Security Architecture

The platform implements security at two different layers.

### Inbound API Security

```text
API Client
    |
    | OAuth 2.0 Client Credentials
    v
Microsoft Entra ID
    |
    | JWT
    v
Azure API Management
    |
    | Authentication
    | Authorization
    | Rate Limiting
    v
Orders API
```

### Outbound Workload Security

```text
Orders API Pod
    |
    v
Kubernetes ServiceAccount
orders-api-sa
    |
    v
AKS OIDC
    |
    v
Federated Identity Credential
    |
    v
User Assigned Managed Identity
    |
    | Azure RBAC
    v
Azure Key Vault
```

This avoids storing Azure client secrets inside the Kubernetes workload.

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
    +-- Rate Limit -----------------> 429 Too Many Requests
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
- Unauthorized client for negative testing
- Application ID URI
- OAuth 2.0 Client Credentials
- Application permissions
- App Role `Orders.Read`
- Admin consent
- JWT access token generation

### Workload Identity and Key Vault

- Azure Key Vault with RBAC authorization
- AKS OIDC issuer enabled
- AKS Workload Identity enabled
- Kubernetes ServiceAccount `orders-api-sa`
- User Assigned Managed Identity `id-orders-api-dev-swc-001`
- Federated Identity Credential `fic-orders-api`
- Azure RBAC role `Key Vault Secrets User`
- Passwordless authentication using `DefaultAzureCredential`
- Azure Key Vault SDK integration in the Orders API
- End-to-end AKS Pod to Key Vault access successfully tested
- No Azure client secrets stored in the Kubernetes workload
- Workload Identity Azure resources managed through Terraform

### Infrastructure as Code

- Terraform AzureRM provider
- Terraform provider version locking
- Terraform variables
- Terraform locals
- Terraform outputs
- Azure Storage remote state
- Microsoft Entra ID authentication for Terraform backend
- Terraform state locking
- Drift detection
- Resource import
- Azure RBAC management
- Terraform-managed Resource Group
- Terraform-managed Azure Container Registry
- Terraform-managed Azure Key Vault
- Terraform-managed User Assigned Managed Identity
- Terraform-managed Key Vault RBAC assignment
- Terraform-managed Federated Identity Credential

### DevOps

- Git source control
- GitHub repository
- Docker build workflow
- Kubernetes manifests under version control
- Terraform configuration under version control
- Security-sensitive local scripts excluded through `.gitignore`
- Terraform state excluded from Git
- Local `.tfvars` excluded from Git

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
 +-- Limit exceeded --> 429
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

## AKS Workload Identity

The Orders API accesses Azure Key Vault using **AKS Workload Identity**.

The Kubernetes Deployment uses the ServiceAccount:

```text
orders-api-sa
```

The ServiceAccount references the User Assigned Managed Identity through its Azure client ID.

The trust relationship is implemented through an Azure Federated Identity Credential.

Conceptually:

```text
Orders API Pod
       |
       v
orders-api-sa
       |
       v
AKS OIDC issuer
       |
       v
Federated Identity Credential
       |
       v
id-orders-api-dev-swc-001
       |
       v
Azure RBAC
       |
       v
Key Vault Secrets User
       |
       v
Azure Key Vault
```

The application uses:

```python
DefaultAzureCredential()
```

together with the Azure Key Vault SDK.

This allows the application to obtain an Azure identity without storing a client secret inside the container.

---

## Key Vault Integration

The Orders API contains a Key Vault integration endpoint used to validate the workload identity flow.

The application retrieves a test secret using the Azure Key Vault SDK.

The successful end-to-end flow proves that:

```text
Pod
 |
 v
Workload Identity
 |
 v
Microsoft Entra ID
 |
 v
Managed Identity
 |
 v
Azure RBAC
 |
 v
Azure Key Vault
 |
 v
Secret metadata returned to application
```

The application does not expose the secret value through the test endpoint.

---

## Azure RBAC

Azure RBAC is used throughout the platform.

### AKS to ACR

The AKS kubelet identity receives:

```text
AcrPull
```

This allows AKS to pull container images from Azure Container Registry without enabling the ACR admin account.

### Orders API to Key Vault

The Orders API User Assigned Managed Identity receives:

```text
Key Vault Secrets User
```

The scope is limited to the Orders Key Vault.

This implements least-privilege access.

---

## Terraform

Terraform is used to manage an increasing portion of the Azure platform.

### Terraform Workflow

```text
HCL Configuration
       |
       v
terraform fmt
       |
       v
terraform validate
       |
       v
terraform plan
       |
       v
Review Changes
       |
       v
terraform apply
       |
       v
Azure
```

### Terraform State Model

```text
Terraform Configuration
        |
        | desired configuration
        v
Terraform State
        |
        | maps Terraform resources
        v
Azure Resources
```

Terraform state is stored remotely in Azure Storage.

The backend uses Microsoft Entra ID authentication instead of Storage Account access keys.

### Terraform Import

Existing Azure resources were brought under Terraform management using `terraform import`.

The process used throughout the project is:

```text
Existing Azure Resource
        |
        v
Write Terraform Resource
        |
        v
terraform import
        |
        v
terraform plan
        |
        v
Review Drift
        |
        v
terraform apply (only when required)
        |
        v
terraform plan
        |
        v
No changes
```

Imported resources include:

- Existing Azure RBAC assignments
- User Assigned Managed Identity
- Key Vault `Secrets User` role assignment
- Federated Identity Credential

The final validation returned:

```text
No changes. Your infrastructure matches the configuration.
```

---

## Observability and Monitoring

The platform implements centralized logging and metrics monitoring for the AKS workload using Azure Monitor.

### Logging

AKS Container Insights collects container logs and sends them to a Log Analytics Workspace.

```text
Orders API Pod
      |
      | stdout / stderr
      v
Azure Monitor Agent
      |
      v
Container Insights
      |
      v
Log Analytics Workspace
      |
      v
ContainerLogV2
      |
      v
KQL

## DataPower to Azure APIM

One objective of this project is to translate existing enterprise integration experience into modern Azure API Management concepts.

| IBM DataPower | Azure API Management |
|---|---|
| Multi-Protocol Gateway | API Gateway |
| Processing Policy | APIM Policy Pipeline |
| AAA Policy | Entra ID + JWT + Authorization Policies |
| Backend URL | Backend Service |
| URL Rewrite | `rewrite-uri` |
| Header Manipulation | `set-header` |
| Rate Limiting | `rate-limit` |
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
|   |-- orders-api.yaml
|   `-- orders-api-serviceaccount.yaml
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
|
|-- docs/
|   `-- naming-and-tagging.md
|
|-- scripts/
|
|-- terraform/
|   |-- main.tf
|   |-- providers.tf
|   |-- variables.tf
|   |-- outputs.tf
|   `-- terraform.tfvars.example
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
| Key Vault Secrets Management | Complete |
| AKS OIDC Issuer | Complete |
| AKS Workload Identity | Complete |
| Kubernetes ServiceAccount | Complete |
| User Assigned Managed Identity | Complete |
| Federated Identity Credential | Complete |
| Managed Identity → Key Vault | Complete |
| Key Vault `Secrets User` RBAC | Complete |
| `DefaultAzureCredential` Integration | Complete |
| Orders API → Key Vault Test | Complete |
| Workload Identity Terraform Import | Complete |
| Azure Monitor | Complete |
| AKS Container Insights | Complete |
| Log Analytics Workspace | Complete |
| Centralized Logging | Complete |
| KQL Log Analysis | Complete |
| Azure Monitor Managed Prometheus | Complete |
| Azure Monitor Workspace | Complete |
| PromQL Metrics Analysis | Complete |
| Prometheus Alert Rule | Complete |
| Alert Fired Test | Complete |
| Alert Resolved Test | Complete |
| Application Insights | Planned |
| GitHub Actions | Planned |
| APIM-to-AKS Network Hardening | Planned |

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

### Phase 3 - Identity and API Security

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
- User Assigned Managed Identity with Terraform
- Key Vault RBAC with Terraform
- Federated Identity Credential with Terraform
- APIM configuration as code - Planned
- AKS configuration as code - Planned

**Status: In Progress**

### Phase 6 - Workload Identity and Secrets

- Azure Key Vault
- Key Vault RBAC authorization
- AKS OIDC issuer
- AKS Workload Identity
- Kubernetes ServiceAccount
- User Assigned Managed Identity
- Federated Identity Credential
- Passwordless authentication
- `DefaultAzureCredential`
- Azure Key Vault SDK
- End-to-end workload identity validation

**Status: Complete**

### Phase 7 - Observability and Operations

- Azure Monitor
- AKS Container Insights
- Log Analytics Workspace
- Centralized container logging
- KQL log analysis
- Azure Monitor Managed Prometheus
- Azure Monitor Workspace
- PromQL metrics analysis
- AKS node and workload metrics
- Orders API CPU and memory monitoring
- Deployment replica availability monitoring
- Terraform-managed Prometheus alert rule
- `OrdersApiReplicasUnavailable` availability alert
- Azure Monitor alert lifecycle testing
- Operational troubleshooting
- Application Insights - Planned future extension

**Status: Complete**

### Phase 8 - CI/CD and GitOps

- GitHub Actions
- Automated Docker builds
- Automated image push to ACR
- Automated AKS deployment
- ArgoCD / GitOps

**Status: Planned**

### Phase 9 - Network Hardening

- Restrict direct public backend access
- Harden APIM-to-AKS communication
- Review private networking options
- Review ACR network exposure

**Status: Planned**

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
Workload Identity / Key Vault
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

The project is intended to demonstrate practical understanding of:

- Enterprise integration architecture
- API gateway design
- API security
- Authentication and authorization
- OAuth 2.0 and JWT
- Microsoft Entra ID application roles
- Kubernetes networking
- Container platforms
- Azure identity
- Workload Identity
- OIDC federation
- Azure RBAC
- Secrets management
- Infrastructure as Code
- Terraform state management
- Cloud-native application delivery
- DevOps
- Monitoring and observability

---

## Security

Authentication is implemented using Microsoft Entra ID and the OAuth 2.0 Client Credentials flow.

The Orders API is protected by Azure API Management using JWT validation and application-role authorization.

For Azure resource access, the Orders API uses AKS Workload Identity instead of stored Azure client credentials.

The application authenticates using `DefaultAzureCredential`, a Kubernetes ServiceAccount, OIDC federation and a User Assigned Managed Identity.

Azure RBAC grants the workload only the permissions required to access Key Vault secrets.

Client secrets, access tokens, Terraform state and local credential files are not stored in this repository.

Security-sensitive local PowerShell scripts and local Terraform variable files are excluded through `.gitignore`.

---

## Next Milestone

The next milestone is **Phase 8 - CI/CD and GitOps**.

The platform now includes:

- End-to-end API security
- OAuth 2.0 and JWT authorization
- AKS Workload Identity
- Passwordless Key Vault access
- Terraform-managed Azure infrastructure
- Centralized AKS logging
- KQL-based log analysis
- Azure Monitor Managed Prometheus
- PromQL-based metrics monitoring
- Azure Monitor alerting

The next steps are:

- Introduce GitHub Actions
- Automate Docker image builds
- Authenticate GitHub workflows securely with Azure
- Push application images automatically to Azure Container Registry
- Automate AKS application deployment
- Evaluate GitOps deployment using ArgoCD
- Continue APIM and AKS Infrastructure as Code
- Harden APIM-to-AKS network access

---

## About

This repository is part of my continuous professional development in modern cloud-native integration platforms.

My background includes **25+ years of Enterprise IT experience**, with expertise in integration, middleware, API management, security and DevOps.

The project combines that experience with modern technologies including Azure API Management, Kubernetes, AKS, Microsoft Entra ID, Terraform and Azure Workload Identity.

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
- Terraform
- Azure Workload Identity
- Platform Engineering

---

> **25+ years of enterprise integration experience - continuously evolving toward modern cloud-native platform engineering.**