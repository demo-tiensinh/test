# Todo App

A modern React application for managing todo tasks, built with Vite and Material-UI.

## Features

- User authentication with JWT
- Create, read, update, and delete tasks
- Mark tasks as completed
- Responsive design with Material-UI
- Protected routes for authenticated users

## Tech Stack

- **Frontend Framework**: React.js with Vite
- **UI Library**: Material-UI
- **Routing**: React Router
- **HTTP Client**: Axios
- **State Management**: React Context API
- **Date Formatting**: date-fns

## API Integration

This application integrates with a RESTful Todo API that includes:

- Authentication endpoints
- Task management endpoints
- JWT-based security

## Project Structure

```
src/
├── components/
│   ├── auth/        - Authentication components
│   ├── common/      - Shared components
│   ├── home/        - Home page components
│   ├── layout/      - Layout components
│   └── tasks/       - Task management components
├── contexts/
│   ├── AuthContext  - Authentication state management
│   └── TaskContext  - Task state management
├── services/
│   ├── api.js       - API configuration
│   ├── authService  - Authentication service
│   └── taskService  - Task service
├── App.jsx          - Main application component
└── main.jsx         - Application entry point
```

## Getting Started

### Prerequisites

- Node.js (v14 or later)
- npm or yarn

### Installation

1. Clone the repository
2. Install dependencies:
   ```
   npm install
   ```
3. Start the development server:
   ```
   npm run dev
   ```

## Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run preview` - Preview production build locally

## Environment Variables

Create a `.env` file in the root directory with the following variables:

```
VITE_API_URL=https://api.example.com/v1
```

## License

MIT

