from pydantic import BaseModel
from datetime import datetime
from typing import Optional


class FlashcardBase(BaseModel):
    word: str
    definition: str
    pronunciation: Optional[str] = None
    example_sentence: Optional[str] = None
    difficulty_level: int = 1
    is_active: bool = True


class FlashcardCreate(FlashcardBase):
    pass


class FlashcardUpdate(BaseModel):
    word: Optional[str] = None
    definition: Optional[str] = None
    pronunciation: Optional[str] = None
    example_sentence: Optional[str] = None
    difficulty_level: Optional[int] = None
    is_active: Optional[bool] = None


class FlashcardResponse(FlashcardBase):
    id: int
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True