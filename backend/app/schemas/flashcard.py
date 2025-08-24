from pydantic import BaseModel, Field
from datetime import datetime, date
from typing import Optional


class FlashcardBase(BaseModel):
    word: str
    definition: str
    example_sentence: str


class FlashcardCreate(FlashcardBase):
    box: int = Field(default=1, description="Always starts at box 1")
    next_review_date: Optional[date] = None


class FlashcardUpdate(BaseModel):
    word: Optional[str] = None
    definition: Optional[str] = None
    example_sentence: Optional[str] = None
    box: Optional[int] = None
    next_review_date: Optional[date] = None


class FlashcardResponse(FlashcardBase):
    id: int
    box: int
    next_review_date: Optional[date] = None
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True