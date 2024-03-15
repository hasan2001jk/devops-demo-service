# DevOps Demo Service

This is a Django application for the DevOps Demo Service.

## Requirements

- Docker
- Docker Compose

## Setup

1. Clone this repository:

   ```bash
   git clone https://github.com/yourusername/devops-demo-service.git
   cd devops-demo-service

2. Build and start the Docker containers:
   ```bash   
   docker-compose up --build

3.Once the containers are up and running, you can access the application at http://localhost:8000.
4.To stop the containers, press Ctrl + C, and then run:
  ```bash
  docker-compose down

## Usage
### Creating a Superuser
A superuser is required to access the admin panel. You can create a superuser using the following command:
  ```bash
  docker-compose exec webapp bash -c "poetry run python manage.py createsuperuser --noinput --username <your_username> --email <your_email>"

### Accessing the Admin Panel
1.Navigate to http://localhost:8000/admin in your web browser.
2.Log in with the username and password of the superuser you created

## Formalized Explanation of `docker-compose.yml` Configuration:

**Services**:

  - **webapp**:
      - **Purpose**: This service is responsible for running your web application.
      - **Build**: Builds the application image based on the Dockerfile located within the current directory (.).
      - **Dependencies**: Relies on the database service for database connectivity.
      - **Ports**: Exposes the web application's development server on port 8000 of the host machine. This allows you to access the application through http://localhost:8000 in your browser.
      - **Environment Variables**: Sets environment variables used within the application, such as SERVICE_DEBUG (for debugging), SERVICE_DB_PATH (database connection information), SERVICE_HOST (IP address the application listens on), and SERVICE_PORT (port number used by the application).

  - **database**:
        - **Purpose**: This service provides a PostgreSQL database instance.
        - **Image**: Utilizes the official postgres:latest image from Docker Hub.
        - **Restart**: Configured to automatically restart in case of failure.
        - **Ports**: Maps the container's port 5432 (default for PostgreSQL) to the host's port 5432. This grants access to the database from the webapp service or other containers.
        - **Environment Variables**: Defines database credentials (POSTGRES_PASSWORD, POSTGRES_USER, and POSTGRES_DB) for secure access.
        - **Volumes**: Utilizes a named volume named pgdata to persist database data, ensuring data is preserved even if the container is recreated.

    - **nginx**:
        - **Purpose**: This service incorporates an NGINX web server as a reverse proxy for the web application (if used).
        - **Image**: Employs the official nginx:latest image.
        - **Ports**: Maps container port 80 (default for HTTP) to the host's port 80, acting as the primary entry point for web traffic.
        - **Dependencies**: Relies on the webapp service to be running first.
        - **Volumes**: Mounts the custom Nginx configuration file (nginx.conf) from the host machine to the container's /etc/nginx/nginx.conf location, enabling configuration customization.

- **Volumes**:

    - **pgdata**: This named volume is specifically created to store and persist PostgreSQL database data. This ensures that data is not lost even if the container is recreated or stopped.
