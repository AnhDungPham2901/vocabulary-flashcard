FROM python:3.11.7-slim

WORKDIR /app

# Create virtual environment
RUN python3 -m venv venv

# Activate virtual environment
ENV PATH="/app/venv/bin:$PATH"

# Copy requirements and install dependencies
COPY requirements.txt .
RUN . venv/bin/activate && pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["/bin/bash", "-c", "source venv/bin/activate && uvicorn app.main:app --host 0.0.0.0 --port 8000"]