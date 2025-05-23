# NuxtJS TODO Application

A professional-grade NuxtJS front-end application for managing tasks, built based on a Swagger API specification.

## Features

- View, create, edit, and delete tasks
- Filter tasks by status
- Sort tasks by due date or priority
- Responsive design with Tailwind CSS
- State management with Pinia
- Docker support for easy deployment

## Tech Stack

- [Nuxt 3](https://nuxt.com/) - Vue.js framework
- [Tailwind CSS](https://tailwindcss.com/) - Utility-first CSS framework
- [Pinia](https://pinia.vuejs.org/) - State management
- [Axios](https://axios-http.com/) - HTTP client
- [Docker](https://www.docker.com/) - Containerization

## Getting Started

### Prerequisites

- Node.js (v16 or later)
- npm or yarn
- Docker and Docker Compose (optional, for containerized setup)

### Installation

1. Clone the repository:

```bash
git clone <repository-url>
cd nuxt-todo-app
```

2. Install dependencies:

```bash
npm install
# or
yarn install
```

3. Start the development server:

```bash
npm run dev
# or
yarn dev
```

The application will be available at http://localhost:3000.

## Docker Setup

To run the application using Docker:

1. Build and start the containers:

```bash
docker-compose up -d
```

2. Access the application at http://localhost:3000

## Project Structure

```
├── components/         # Reusable Vue components
├── composables/        # Composable functions
├── layouts/            # Page layouts
├── pages/              # Application pages
├── public/             # Static assets
├── stores/             # Pinia stores
├── mock-api/           # Mock API for development
├── Dockerfile          # Docker configuration
├── docker-compose.yml  # Docker Compose configuration
├── nuxt.config.ts      # Nuxt configuration
└── tailwind.config.js  # Tailwind CSS configuration
```

## API Integration

The application integrates with a TODO API with the following endpoints:

- `GET /tasks` - Get all tasks with optional filtering and sorting
- `POST /tasks` - Create a new task
- `GET /tasks/{id}` - Get a task by ID
- `PATCH /tasks/{id}` - Update a task
- `DELETE /tasks/{id}` - Delete a task

## Environment Variables

- `API_BASE_URL` - Base URL for the API (default: http://localhost:3000)

## Development

### Mock API

For development purposes, a mock API is included using json-server. To run it:

```bash
cd mock-api
npm install -g json-server
json-server --watch db.json --port 3001
```

Then set the `API_BASE_URL` environment variable to `http://localhost:3001`.

## Building for Production

```bash
npm run build
# or
yarn build
```

## License

[MIT](LICENSE)

