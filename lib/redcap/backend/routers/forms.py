from fastapi import APIRouter, Depends, HTTPException
from typing import List, Dict
from models.promis import (
    PromisForm,
    PromisResponse,
    PromisMetadataResponse,
    PromisSubmissionResponse
)
from services.redcap import RedcapService
from config import get_settings

router = APIRouter()

def get_redcap_service():
    settings = get_settings()
    return RedcapService(
        base_url=settings.redcap_api_url,
        api_key=settings.redcap_api_key
    )

@router.get("/test-connection", response_model=Dict)
async def test_redcap_connection(
    redcap_service: RedcapService = Depends(get_redcap_service)
):
    """
    Test the REDCap API connection
    """
    return await redcap_service.test_connection()

@router.get("/forms/metadata", response_model=PromisMetadataResponse)
async def get_forms_metadata(
    redcap_service: RedcapService = Depends(get_redcap_service)
):
    """
    Get metadata for all PROMIS forms
    """
    return await redcap_service.fetch_promis_metadata()

@router.post("/forms/submit", response_model=PromisSubmissionResponse)
async def submit_form_responses(
    response: PromisResponse,
    redcap_service: RedcapService = Depends(get_redcap_service)
):
    """
    Submit responses for a PROMIS form
    """
    formatted_response = {
        'record_id': response.record_id,
        **response.responses
    }
    return await redcap_service.submit_promis_responses(formatted_response) 