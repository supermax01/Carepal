# Carepal FastAPI Backend

This is the FastAPI backend for the Carepal application, handling REDCap integration and PROMIS form management.

## Setup

1. Create a virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Create a `.env` file in the `api` directory with your REDCap credentials:
```
REDCAP_API_URL=your_redcap_api_url
REDCAP_API_KEY=your_redcap_api_key
```

## Running the Server

Start the development server:
```bash
uvicorn app.main:app --reload
```

The API will be available at `http://localhost:8000`

## API Endpoints

### GET /forms/metadata
Fetches metadata for all PROMIS forms from REDCap.

### POST /forms/submit
Submits form responses to REDCap.

Request body:
```json
{
    "record_id": "string",
    "form_name": "string",
    "responses": {
        "field_name": "value"
    }
}
```

## Documentation

- API documentation is available at `http://localhost:8000/docs`
- ReDoc alternative documentation at `http://localhost:8000/redoc`
