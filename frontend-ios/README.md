# Vocabulary Flashcard iOS App

A SwiftUI-based iOS application for the Vocabulary Flashcard system.

## Overview

This iOS app connects to the FastAPI backend to provide a native mobile experience for managing vocabulary flashcards.

## Features (Planned)

- Browse vocabulary flashcards
- Create new flashcards
- Edit existing flashcards
- Search functionality
- Flashcard study mode
- Offline support with Core Data
- Dark mode support
- Accessibility features

## API Integration

The app communicates with the backend API running on `http://localhost:8000` (development) or your deployed backend URL.

### API Endpoints Used

- `GET /flashcards/` - Fetch all flashcards
- `POST /flashcards/` - Create new flashcard
- `GET /flashcards/{id}` - Get specific flashcard
- `PUT /flashcards/{id}` - Update flashcard
- `DELETE /flashcards/{id}` - Delete flashcard
- `GET /flashcards/search/?q={term}` - Search flashcards

## Development Setup

1. Open Xcode
2. Create a new iOS project with SwiftUI
3. Add network layer for API communication
4. Implement Core Data for offline storage
5. Build UI components

## Project Structure (Recommended)

```
VocabularyFlashcard/
├── App/
│   ├── VocabularyFlashcardApp.swift
│   └── ContentView.swift
├── Models/
│   ├── Flashcard.swift
│   ├── APIModels.swift
│   └── CoreDataModels.xcdatamodeld
├── Views/
│   ├── FlashcardListView.swift
│   ├── FlashcardDetailView.swift
│   ├── AddFlashcardView.swift
│   └── StudyModeView.swift
├── Services/
│   ├── APIService.swift
│   ├── CoreDataManager.swift
│   └── NetworkManager.swift
├── ViewModels/
│   ├── FlashcardViewModel.swift
│   └── StudyViewModel.swift
└── Utils/
    ├── Extensions/
    └── Constants.swift
```

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

## Getting Started

1. Ensure the backend API is running
2. Update the API base URL in the app configuration
3. Build and run the project in Xcode