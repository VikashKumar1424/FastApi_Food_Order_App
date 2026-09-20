# Food Order App

A modular food ordering backend built with **FastAPI**, following a layered architecture for clean separation of concerns, maintainability, and scalability.

## Architecture

```text
┌─────────────────────────────────────────────────────────────┐
│                         FastAPI App                         │
│                            main.py                           │
│  Application startup, middleware, dependency registration    │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                           API Layer                          │
│                    Routes and HTTP Endpoints                 │
│                    menu.py │ orders.py                       │
│  Request validation, response handling, and status codes     │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                        Service Layer                         │
│                     Business Logic                           │
│              menu_service.py │ order_service.py              │
│  Business rules, workflows, and application-level operations │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                      Repository Layer                        │
│                    Data Access Logic                         │
│           menu_repository.py │ order_repository.py           │
│  Database queries and persistence operations                 │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                         Model Layer                          │
│                    Database Entities                         │
│                           food.py                            │
│  ORM models and database table definitions                   │
└─────────────────────────────────────────────────────────────┘

┌──────────────────────────────┐       ┌──────────────────────────────┐
│          Schemas             │       │             Core               │
│ Pydantic request/response    │       │ Configuration, exceptions,    │
│ models and validation        │       │ security, and shared utilities│
└──────────────────────────────┘       └──────────────────────────────┘
```

## Project Structure

```text
Food_Order_App/
├── app/
│   ├── main.py                    # FastAPI application entry point
│   ├── api/
│   │   └── routes/
│   │       ├── menu.py            # Menu endpoints
│   │       └── orders.py          # Order endpoints
│   ├── services/
│   │   ├── menu_service.py        # Menu business logic
│   │   └── order_service.py       # Order business logic
│   ├── repositories/
│   │   ├── menu_repository.py     # Menu data access
│   │   └── order_repository.py    # Order data access
│   ├── models/
│   │   └── food.py                # Database entities
│   ├── schemas/                   # Pydantic request/response schemas
│   └── core/                      # Configuration and shared utilities
├── tests/                         # Automated tests
├── .env.example                   # Environment variable template
├── requirements.txt               # Python dependencies
└── README.md
```

> The directory names above describe the recommended application structure. Adjust them to match the implementation as the project grows.

## Features

- FastAPI-based REST API
- Automatic request validation with Pydantic
- Interactive API documentation with Swagger UI and ReDoc
- Layered architecture with separate API, service, repository, model, and schema layers
- Centralized configuration and exception handling
- Testable business and data-access logic

## Requirements

- Python 3.10 or later
- `pip`
- A configured database, if required by the application

## Installation

1. Clone the repository:

   ```bash
   git clone <path>
   cd FastApi_Food_Order_App

   ```

2. Create and activate a virtual environment:

   ```bash
   python -m venv .venv
   ```

   **macOS/Linux:**

   ```bash
   source .venv/bin/activate
   ```

   **Windows:**

   ```powershell
   .venv\Scripts\Activate.ps1
   ```

3. Install dependencies:

   ```bash
   pip install -r requirements.txt
   ```

4. Configure environment variables using `.env.example`, if provided.

## Running the Application

Start the FastAPI development server with Uvicorn:

```bash
uvicorn app.main:app --reload
```

If `main.py` is located at the project root, use:

```bash
uvicorn main:app --reload
```

The API will be available at:

- API: http://127.0.0.1:8000
- Swagger UI: http://127.0.0.1:8000/docs
- ReDoc: http://127.0.0.1:8000/redoc

## API Design

The API is organized around the following resources:

| Resource | Responsibility |
| --- | --- |
| Menu | Create, read, update, and delete food items |
| Orders | Create and manage customer orders |

Routes should validate incoming data through schemas, delegate business operations to services, and use repositories for database access.

## Development Guidelines

- Keep HTTP-specific logic in the API layer.
- Keep business rules in the service layer.
- Keep database queries in repositories.
- Use Pydantic schemas for request and response validation.
- Keep database entities in the models layer.
- Store secrets and environment-specific values outside the source code.
- Add tests for new endpoints and business rules.

## Testing

Run the test suite with:

```bash
pytest
```

## License

Add the project license information here.
