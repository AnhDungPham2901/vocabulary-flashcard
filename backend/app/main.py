from fastapi import FastAPI
from sqlalchemy import text
from fastapi.middleware.cors import CORSMiddleware
from app.api.flashcards import router as flashcards_router
from contextlib import asynccontextmanager
import logging

logger = logging.getLogger(__name__)

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    logger.info("Application startup - database tables will be created on first connection")
    yield
    # Shutdown
    logger.info("Application shutdown")

app = FastAPI(
    title="Vocabulary Flashcard API",
    description="A FastAPI application for managing vocabulary flashcards",
    version="1.0.0",
    lifespan=lifespan
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
    try:
        from app.core.database import SessionLocal
        db = SessionLocal()
        db.execute(text("SELECT 1"))
        db.close()
        return {"status": "healthy", "database": "connected"}
    except Exception as e:
        return {"status": "unhealthy", "database": "disconnected", "error": str(e)}