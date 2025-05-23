# TODO Application API

A production-ready Ruby on Rails API for a responsive and user-friendly TODO application.

## Features

- RESTful API for managing tasks
- Filtering, sorting, and pagination
- Comprehensive test suite with RSpec
- API documentation with Swagger UI
- Docker and docker-compose setup for easy deployment
- Database migrations and seed data

## Requirements

- Ruby 3.2.2
- Rails 7.1.0
- PostgreSQL 14+
- Redis 7+

## Getting Started

### Using Docker (Recommended)

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/todo-api.git
   cd todo-api
   ```

2. Build and start the containers:
   ```bash
   docker-compose up --build
   ```

3. Set up the database:
   ```bash
   docker-compose exec web rails db:create db:migrate db:seed
   ```

4. Access the API at http://localhost:3000
   - API documentation is available at http://localhost:3000/api-docs

### Manual Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/todo-api.git
   cd todo-api
   ```

2. Install dependencies:
   ```bash
   bundle install
   ```

3. Configure the database in `config/database.yml`

4. Set up the database:
   ```bash
   rails db:create db:migrate db:seed
   ```

5. Start the server:
   ```bash
   rails server
   ```

6. Access the API at http://localhost:3000
   - API documentation is available at http://localhost:3000/api-docs

## API Endpoints

### Tasks

- `GET /api/v1/tasks` - List all tasks
  - Query parameters:
    - `status`: Filter by status (`incomplete` or `complete`)
    - `sortBy`: Sort by field (`dueDate` or `priority`)
    - `order`: Sort order (`asc` or `desc`)
    - `page`: Page number for pagination
    - `per_page`: Number of items per page

- `POST /api/v1/tasks` - Create a new task

- `GET /api/v1/tasks/:id` - Get a specific task

- `PATCH /api/v1/tasks/:id` - Update a task

- `DELETE /api/v1/tasks/:id` - Delete a task

## Running Tests

### Using Docker

```bash
docker-compose run --rm test
```

### Manual

```bash
bundle exec rspec
```

## Generating Swagger Documentation

```bash
rails rswag:specs:swaggerize
```

## Deployment

### Production Setup

1. Set environment variables:
   - `TODO_API_DATABASE_USERNAME`
   - `TODO_API_DATABASE_PASSWORD`
   - `TODO_API_DATABASE_HOST`
   - `TODO_API_DATABASE_PORT`
   - `RAILS_MASTER_KEY`

2. Precompile assets:
   ```bash
   rails assets:precompile
   ```

3. Run database migrations:
   ```bash
   rails db:migrate
   ```

4. Start the server:
   ```bash
   rails server -e production
   ```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

