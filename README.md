# Enterprise Integration Platform on Microsoft Azure

![Azure](https://img.shields.io/badge/Microsoft-Azure-0078D4?logo=microsoftazure&logoColor=white)
![AKS](https://img.shields.io/badge/AKS-Kubernetes-326CE5?logo=kubernetes&logoColor=white)
![APIM](https://img.shields.io/badge/API-Management-green)
![FastAPI](https://img.shields.io/badge/FastAPI-Python-009688?logo=fastapi&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)
![Microsoft Entra ID](https://img.shields.io/badge/Entra_ID-OAuth2/JWT-5C2D91)
![GitHub](https://img.shields.io/badge/GitHub-Portfolio-black?logo=github)

---

# Overview

This repository demonstrates an **Enterprise Integration Platform** built on **Microsoft Azure** using modern cloud-native technologies and enterprise security principles.

The project combines traditional enterprise integration experience with modern Azure services, demonstrating how APIs can be securely exposed, protected and managed.

The lab is continuously expanded with new Azure components and follows enterprise best practices.

---

# Technologies

- Azure API Management (APIM)
- Azure Kubernetes Service (AKS)
- Microsoft Entra ID
- OAuth2
- JWT Authentication
- FastAPI
- Docker
- Kubernetes
- NGINX Ingress Controller
- GitHub
- Terraform *(coming soon)*
- GitHub Actions *(coming soon)*

---

# Enterprise Architecture

```text
                    +----------------------+
                    |      API Client      |
                    +----------+-----------+
                               |
                        OAuth2 / JWT
                               |
                               v
                  +-------------------------+
                  | Microsoft Entra ID      |
                  +------------+------------+
                               |
                               v
               +------------------------------+
               | Azure API Management (APIM)  |
               | • Rate Limiting              |
               | • API Policies              |
               | • JWT Validation            |
               +-------------+---------------+
                             |
                             |
                             v
              +------------------------------+
              | NGINX Ingress Controller     |
              +-------------+----------------+
                            |
                            |
                            v
                 +--------------------------+
                 | Azure Kubernetes Service |
                 |           AKS            |
                 +-------------+------------+
                               |
                               |
                               v
                     +-------------------+
                     | FastAPI Orders API|
                     +-------------------+
```

---

# Features

## Completed

- FastAPI REST API
- Docker Containerization
- Kubernetes Deployment
- Azure Kubernetes Service
- NGINX Ingress
- Azure API Management
- API Products
- API Subscriptions
- Rate Limiting Policies
- Microsoft Entra ID App Registration
- OAuth2 Scope Configuration
- API Permissions
- Enterprise API Testing

---

## In Progress

- JWT Validation inside Azure API Management
- OAuth2 Protected APIs
- Terraform Infrastructure as Code
- GitHub Actions CI/CD
- Monitoring & Logging

---

# Repository Structure

```
enterprise-platform/

├── api/
├── apim/
│   ├── policies/
│   ├── screenshots/
│   └── README.md
│
├── docker/
├── kubernetes/
├── entra-id/
├── diagrams/
├── terraform/
├── docs/
├── scripts/
│
├── README.md
└── .gitignore
```

---

# Learning Objectives

This repository is used to gain hands-on experience with:

- Enterprise API Management
- Cloud Native Development
- Azure Platform Engineering
- Kubernetes
- Enterprise Security
- OAuth2
- JWT Authentication
- Infrastructure as Code
- DevOps Automation

---

# Current Lab Progress

| Component | Status |
|-----------|--------|
| FastAPI | Complete |
| Docker | Complete |
| Kubernetes | Complete |
| AKS | Complete |
| Azure API Management | Complete |
| Products | Complete |
| Subscriptions | Complete |
| Rate Limiting | Complete |
| Microsoft Entra ID | Complete |
| OAuth2 | Complete |
| JWT Validation | In Progress |
| Terraform | Planned |
| GitHub Actions | Planned |

---

# Screenshots

The repository contains screenshots demonstrating:

- Azure API Management
- API Policies
- Rate Limiting
- Microsoft Entra ID
- OAuth2 Configuration
- Kubernetes Deployments

---

# Roadmap

## Phase 1
- FastAPI
- Docker
- Kubernetes

## Phase 2
- Azure Kubernetes Service
- Azure API Management

## Phase 3
- Microsoft Entra ID
- OAuth2
- JWT Authentication

## Phase 4
- Terraform
- GitHub Actions
- Monitoring
- Production Deployment

---

# About

This repository documents my journey from **IBM DataPower Enterprise Integration** towards **Microsoft Azure Integration Platform Engineering**.

It demonstrates practical experience with Azure API Management, Kubernetes, cloud-native integration and enterprise API security.

---

## Author

**William van Slooten**

Senior DevOps & Platform Engineer

25+ years of Enterprise IT experience

Specialized in:

- IBM DataPower
- Enterprise Integration
- API Management
- Azure Platform Engineering
- Kubernetes
- DevOps
- Enterprise Security

---

> Continuous learning never stops. Every lab brings new insights into modern enterprise integration.