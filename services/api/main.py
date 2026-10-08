"""FastAPI application shell: health endpoint and generated OpenAPI document only."""

from fastapi import FastAPI

from api.settings import Settings


def create_app(settings: Settings | None = None) -> FastAPI:
    """Create the FastAPI application."""
    resolved = settings if settings is not None else Settings()
    application = FastAPI(title=resolved.app_name)

    @application.get("/health")
    def health() -> dict[str, str]:
        """Report that the API process is running."""
        return {"status": "ok"}

    return application


app = create_app()
