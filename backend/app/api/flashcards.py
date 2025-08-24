from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List
from app.core.database import get_db
from app.schemas.flashcard import FlashcardCreate, FlashcardUpdate, FlashcardResponse
from app.crud import flashcard as crud

router = APIRouter()


@router.post("/", response_model=FlashcardResponse)
def create_flashcard(
    flashcard: FlashcardCreate,
    db: Session = Depends(get_db)
):
    # Validation: ensure box is always 1 at creation
    if flashcard.box != 1:
        raise HTTPException(status_code=400, detail="New flashcards must start in box 1")
    
    return crud.create_flashcard(db=db, flashcard=flashcard)


@router.get("/", response_model=List[FlashcardResponse])
def read_flashcards(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db)
):
    return crud.get_flashcards(db, skip=skip, limit=limit)


@router.get("/{flashcard_id}", response_model=FlashcardResponse)
def read_flashcard(
    flashcard_id: int,
    db: Session = Depends(get_db)
):
    db_flashcard = crud.get_flashcard(db, flashcard_id=flashcard_id)
    if db_flashcard is None:
        raise HTTPException(status_code=404, detail="Flashcard not found")
    return db_flashcard


@router.get("/{flashcard_id}/edit", response_model=FlashcardResponse)
def get_flashcard_for_edit(
    flashcard_id: int,
    db: Session = Depends(get_db)
):
    """Get flashcard data for editing - use this to populate the update form"""
    db_flashcard = crud.get_flashcard(db, flashcard_id=flashcard_id)
    if db_flashcard is None:
        raise HTTPException(status_code=404, detail="Flashcard not found")
    return db_flashcard


@router.put("/{flashcard_id}", response_model=FlashcardResponse)
def update_flashcard(
    flashcard_id: int,
    flashcard: FlashcardUpdate,
    db: Session = Depends(get_db)
):
    # Load existing flashcard to verify it exists
    existing_flashcard = crud.get_flashcard(db, flashcard_id=flashcard_id)
    if existing_flashcard is None:
        raise HTTPException(status_code=404, detail="Flashcard not found")
    
    db_flashcard = crud.update_flashcard(db, flashcard_id=flashcard_id, flashcard=flashcard)
    return db_flashcard


@router.delete("/{flashcard_id}")
def delete_flashcard(
    flashcard_id: int,
    db: Session = Depends(get_db)
):
    success = crud.delete_flashcard(db, flashcard_id=flashcard_id)
    if not success:
        raise HTTPException(status_code=404, detail="Flashcard not found")
    return {"message": "Flashcard deleted successfully"}


@router.get("/search/", response_model=List[FlashcardResponse])
def search_flashcards(
    q: str = Query(..., description="Search term"),
    db: Session = Depends(get_db)
):
    return crud.search_flashcards(db, search_term=q)