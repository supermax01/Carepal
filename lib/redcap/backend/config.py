from pydantic_settings import BaseSettings
from functools import lru_cache
import os
from pathlib import Path

# Get the root directory (where the main .env file is located)
ROOT_DIR = Path(__file__).resolve().parent.parent.parent.parent

class Settings(BaseSettings):
    redcap_api_url: str
    redcap_api_key: str

    class Config:
        env_file = ROOT_DIR / ".env"
        env_file_encoding = 'utf-8'

@lru_cache()
def get_settings():
    return Settings() 