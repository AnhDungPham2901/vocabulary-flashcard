from sqlalchemy import Column, Integer, String, Text, DateTime, Date
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from app.core.database import Base


class Flashcard(Base):
    __tablename__ = "flashcards"

    id = Column(Integer, primary_key=True, index=True)
    word = Column(String(255), nullable=False, index=True)
    definition = Column(Text, nullable=False)
    example_sentence = Column(Text, nullable=True)
    box = Column(Integer, default=1)  # 1, 2, 7, 14, 30, 60 (days for spaced repetition)
    next_review_date = Column(Date, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationship
    review_history = relationship("ReviewHistory", back_populates="flashcard")