from fastapi import FastAPI

app = FastAPI(
    title="Enterprise Orders API",
    version="1.0"
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