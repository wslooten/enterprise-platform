from fastapi import FastAPI
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient

app = FastAPI(
    title="Enterprise Orders API",
    version="1.1"
)

orders = [
    {
        "id": 1,
        "customer": "William",
        "product": "Laptop"
    },
    {
        "id": 2,
        "customer": "Jan",
        "product": "Monitor"
    }
]

@app.get("/")
def home():
    return {
        "message": "Enterprise Orders API"
    }

@app.get("/orders")
def get_orders():
    return orders

@app.get("/keyvault-test")
def keyvault_test():
    credential = DefaultAzureCredential()

    client = SecretClient(
        vault_url="https://kv-orders-dev-swc-001.vault.azure.net/",
        credential=credential
    )

    secret = client.get_secret("orders-test-secret")

    return {
        "status": "OK",
        "keyvault": "connected",
        "secret_name": secret.name
    }