from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api.flashcards import router as flashcards_router
from app.core.database import engine, Base

Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Vocabulary Flashcard API",
    description="A FastAPI application for managing vocabulary flashcards",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure this for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(
    flashcards_router,
    prefix="/flashcards",
    tags=["flashcards"]
)


@app.get("/")
def root():
    return {"message": "Welcome to Vocabulary Flashcard API"}


@app.get("/health")
def health_check():
    return {"status": "healthy"}