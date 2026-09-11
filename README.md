# Enterprise Integration Platform on Microsoft Azure

![Azure](https://img.shields.io/badge/Microsoft_Azure-0078D4?logo=microsoftazure&logoColor=white)
![APIM](https://img.shields.io/badge/Azure_API_Management-0078D4)
![AKS](https://img.shields.io/badge/AKS-Kubernetes-326CE5?logo=kubernetes&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-009688?logo=fastapi&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?logo=github&logoColor=white)
![OAuth2](https://img.shields.io/badge/OAuth2-In_Progress-orange)
![JWT](https://img.shields.io/badge/JWT-Planned-lightgrey)

## Overview

This repository documents a hands-on **Enterprise Integration Platform** built on Microsoft Azure.

The project demonstrates how traditional enterprise integration and API gateway concepts can be implemented using modern cloud-native technologies.

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
- Git and GitHub

The lab is continuously expanded with API security, automation, Infrastructure as Code, monitoring and CI/CD capabilities.

---

## Architecture

```text
                         API Client
                             │
                             │
                    OAuth2 / JWT Token
                             │
                             ▼
                   Microsoft Entra ID
                             │
                             ▼
                Azure API Management
                  ├─ Products
                  ├─ Subscriptions
                  ├─ Rate Limiting
                  ├─ API Policies
                  └─ JWT Validation
                             │
                             ▼
                NGINX Ingress Controller
                             │
                             ▼
                 Kubernetes Service
                             │
                   ┌─────────┴─────────┐
                   ▼                   ▼
            Orders API Pod       Orders API Pod
                   │                   │
                   └─────────┬─────────┘
                             ▼
                          FastAPI
```

Container images are stored in **Azure Container Registry (ACR)** and deployed to **Azure Kubernetes Service (AKS)**.

---

## Request Flow

A typical API request follows this path:

```text
Client
  │
  ▼
Microsoft Entra ID
  │
  │ OAuth2 / JWT
  ▼
Azure API Management
  │
  │ API Policies
  ▼
NGINX Ingress
  │
  ▼
Kubernetes Service
  │
  ▼
Orders API Pods
  │
  ▼
FastAPI
```

Azure API Management provides the enterprise API gateway layer, while NGINX Ingress handles HTTP routing inside the Kubernetes environment.

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
- Rate limiting
- HTTP 429 validation using the APIM Test Console

### Microsoft Entra ID

- Orders API App Registration
- Orders Client App Registration
- Application ID URI
- OAuth2 delegated scope
- API permissions
- Admin consent

### DevOps

- Git source control
- GitHub repository
- Docker build workflow
- Kubernetes manifests under version control

---

## API Management Policy Example

The following APIM policy limits an API subscription to five requests within a sixty-second window:

```xml
<rate-limit calls="5" renewal-period="60" />
```

When the limit is exceeded, APIM returns:

```text
HTTP 429 Too Many Requests
```

This protects backend services from excessive API traffic.

---

## Microsoft Entra ID Authentication

The authentication architecture uses two App Registrations.

### Orders API

Represents the protected API and exposes the OAuth2 scope:

```text
access
```

### Orders Client

Represents an application that requests access to the Orders API.

The client has delegated permission to the Orders API scope.

The next step is obtaining an access token and configuring APIM to validate the JWT.

---

## DataPower to Azure APIM

One objective of this project is to translate existing enterprise integration experience into modern Azure API Management concepts.

| IBM DataPower | Azure API Management |
|---|---|
| Multi-Protocol Gateway | API / Gateway |
| Processing Policy | APIM Policy Pipeline |
| AAA Policy | Entra ID + validate-jwt + authorization policies |
| Backend URL | Backend Service |
| URL Rewrite | rewrite-uri |
| Header Manipulation | set-header |
| Rate Limiting | rate-limit |
| TLS / mTLS | APIM Certificates / Client Certificate Validation |
| Monitoring / Logging | Azure Monitor / Application Insights |

The products differ technically, but many underlying integration and security principles remain familiar.

---

## Repository Structure

```text
enterprise-platform/
│
├── api/
│   ├── app.py
│   └── requirements.txt
│
├── docker/
│   └── Dockerfile
│
├── kubernetes/
│   └── orders-api.yaml
│
├── apim/
│   ├── policies/
│   ├── screenshots/
│   └── README.md
│
├── entra-id/
│   └── README.md
│
├── diagrams/
├── docs/
├── scripts/
├── terraform/
│
├── .gitignore
└── README.md
```

---

## Lab Progress

| Component | Status |
|---|---|
| FastAPI | ✅ Complete |
| Docker | ✅ Complete |
| Azure Container Registry | ✅ Complete |
| Kubernetes | ✅ Complete |
| AKS | ✅ Complete |
| NGINX Ingress | ✅ Complete |
| OpenAPI | ✅ Complete |
| Azure API Management | ✅ Complete |
| APIM Product | ✅ Complete |
| APIM Subscription | ✅ Complete |
| Rate Limiting | ✅ Complete |
| Microsoft Entra ID API Registration | ✅ Complete |
| Microsoft Entra ID Client Registration | ✅ Complete |
| OAuth2 Scope | ✅ Complete |
| API Permissions | ✅ Complete |
| Admin Consent | ✅ Complete |
| Client Secret | 🚧 In Progress |
| OAuth2 Access Token | ⏳ Planned |
| JWT Validation in APIM | ⏳ Planned |
| Terraform | ⏳ Planned |
| GitHub Actions | ⏳ Planned |
| Azure Monitor | ⏳ Planned |
| Application Insights | ⏳ Planned |
| Azure Key Vault | ⏳ Planned |

---

## Roadmap

### Phase 1 — Platform Foundation

- FastAPI
- Docker
- Azure Container Registry
- Kubernetes
- AKS
- NGINX Ingress

### Phase 2 — API Management

- Azure API Management
- OpenAPI import
- Products
- Subscriptions
- Rate limiting
- API policies

### Phase 3 — Identity and Security

- Microsoft Entra ID
- OAuth2
- Client credentials
- JWT validation
- Claims-based authorization
- API security policies

### Phase 4 — Infrastructure as Code

- Terraform
- APIM configuration as code
- AKS configuration as code
- Azure Container Registry configuration
- Policy deployment

### Phase 5 — CI/CD and GitOps

- GitHub Actions
- Automated Docker builds
- Automated image push to ACR
- Automated AKS deployment
- ArgoCD / GitOps

### Phase 6 — Observability and Security

- Azure Monitor
- Application Insights
- Centralized logging
- Azure Key Vault
- Managed Identity
- Secrets management

---

## Learning Journey

This project builds on many years of enterprise integration experience and explores how those principles translate to modern Azure platforms.

```text
IBM WebSphere
      │
IBM MQ
      │
IBM DataPower
      │
Enterprise API Integration
      │
      ▼
Azure API Management
      │
      ▼
Kubernetes / AKS
      │
      ▼
Microsoft Entra ID
      │
      ▼
OAuth2 / JWT
      │
      ▼
Infrastructure as Code
      │
      ▼
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
- Kubernetes networking
- Container platforms
- Cloud-native application delivery
- DevOps
- Infrastructure as Code
- Monitoring and observability

---

## About

This repository is part of my continuous professional development in modern cloud-native integration platforms.

My background includes **25+ years of Enterprise IT experience**, with expertise in integration, middleware, API management, security and DevOps.

The project combines that experience with modern technologies including Azure API Management, Kubernetes, AKS, Microsoft Entra ID and Infrastructure as Code.

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
- OAuth2 / JWT
- Platform Engineering

---

## Continuous Development

This platform is actively being developed.

The next milestone is:

> **OAuth2 access token retrieval and JWT validation in Azure API Management.**

After that, the project will expand into Terraform, CI/CD, monitoring, secrets management and GitOps.

---

> **25+ years of enterprise integration experience — continuously evolving toward modern cloud-native platform engineering.**