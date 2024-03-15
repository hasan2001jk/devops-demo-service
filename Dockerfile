# Use Python 3.11 base image
FROM python:3.11

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt update && apt install -y pipx

# Install poetry using pipx
RUN pipx install poetry

# Set PATH environment variable to include pipx-installed executables
ENV PATH="/root/.local/bin:$PATH"

# Copy the entire project into the container
COPY . /app

# Install dependencies using Poetry
RUN poetry install

# Set environment variables
ENV SERVICE_DEBUG=False
ENV SERVICE_DB_PATH=/data
ENV SERVICE_HOST="0.0.0.0"
ENV SERVICE_PORT=8000

WORKDIR /app/devops_demo

RUN poetry run python manage.py makemigrations

# Run migrations and start the Django development server
CMD poetry run python manage.py migrate && poetry run python manage.py runserver $SERVICE_HOST:$SERVICE_PORT
