"""API configuration, read from environment variables."""

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Settings for the API shell. Values come from `SENTINEL_API_*` environment variables."""

    model_config = SettingsConfigDict(env_prefix="SENTINEL_API_")

    app_name: str = "Sentinel AI API"
