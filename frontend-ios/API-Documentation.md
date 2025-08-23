# API Documentation for iOS Integration

## Base URL
- Development: `http://localhost:8000`
- Production: `https://your-api-domain.com`

## Authentication
Currently, no authentication is required. Future versions may include JWT tokens.

## Data Models

### Flashcard Model
```json
{
  "id": 1,
  "word": "serendipity",
  "definition": "The occurrence and development of events by chance in a happy or beneficial way",
  "pronunciation": "/ˌsɛrənˈdɪpɪti/",
  "example_sentence": "A fortunate stroke of serendipity brought the two old friends together.",
  "difficulty_level": 2,
  "is_active": true,
  "created_at": "2023-12-01T10:00:00Z",
  "updated_at": "2023-12-01T10:00:00Z"
}
```

### Difficulty Levels
- `1`: Easy
- `2`: Medium  
- `3`: Hard

## API Endpoints

### 1. Get All Flashcards
```
GET /flashcards/
```

**Query Parameters:**
- `skip` (optional): Number of records to skip (default: 0)
- `limit` (optional): Maximum number of records to return (default: 100)

**Response:** Array of Flashcard objects

### 2. Get Specific Flashcard
```
GET /flashcards/{id}
```

**Path Parameters:**
- `id`: Flashcard ID (integer)

**Response:** Single Flashcard object

### 3. Create New Flashcard
```
POST /flashcards/
```

**Request Body:**
```json
{
  "word": "string",
  "definition": "string",
  "pronunciation": "string (optional)",
  "example_sentence": "string (optional)",
  "difficulty_level": 1,
  "is_active": true
}
```

**Response:** Created Flashcard object

### 4. Update Flashcard
```
PUT /flashcards/{id}
```

**Path Parameters:**
- `id`: Flashcard ID (integer)

**Request Body:** Partial Flashcard object (only include fields to update)

**Response:** Updated Flashcard object

### 5. Delete Flashcard
```
DELETE /flashcards/{id}
```

**Path Parameters:**
- `id`: Flashcard ID (integer)

**Response:** 
```json
{
  "message": "Flashcard deleted successfully"
}
```

### 6. Search Flashcards
```
GET /flashcards/search/?q={search_term}
```

**Query Parameters:**
- `q`: Search term (required)

**Response:** Array of matching Flashcard objects

### 7. Health Check
```
GET /health
```

**Response:**
```json
{
  "status": "healthy"
}
```

## Error Responses

### 404 Not Found
```json
{
  "detail": "Flashcard not found"
}
```

### 422 Validation Error
```json
{
  "detail": [
    {
      "loc": ["body", "field_name"],
      "msg": "field required",
      "type": "value_error.missing"
    }
  ]
}
```

## Swift Integration Examples

### URLSession Request Example
```swift
func fetchFlashcards() async throws -> [Flashcard] {
    let url = URL(string: "\(baseURL)/flashcards/")!
    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode([Flashcard].self, from: data)
}
```

### Create Flashcard Example
```swift
func createFlashcard(_ flashcard: CreateFlashcardRequest) async throws -> Flashcard {
    let url = URL(string: "\(baseURL)/flashcards/")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try JSONEncoder().encode(flashcard)
    
    let (data, _) = try await URLSession.shared.data(for: request)
    return try JSONDecoder().decode(Flashcard.self, from: data)
}