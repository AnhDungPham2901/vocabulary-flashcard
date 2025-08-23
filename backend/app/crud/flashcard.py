from sqlalchemy.orm import Session
from typing import List, Optional
from app.models.flashcard import Flashcard
from app.schemas.flashcard import FlashcardCreate, FlashcardUpdate


def get_flashcard(db: Session, flashcard_id: int) -> Optional[Flashcard]:
    return db.query(Flashcard).filter(Flashcard.id == flashcard_id).first()


def get_flashcards(db: Session, skip: int = 0, limit: int = 100) -> List[Flashcard]:
    return db.query(Flashcard).filter(Flashcard.is_active == True).offset(skip).limit(limit).all()


def create_flashcard(db: Session, flashcard: FlashcardCreate) -> Flashcard:
    db_flashcard = Flashcard(**flashcard.dict())
    db.add(db_flashcard)
    db.commit()
    db.refresh(db_flashcard)
    return db_flashcard


def update_flashcard(db: Session, flashcard_id: int, flashcard: FlashcardUpdate) -> Optional[Flashcard]:
    db_flashcard = get_flashcard(db, flashcard_id)
    if db_flashcard:
        update_data = flashcard.dict(exclude_unset=True)
        for field, value in update_data.items():
            setattr(db_flashcard, field, value)
        db.commit()
        db.refresh(db_flashcard)
    return db_flashcard


def delete_flashcard(db: Session, flashcard_id: int) -> bool:
    db_flashcard = get_flashcard(db, flashcard_id)
    if db_flashcard:
        db_flashcard.is_active = False
        db.commit()
        return True
    return False


def search_flashcards(db: Session, search_term: str) -> List[Flashcard]:
    return db.query(Flashcard).filter(
        Flashcard.word.ilike(f"%{search_term}%"),
        Flashcard.is_active == True
    ).all()