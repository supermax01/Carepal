from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .routers import forms

app = FastAPI(title="Carepal API", version="1.0.0")

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with specific origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(forms.router, prefix="/forms", tags=["forms"])
