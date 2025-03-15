from pydantic import BaseModel, Field
from typing import List, Optional, Dict

class PromisQuestion(BaseModel):
    field_name: str
    form_name: str
    field_type: str
    field_label: str
    select_choices: Optional[Dict[str, str]] = None
    is_required: bool = False
    section_header: Optional[str] = None

class PromisScores(BaseModel):
    t_score: Optional[str] = None
    standard_error: Optional[str] = None

class PromisForm(BaseModel):
    form_name: str
    form_label: str
    questions: List[PromisQuestion]
    scores: Optional[PromisScores] = None

class PromisResponse(BaseModel):
    record_id: str
    form_name: str
    responses: Dict[str, str]

class PromisMetadataResponse(BaseModel):
    success: bool
    data: Optional[Dict[str, List[Dict]]] = None
    error: Optional[str] = None

class PromisSubmissionResponse(BaseModel):
    success: bool
    error: Optional[str] = None 