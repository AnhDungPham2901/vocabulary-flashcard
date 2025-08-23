# Vocabulary Flashcard Application

A full-stack vocabulary flashcard application with a FastAPI backend and SwiftUI iOS frontend.

## Project Structure

```
vocabulary-flashcard/
├── backend/                    # FastAPI Backend
│   ├── app/
│   │   ├── api/
│   │   │   └── flashcards.py   # API routes
│   │   ├── core/
│   │   │   ├── config.py       # Configuration
│   │   │   └── database.py     # Database connection
│   │   ├── crud/
│   │   │   └── flashcard.py    # Database operations
│   │   ├── models/
│   │   │   └── flashcard.py    # SQLAlchemy models
│   │   ├── schemas/
│   │   │   └── flashcard.py    # Pydantic schemas
│   │   └── main.py             # FastAPI application
│   ├── alembic/                # Database migrations
│   ├── docker-compose.yml      # Docker services
│   ├── Dockerfile              # Container definition
│   ├── requirements.txt        # Python dependencies
│   ├── .env.example           # Environment template
│   └── README.md              # Backend documentation
├── frontend-ios/               # SwiftUI iOS App
│   ├── README.md              # iOS app documentation
│   └── API-Documentation.md   # API integration guide
└── README.md                  # This file
```

## Components

### Backend (FastAPI)
- **Technology**: Python FastAPI with PostgreSQL
- **Features**: RESTful API, database migrations, CORS support
- **Location**: `./backend/`
- **Documentation**: [Backend README](./backend/README.md)

### Frontend (SwiftUI iOS)
- **Technology**: SwiftUI for iOS
- **Features**: Native iOS app for vocabulary management
- **Location**: `./frontend-ios/`
- **Documentation**: [iOS README](./frontend-ios/README.md)

## Quick Start

### Backend Setup
```bash
cd backend
cp .env.example .env
docker-compose up -d
```

The API will be available at `http://localhost:8000`

### Frontend Setup
1. Navigate to `frontend-ios/`
2. Open Xcode and create a new SwiftUI project
3. Follow the [API Documentation](./frontend-ios/API-Documentation.md) for integration
4. Update the API base URL to `http://localhost:8000`

## API Documentation

Once the backend is running:
- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

## Features

### Backend Features
- ✅ Create, read, update, delete flashcards
- ✅ Search functionality
- ✅ PostgreSQL database with SQLAlchemy
- ✅ Database migrations with Alembic
- ✅ CORS support for frontend integration
- ✅ Docker containerization
- ✅ Automatic API documentation

### Planned iOS Features
- 📱 Browse and manage flashcards
- 📱 Flashcard study mode
- 📱 Offline support with Core Data
- 📱 Dark mode support
- 📱 Search and filtering
- 📱 Accessibility features

## Architecture

```
┌─────────────────┐    HTTP/REST API    ┌──────────────────┐
│   SwiftUI iOS   │◄──────────────────►│  FastAPI Backend │
│    Frontend     │                     │                  │
└─────────────────┘                     └──────────────────┘
        │                                          │
        │                                          │
   ┌─────────┐                              ┌─────────────┐
   │ Core    │                              │ PostgreSQL  │
   │ Data    │                              │ Database    │
   └─────────┘                              └─────────────┘
 (Local Storage)                          (Server Storage)
```

## Development Workflow

1. **Backend Development**:
   - Start with `cd backend && docker-compose up -d`
   - API available at `http://localhost:8000`
   - Database migrations: `alembic upgrade head`

2. **iOS Development**:
   - Use Xcode for SwiftUI development
   - Connect to local backend API
   - Implement offline support with Core Data

3. **Integration**:
   - Backend provides RESTful API
   - iOS app consumes API endpoints
   - CORS configured for cross-origin requests

## Next Steps

1. **Backend**: The API is ready for use
2. **iOS App**: Create Xcode project and implement SwiftUI views
3. **Integration**: Connect iOS app to backend API
4. **Deployment**: Deploy backend to cloud platform
5. **App Store**: Prepare iOS app for App Store submission

## Contributing

1. Backend development in `./backend/`
2. iOS development in `./frontend-ios/`
3. Follow the respective README files for setup instructions

## License

This project is licensed under the MIT License.