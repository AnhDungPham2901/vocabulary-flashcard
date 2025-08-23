from sqlalchemy import Column, Integer, String, Text, DateTime, Boolean
from sqlalchemy.sql import func
from app.core.database import Base


class Flashcard(Base):
    __tablename__ = "flashcards"

    id = Column(Integer, primary_key=True, index=True)
    word = Column(String(255), nullable=False, index=True)
    definition = Column(Text, nullable=False)
    pronunciation = Column(String(255), nullable=True)
    example_sentence = Column(Text, nullable=True)
    difficulty_level = Column(Integer, default=1)  # 1=easy, 2=medium, 3=hard
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())