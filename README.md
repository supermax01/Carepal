# CarePal: Mobile PROMIS Assessment Platform

> A secure, mobile-first solution for patient-reported outcomes integrated with REDCap

## 🌟 Overview

CarePal transforms traditional paper-based PROMIS (Patient-Reported Outcomes Measurement Information System) assessments into a modern digital experience. Built with Flutter and FastAPI, it enables patients to complete health assessments directly from their smartphones while ensuring secure integration with REDCap.

## 🏗️ REDCap API Architecture

### Data Flow Architecture
```mermaid
sequenceDiagram
    participant Patient using Mobile App
    participant Flutter App
    participant FastAPI Server
    participant REDCap API
    participant Secure Storage

    Note over Patient using Mobile App: Starts PROMIS Assessment
    
    Flutter App->>Secure Storage: Get REDCap Token
    Secure Storage-->>Flutter App: Return Encrypted Token
    
    Flutter App->>FastAPI Server: Request Form Metadata
    FastAPI Server->>REDCap API: GET /api/metadata
    Note over FastAPI Server,REDCap API: Token-based Authentication
    REDCap API-->>FastAPI Server: Return Form Structure
    FastAPI Server-->>Flutter App: Formatted PROMIS Form
    
    Patient using Mobile App->>Flutter App: Complete Assessment
    
    alt Online Mode
        Flutter App->>FastAPI Server: Submit Responses
        FastAPI Server->>REDCap API: POST /api/records
        REDCap API-->>FastAPI Server: Confirmation
        FastAPI Server-->>Flutter App: Success Response
    else Offline Mode
        Flutter App->>Secure Storage: Store Responses Locally
        Note over Flutter App: Queue for Sync
    end
```

### REDCap API Integration Points

1. **Form Metadata Retrieval**
   ```python
   # FastAPI Backend
   async def get_form_metadata(form_name: str):
       payload = {
           'token': config.REDCAP_TOKEN,
           'content': 'metadata',
           'format': 'json',
           'forms[0]': form_name
       }
       response = await redcap_client.post(payload)
       return format_promis_form(response)
   ```

2. **Response Submission**
   ```python
   # FastAPI Backend
   async def submit_responses(record_id: str, responses: dict):
       payload = {
           'token': config.REDCAP_TOKEN,
           'content': 'record',
           'format': 'json',
           'type': 'flat',
           'data': json.dumps([{
               'record_id': record_id,
               **responses
           }])
       }
       return await redcap_client.post(payload)
   ```

### Security Implementation

1. **Token Management**
   ```dart
   // Flutter Secure Storage
   class SecureStorageService {
     static const _storage = FlutterSecureStorage();
     
     Future<String?> getRedcapToken() async {
       return await _storage.read(key: 'REDCAP_TOKEN');
     }
   }
   ```

2. **API Authentication Flow**
   ```mermaid
   graph TD
       A[Request Initiated] -->|Get Token| B[Secure Storage]
       B -->|Token Retrieved| C[Add to Headers]
       C -->|Make Request| D[REDCap API]
       D -->|Validate Token| E[Process Request]
       E -->|Return Response| F[Handle Response]
   ```

### Error Handling & Recovery

1. **Network Issues**
   - Automatic retry with exponential backoff
   - Offline storage for failed submissions
   - Background sync when connection restored

2. **API Errors**
   - Token validation errors → Re-authentication
   - Rate limiting → Request queuing
   - Data validation → Client-side fixes

### Data Synchronization

1. **Online Mode**
   - Real-time form submission
   - Immediate response validation
   - Direct REDCap integration

2. **Offline Mode**
   - Local storage of responses
   - Queue management for pending submissions
   - Conflict resolution on sync

## 🚀 Key Features

- **Mobile-First PROMIS Forms**
  - Intuitive user interface
  - Offline support
  - Real-time validation
  - Multi-language support

- **Secure REDCap Integration**
  - Token-based authentication
  - Encrypted data transmission
  - Automatic synchronization
  - Error recovery

- **Advanced Security**
  - Environment-based configuration
  - Secure token storage
  - Data encryption
  - HIPAA compliance measures

## 🛠️ Technical Stack

### Frontend (Flutter)
- State Management: Bloc Pattern
- Secure Storage: flutter_secure_storage
- API Client: dio with interceptors
- Offline Support: Hive

### Backend (FastAPI)
- REDCap Integration Service
- Token Management
- Response Validation
- Error Handling

## 📋 Prerequisites

- Flutter SDK
- Python 3.8+
- REDCap API Access
- Virtual Environment

## 🔧 Setup

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/carepal.git
   cd carepal
   ```

2. **Frontend Setup**
   ```bash
   flutter pub get
   cp .env.example .env  # Configure your environment variables
   ```

3. **Backend Setup**
   ```bash
   cd backend
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install -r requirements.txt
   ```

## 🚦 Running the Application

1. **Start the Backend**
   ```bash
   cd backend
   uvicorn app.main:app --reload --port 8000
   ```

2. **Run the Flutter App**
   ```bash
   flutter run
   ```

## 🔐 Security Notes

- Never commit `.env` files
- Keep REDCap tokens secure
- Use environment-specific configurations
- Follow HIPAA compliance guidelines

## 📱 Features in Development

- [ ] Advanced offline synchronization
- [ ] Real-time form analytics
- [ ] Enhanced error recovery
- [ ] Multi-site support


## 📄 License

This project is proprietary and confidential. Unauthorized copying, modification, distribution, or use is strictly prohibited.