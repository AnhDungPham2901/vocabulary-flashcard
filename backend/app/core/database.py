from sqlalchemy import create_engine, text
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from .config import settings
import logging

logger = logging.getLogger(__name__)

engine = create_engine(settings.database_url)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

def create_tables():
    """Create database tables - called lazily when needed"""
    try:
        Base.metadata.create_all(bind=engine)
        logger.info("Database tables created successfully")
    except Exception as e:
        logger.error(f"Failed to create database tables: {e}")
        raise

def get_db():
    # Try to create tables on first database access
    try:
        db = SessionLocal()
        # Test the connection
        db.execute(text("SELECT 1"))
        yield db
    except Exception as e:
        logger.error(f"Database connection failed: {e}")
        # Try to create tables if connection fails due to missing tables
        try:
            create_tables()
            db = SessionLocal()
            yield db
        except Exception as create_error:
            logger.error(f"Failed to create tables and connect: {create_error}")
            raise
    finally:
        if 'db' in locals():
            db.close()