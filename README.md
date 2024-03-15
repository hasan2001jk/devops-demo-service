# Демо-сервис DevOps
Это **Django**-приложение для сервиса DevOps Demo Service.

## Требования
    
- Docker
- Docker Compose

## Установка

1. Склонируйте этот репозиторий:
   ```
   git clone https://github.com/yourusername/devops-demo-service.git
   cd devops-demo-service
   ```
2. Соберите и запустите контейнеры Docker:
   ```
   docker-compose up --build
   ```
   
 3. После запуска контейнеров вы можете получить доступ к приложению по адресу **http://localhost:8000**.
 4. Чтобы остановить контейнеры, нажмите **Ctrl + C**, а затем выполните команду:
   ```
   docker-compose down
   ```
# Применение
## Создание суперпользователя
Для доступа к панели администратора требуется суперпользователь. Суперпользователя можно создать с помощью следующей команды:
```
docker-compose exec webapp bash -c "poetry run python manage.py createsuperuser --noinput --username <your_username> --email <your_email>"
```

### Доступ к панели администратора

1. Перейдите на сайт **http://localhost:8000/admin** в веб-браузере.
2. Войдите в систему, используя имя пользователя и пароль созданного вами суперпользователя


## Уточненное объяснение конфигурации **docker-compose.yml**:

- **Services**:

    - **webapp**:
        - **Цель**: Эта служба отвечает за запуск вашего веб-приложения.
        - **Build**: Собирает образ приложения на основе **Dockerfile**, расположенного в текущей директории (.).
        - **Зависимости**: Предполагает подключение службы базы данных к базе данных.
        - **Порты**:  Выделяет контейнеру веб-приложения доступ к порту 8000 хост-машины. Это позволит вам получить доступ к приложению через http://localhost:8000 в вашем браузере.
        - **Переменные среды**: Устанавливает переменные окружения, используемые в приложении, такие как **SERVICE_DEBUG** (для отладки), **SERVICE_DB_PATH** (информация о подключении к базе данных), **SERVICE_HOST** (IP-адрес, который прослушивает приложение) и **SERVICE_PORT** (номер порта, используемого приложением).

   - **database**:
     - **Цель**: Эта служба предоставляет экземпляр базы данных **PostgreSQL**.
     - **Image**: Используется официальный образ **postgres:latest** из **Docker Hub**.
     - **Restart**: Настроен на автоматический перезапуск в случае сбоя.
     - **Порты**: Сопоставляет порт **5432** контейнера (по умолчанию для **PostgreSQL**) с портом **5432** хоста. Это обеспечивает доступ к базе данных из службы **webapp** или других контейнеров.
     - **Переменные окружения**: Позволяют определить учетные данные базы данных (**POSTGRES_PASSWORD**, **POSTGRES_USER** и **POSTGRES_DB**) для безопасного доступа.
     - **Volume**: Использует именованный том с именем **pgdata** для сохранения данных базы данных, обеспечивая их сохранность даже при повторном создании контейнера.

   - **nginx**:
   
       - **Цель**: Эта служба включает веб-сервер **NGINX** в качестве обратного прокси для веб-приложения.
       - **Image**: Используется официальный образ **nginx:latest**.
       - **Порты**: Сопоставляет порт 80 контейнера (по умолчанию для **HTTP**) с портом 80 хоста, выступая в качестве основной точки входа для веб-трафика.
       - **Зависимости**: Полагается на то, что служба **webapp** будет запущена первой.
       - **Volumes**: Монтирует пользовательский файл конфигурации **Nginx** (nginx.conf) с хост-машины в местоположение **/etc/nginx/nginx.conf** контейнера, позволяя настраивать конфигурацию.

   - **Volumes**:

       - **pgdata**: Этот именованный том специально создан для хранения и сохранения информации из базы данных **PostgreSQL**. Это гарантирует, что данные не будут потеряны, даже если контейнер будет повторно создан или остановлен.








---

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

3. Once the containers are up and running, you can access the application at http://localhost:8000.
4. To stop the containers, press Ctrl + C, and then run:
  ```
  docker-compose down
   ```

# Usage

## Creating a Superuser

A superuser is required to access the admin panel. You can create a superuser using the following command:
  ```
  docker-compose exec webapp bash -c "poetry run python manage.py createsuperuser --noinput --username <your_username> --email <your_email>"
  ```
### Accessing the Admin Panel
1. Navigate to http://localhost:8000/admin in your web browser.
2. Log in with the username and password of the superuser you created

## Formalized Explanation of `docker-compose.yml` Configuration:

**Services**:

  - **webapp**:
      - **Purpose**: This service is responsible for running your web application.
      - **Build**: Builds the application image based on the **Dockerfile** located within the current directory (.).
      - **Dependencies**: Relies on the database service for database connectivity.
      - **Ports**: Exposes the web application's development server on port 8000 of the host machine. This allows you to access the application through http://localhost:8000 in your browser.
      - **Environment Variables**: Sets environment variables used within the application, such as **SERVICE_DEBUG** (for debugging), **SERVICE_DB_PATH** (database connection information), **SERVICE_HOST** (IP address the application listens on), and **SERVICE_PORT** (port number used by the application).

   - **database**:
        - **Purpose**: This service provides a **PostgreSQL** database instance.
        - **Image**: Utilizes the official postgres:latest image from Docker Hub.
        - **Restart**: Configured to automatically restart in case of failure.
        - **Ports**: Maps the container's port **5432** (default for **PostgreSQL**) to the host's port 5432. This grants access to the database from the webapp service or other containers.
        - **Environment Variables**: Defines database credentials (**POSTGRES_PASSWORD**, **POSTGRES_USER**, and **POSTGRES_DB**) for secure access.
        - **Volumes**: Utilizes a named volume named pgdata to persist database data, ensuring data is preserved even if the container is recreated.

   - **nginx**:
        - **Purpose**: This service incorporates an NGINX web server as a reverse proxy for the web application (if used).
        - **Image**: Employs the official nginx:latest image.
        - **Ports**: Maps container port 80 (default for HTTP) to the host's port 80, acting as the primary entry point for web traffic.
        - **Dependencies**: Relies on the webapp service to be running first.
        - **Volumes**: Mounts the custom **Nginx** configuration file (nginx.conf) from the host machine to the container's **/etc/nginx/nginx.conf** location, enabling configuration customization.

- **Volumes**:

    - **pgdata**: This named volume is specifically created to store and persist PostgreSQL database data. This ensures that data is not lost even if the container is recreated or stopped.
