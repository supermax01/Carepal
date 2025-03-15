from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import Dict, List, Optional
import requests
import os
from dotenv import load_dotenv

load_dotenv()

router = APIRouter()
REDCAP_API_URL = os.getenv("REDCAP_API_URL")
REDCAP_API_KEY = os.getenv("REDCAP_API_KEY")

class FormResponse(BaseModel):
    record_id: str
    form_name: str
    responses: Dict[str, str]

@router.get("/metadata")
async def get_forms_metadata():
    """
    Fetch metadata for all PROMIS forms from REDCap
    """
    try:
        # List of PROMIS forms to fetch
        forms = [
            'promis_sf_v20_physical_function_4a',
            'promis_sf_v10_anxiety_4a',
            'promis_sf_v10_depression_4a',
            'promis_sf_v10_fatigue_4a',
            'promis_sf_v10_sleep_disturbance_4a_3c77',
            'promis_sf_v20_ability_to_participate_social_4a',
            'promis_sf_v10_pain_interference_4a',
            'promis_v10_pain_intensity_1a',
            'promis_sf_v20_cognitive_function_abilities_2a',
        ]
        
        # Create the request payload
        payload = {
            'token': REDCAP_API_KEY,
            'content': 'metadata',
            'format': 'json',
            'returnFormat': 'json',
        }

        # Add forms to payload
        for i, form in enumerate(forms):
            payload[f'forms[{i}]'] = form

        # Add required fields
        fields = [
            'field_name',
            'form_name',
            'field_type',
            'field_label',
            'select_choices_or_calculations',
            'required_field',
            'branching_logic',
            'custom_alignment',
            'matrix_group_name',
            'matrix_ranking',
            'question_number'
        ]

        for i, field in enumerate(fields):
            payload[f'fields[{i}]'] = field

        # Make request to REDCap API
        response = requests.post(REDCAP_API_URL, data=payload)
        
        if response.status_code == 200:
            data = response.json()
            
            # Organize data by form name
            organized_data = {}
            for item in data:
                form_name = item['form_name']
                if form_name not in organized_data:
                    organized_data[form_name] = []
                organized_data[form_name].append(item)
            
            return {"success": True, "data": organized_data}
        else:
            raise HTTPException(
                status_code=response.status_code,
                detail=f"REDCap API error: {response.text}"
            )
            
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Error fetching form metadata: {str(e)}"
        )

@router.post("/submit")
async def submit_form_responses(form_data: FormResponse):
    """
    Submit form responses to REDCap
    """
    try:
        # Prepare the data for REDCap
        payload = {
            'token': REDCAP_API_KEY,
            'content': 'record',
            'format': 'json',
            'type': 'flat',
            'data': [{
                'record_id': form_data.record_id,
                **form_data.responses
            }]
        }

        # Make request to REDCap API
        response = requests.post(REDCAP_API_URL, data=payload)
        
        if response.status_code == 200:
            return {"success": True}
        else:
            raise HTTPException(
                status_code=response.status_code,
                detail=f"REDCap API error: {response.text}"
            )
            
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Error submitting form responses: {str(e)}"
        )
