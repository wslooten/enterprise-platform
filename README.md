\# Enterprise Integration Platform



Modern API Integration Platform demonstrating the transition from IBM DataPower to Azure API Management using Docker, Azure Kubernetes Service (AKS) and Azure Container Registry (ACR).



\## Architecture



```

&#x20;               Client

&#x20;                  │

&#x20;                  ▼

&#x20;     Azure API Management

&#x20;                  │

&#x20;                  ▼

&#x20;          NGINX Ingress

&#x20;                  │

&#x20;                  ▼

&#x20;     Kubernetes Service

&#x20;                  │

&#x20;         ┌────────┴────────┐

&#x20;         ▼                 ▼

&#x20;    Orders API Pod    Orders API Pod

&#x20;                  │

&#x20;                  ▼

&#x20;             FastAPI

```



\## Technologies



\- Azure API Management

\- Azure Kubernetes Service (AKS)

\- Azure Container Registry (ACR)

\- Docker

\- FastAPI

\- Kubernetes

\- OpenAPI

\- Git

\- Python



\## Features



\- REST API built with FastAPI

\- Docker containerization

\- Image storage in Azure Container Registry

\- Deployment to Azure Kubernetes Service

\- Kubernetes Service and NGINX Ingress

\- API publishing with Azure API Management

\- OpenAPI integration

