\# Azure API Management (APIM)



\## Overview



Azure API Management (APIM) is the API Gateway used within this Enterprise Integration Platform.



It provides a centralized entry point for all API traffic and enables enterprise capabilities such as authentication, authorization, routing, policy enforcement, monitoring and security.



\---



\# Objectives



This APIM implementation demonstrates:



\- API Gateway functionality

\- OpenAPI import

\- Backend integration with AKS

\- API Products

\- API Subscriptions

\- Subscription Keys

\- Rate Limiting

\- OAuth2 / JWT Authentication (In Progress)

\- API Policies

\- Enterprise API Security



\---



\# Architecture



```text

&#x20;                  API Client

&#x20;                       │

&#x20;                       ▼

&#x20;         Azure API Management

&#x20;            ├── Products

&#x20;            ├── Subscriptions

&#x20;            ├── Policies

&#x20;            ├── Rate Limiting

&#x20;            └── JWT Validation

&#x20;                       │

&#x20;                       ▼

&#x20;            NGINX Ingress Controller

&#x20;                       │

&#x20;                       ▼

&#x20;            Azure Kubernetes Service

&#x20;                       │

&#x20;                       ▼

&#x20;                FastAPI Orders API

```



\---



\# Implemented Features



\## API Import



\- OpenAPI Specification

\- Automatic API creation

\- API Operations



\## Backend



\- Azure Kubernetes Service

\- NGINX Ingress

\- FastAPI backend



\## Products



Implemented Product:



\- Enterprise Platform



\## Subscriptions



Implemented:



\- William Test Subscription



Subscription Keys are used to authorize API access.



\---



\# Implemented Policies



\## Rate Limiting



The following inbound policy limits API traffic:



```xml

<rate-limit calls="5" renewal-period="60" />

```



After five requests within sixty seconds APIM returns:



```

HTTP 429 Too Many Requests

```



This behavior has been successfully tested.



\---



\# Planned Policies



\- validate-jwt

\- set-header

\- rewrite-uri

\- set-variable

\- choose

\- cors

\- cache-lookup

\- cache-store



\---



\# Authentication



Current status:



| Feature | Status |

|----------|--------|

| Products | ✅ |

| Subscriptions | ✅ |

| Subscription Keys | ✅ |

| Rate Limiting | ✅ |

| Microsoft Entra ID | 🚧 |

| OAuth2 | 🚧 |

| JWT Validation | ⏳ |



\---



\# Repository Structure



```

apim/



├── README.md

├── policies/

└── screenshots/

```



\---



\# Learning Goals



This part of the project demonstrates how Azure API Management can replace or complement traditional enterprise API gateways.



Topics include:



\- API Gateway Design

\- Enterprise API Security

\- Policy Management

\- OAuth2

\- JWT

\- Backend Routing

\- Cloud-native API Management



\---



\# IBM DataPower Comparison



| IBM DataPower | Azure API Management |

|---------------|----------------------|

| Multi Protocol Gateway | API Gateway |

| Processing Policy | APIM Policy |

| AAA Policy | validate-jwt |

| Header Rewrite | set-header |

| URL Rewrite | rewrite-uri |

| Rate Limit | rate-limit |

| Backend URL | Backend Service |



Although the implementation differs, many enterprise integration concepts remain the same.



\---



\# Next Steps



\- Configure Microsoft Entra ID Authentication

\- Obtain OAuth2 Access Token

\- Implement validate-jwt Policy

\- Protect the Orders API using JWT Authentication

