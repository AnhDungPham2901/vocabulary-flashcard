from pydantic_settings import BaseSettings
from typing import Optional


class Settings(BaseSettings):
    database_url: str = "postgresql://username:password@localhost:5432/vocabulary_flashcard"
    postgres_user: str = "username"
    postgres_password: str = "password"
    postgres_db: str = "vocabulary_flashcard"
    postgres_host: str = "localhost"
    postgres_port: int = 5432
    
    class Config:
        env_file = ".env"


settings = Settings()