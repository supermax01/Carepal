import httpx
from typing import Dict, List, Optional
import json
from models.promis import PromisMetadataResponse, PromisSubmissionResponse

class RedcapService:
    # PROMIS form names from your REDCap project
    PROMIS_INSTRUMENTS = [
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

    def __init__(self, base_url: str, api_key: str):
        self.base_url = base_url.rstrip('/')  # Remove trailing slash if present
        self.api_key = api_key

    async def test_connection(self) -> Dict:
        """Test the REDCap connection with a simple metadata request"""
        try:
            data = {
                'token': self.api_key,
                'content': 'metadata',
                'format': 'json',
                'returnFormat': 'json',
                'fields[0]': 'record_id',
                'forms[0]': 'promis_v10_pain_intensity_1a'
            }
            
            async with httpx.AsyncClient() as client:
                response = await client.post(self.base_url, data=data)
                
            return {
                'status_code': response.status_code,
                'data': response.json() if response.status_code == 200 else None,
                'error': None if response.status_code == 200 else response.text
            }
        except Exception as e:
            return {
                'status_code': 500,
                'data': None,
                'error': str(e)
            }

    async def fetch_promis_metadata(self) -> PromisMetadataResponse:
        try:
            # Create base request data
            data = {
                'token': self.api_key,
                'content': 'metadata',
                'format': 'json',
                'returnFormat': 'json',
            }

            # Add forms
            for i, form in enumerate(self.PROMIS_INSTRUMENTS):
                data[f'forms[{i}]'] = form

            # Add fields
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
                data[f'fields[{i}]'] = field

            async with httpx.AsyncClient() as client:
                response = await client.post(self.base_url, data=data)

            if response.status_code == 200:
                json_data = response.json()
                
                # Organize data by form name
                organized_data: Dict[str, List] = {}
                for item in json_data:
                    form_name = item['form_name']
                    if form_name not in organized_data:
                        organized_data[form_name] = []
                    organized_data[form_name].append(item)

                return PromisMetadataResponse(success=True, data=organized_data)
            else:
                return PromisMetadataResponse(
                    success=False,
                    error=f'Failed to fetch metadata: {response.status_code} - {response.text}'
                )

        except Exception as e:
            return PromisMetadataResponse(
                success=False,
                error=f'Error fetching metadata: {str(e)}'
            )

    async def submit_promis_responses(
        self,
        responses: Dict[str, any]
    ) -> PromisSubmissionResponse:
        try:
            data = {
                'token': self.api_key,
                'content': 'record',
                'format': 'json',
                'type': 'flat',
                'data': json.dumps([responses]),
            }

            async with httpx.AsyncClient() as client:
                response = await client.post(self.base_url, data=data)

            if response.status_code == 200:
                return PromisSubmissionResponse(success=True)
            else:
                return PromisSubmissionResponse(
                    success=False,
                    error=f'Failed to submit responses: {response.status_code} - {response.text}'
                )

        except Exception as e:
            return PromisSubmissionResponse(
                success=False,
                error=f'Error submitting responses: {str(e)}'
            ) 