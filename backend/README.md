# Vocabulary Flashcard Backend API

A FastAPI backend service for the Vocabulary Flashcard application with PostgreSQL database.

## Features

- RESTful API for vocabulary flashcard management
- PostgreSQL database with SQLAlchemy ORM
- Database migrations with Alembic
- CORS support for frontend integration
- Docker containerization
- Automatic API documentation

## API Endpoints

### Health & Info
- `GET /` - Welcome message
- `GET /health` - Health check endpoint

### Flashcards
- `POST /flashcards/` - Create a new flashcard
- `GET /flashcards/` - List all flashcards (with pagination)
- `GET /flashcards/{id}` - Get a specific flashcard
- `PUT /flashcards/{id}` - Update a flashcard
- `DELETE /flashcards/{id}` - Delete a flashcard (soft delete)
- `GET /flashcards/search/?q={term}` - Search flashcards by word

## Project Structure

```
backend/
├── app/
│   ├── api/
│   │   └── flashcards.py       # API routes
│   ├── core/
│   │   ├── config.py           # Configuration
│   │   └── database.py         # Database setup
│   ├── crud/
│   │   └── flashcard.py        # Database operations
│   ├── models/
│   │   └── flashcard.py        # SQLAlchemy models
│   ├── schemas/
│   │   └── flashcard.py        # Pydantic schemas
│   └── main.py                 # FastAPI application
├── alembic/                    # Database migrations
├── docker-compose.yml          # Docker services
├── Dockerfile                  # Container definition
├── requirements.txt            # Python dependencies
└── .env.example               # Environment template
```

## Development Setup

### Using Docker (Recommended)

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Copy the environment file:
   ```bash
   cp .env.example .env
   ```

3. Start the services:
   ```bash
   docker-compose up -d
   ```

4. The API will be available at `http://localhost:8000`

### Manual Setup

1. Install PostgreSQL and create a database named `vocabulary_flashcard`

2. Create a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

4. Configure environment variables:
   ```bash
   cp .env.example .env
   # Edit .env with your database credentials
   ```

5. Run database migrations:
   ```bash
   alembic upgrade head
   ```

6. Start the application:
   ```bash
   uvicorn app.main:app --reload
   ```

## Database Management

### Create Migration
```bash
alembic revision --autogenerate -m "Description of changes"
```

### Apply Migrations
```bash
alembic upgrade head
```

### Rollback Migration
```bash
alembic downgrade -1
```

## API Documentation

Once running, access the interactive documentation:
- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

## Environment Variables

Create a `.env` file based on `.env.example`:

```env
DATABASE_URL=postgresql://username:password@localhost:5432/vocabulary_flashcard
POSTGRES_USER=username
POSTGRES_PASSWORD=password
POSTGRES_DB=vocabulary_flashcard
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
```

## Frontend Integration

The API includes CORS middleware configured to allow requests from any origin during development. For production, update the `allow_origins` list in `app/main.py` to include only your frontend domains.

Example frontend integration:
- **iOS (SwiftUI)**: See `../frontend-ios/` directory
- **Web**: Can be integrated with React, Vue, Angular, etc.

## Production Deployment

1. Update CORS origins in `app/main.py`
2. Use environment-specific database credentials
3. Set up proper logging
4. Use a production WSGI server like Gunicorn
5. Configure reverse proxy (nginx)
6. Set up SSL certificates

## Testing

Run tests with pytest:
```bash
pytest
```

## License

This project is licensed under the MIT License.