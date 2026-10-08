"""Health endpoint and OpenAPI generation tests for the API shell."""

from fastapi.testclient import TestClient

from api.main import app

client = TestClient(app)


def test_health_returns_ok() -> None:
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_openapi_document_is_generated() -> None:
    response = client.get("/openapi.json")
    assert response.status_code == 200
    assert "/health" in response.json()["paths"]
