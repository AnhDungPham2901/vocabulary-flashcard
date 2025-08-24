from sqlalchemy import Column, Integer, DateTime, Boolean, ForeignKey
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from app.core.database import Base


class ReviewHistory(Base):
    __tablename__ = "review_history"

    id = Column(Integer, primary_key=True, index=True)
    flashcard_id = Column(Integer, ForeignKey("flashcards.id"), nullable=False)
    was_correct = Column(Boolean, nullable=False)
    previous_box = Column(Integer, nullable=False) # previous location e.g., 1, 2, 7, 14, 30, 60
    new_box = Column(Integer, nullable=False) # new location e.g., 1, 2, 7, 14, 30, 60
    reviewed_at = Column(DateTime(timezone=True), server_default=func.now())
    
    # Relationship
    flashcard = relationship("Flashcard", back_populates="review_history")
