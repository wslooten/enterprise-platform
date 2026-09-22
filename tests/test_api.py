from fastapi.testclient import TestClient
from api.app import app

client = TestClient(app)


def test_orders():
    response = client.get("/orders")

    assert response.status_code == 200

    orders = response.json()

    assert isinstance(orders, list)
    assert len(orders) > 0