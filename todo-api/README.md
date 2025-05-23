# Task Management API

A Ruby on Rails API for managing daily tasks and tracking completed tasks.

## Features

- RESTful API for task management
- Authentication with JWT
- Filtering and sorting tasks
- Comprehensive test suite
- API documentation with Swagger UI
- Docker and docker-compose setup

## Requirements

- Ruby 3.2.2
- Rails 7.1.0
- PostgreSQL 14
- Redis 7

## Getting Started

### Using Docker (Recommended)

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/task-management-api.git
   cd task-management-api
   ```

2. Start the application using Docker Compose:
   ```bash
   docker-compose up
   ```

3. Initialize the database:
   ```bash
   docker-compose exec web rails db:create db:migrate db:seed
   ```

4. The API will be available at http://localhost:3000

### Manual Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/task-management-api.git
   cd task-management-api
   ```

2. Install dependencies:
   ```bash
   bundle install
   ```

3. Configure the database in `config/database.yml`

4. Initialize the database:
   ```bash
   rails db:create db:migrate db:seed
   ```

5. Start the server:
   ```bash
   rails server
   ```

6. The API will be available at http://localhost:3000

## API Documentation

The API documentation is available at http://localhost:3000/api-docs when the server is running.

## API Endpoints

### Authentication

- `POST /api/v1/auth/login` - Authenticate user and get access token

### Tasks

- `GET /api/v1/tasks` - List all tasks
  - Query parameters:
    - `status` - Filter by status ('to_do', 'in_progress', 'done')
    - `sort` - Sort by due date ('due_date_asc', 'due_date_desc')
- `GET /api/v1/tasks/:id` - Get a specific task
- `POST /api/v1/tasks` - Create a new task (requires authentication)
- `PUT /api/v1/tasks/:id` - Update a task (requires authentication)
- `DELETE /api/v1/tasks/:id` - Delete a task (requires authentication)

## Running Tests

### Using Docker

```bash
docker-compose run test
```

### Manual

```bash
bundle exec rspec
```

## Generating Swagger Documentation

```bash
rails rswag:specs:swaggerize
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

