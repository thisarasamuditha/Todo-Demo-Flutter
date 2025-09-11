# Todo Demo App

A Flutter application for managing personal todos with Firebase authentication and a REST API backend.

## Features

- **User Authentication**: Sign in and register using email with Firebase Auth
- **Todo Management**: Create, read, update, and delete todos
- **Search and Filter**: Search todos by title and filter by completion status
- **Pagination**: Efficiently load todos with pagination support
- **Responsive UI**: Clean and intuitive user interface

## Prerequisites

- Flutter SDK (^3.8.1)
- Dart SDK (^3.8.1)
- Firebase project with Authentication enabled
- Android Studio or Xcode for mobile development

## Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/dinethsiriwardana/Todo-Demo-Flutter.git
   cd todo_demo
   ```

2. **Install dependencies**:

   ```bash
   flutter pub get
   ```

3. **Configure Firebase**:

   - Add your Firebase configuration files:
     - `android/app/google-services.json`
     - `ios/Runner/GoogleService-Info.plist`
   - Enable Email/Password authentication in Firebase Console

4. **Run the app**:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── screens/
│   ├── home_screen.dart      # Main screen after login
│   ├── sign_in_screen.dart   # Authentication screen
│   └── todo_screen.dart      # Todo list and management
├── widgets/
│   ├── todo_input.dart       # Input widget for new todos
│   └── todo_list.dart        # List widget for displaying todos
├── models/
│   ├── todo_model.dart       # Todo data model
│   ├── todo_response.dart    # API response model
│   └── user_model.dart       # User data model
├── services/
│   ├── auth_service.dart     # Authentication service
│   └── todo_service.dart     # Todo API service
├── utils/
│   └── app_theme.dart        # App theme configuration
├── auth.dart                 # Authentication gate
├── firebase_options.dart     # Firebase configuration
└── main.dart                 # App entry point
```

## API Documentation

The app communicates with a REST API hosted at:
`https://todo-test-app-bvamb3h2hrgsarer.eastus2-01.azurewebsites.net/`

All endpoints require a `user-id` header with the authenticated user's ID.

### Endpoints

- **GET /api/todos** - Retrieve todos with optional parameters:

  - `page`: Page number (default: 1)
  - `limit`: Items per page (default: 10)
  - `completed`: Filter by completion status (true/false)
  - `search`: Search term for title
  - `sortBy`: Sort field (e.g., createdAt)
  - `sortOrder`: Sort order (asc/desc)

- **GET /api/todos/:id** - Get a specific todo by ID

- **POST /api/todos** - Create a new todo

  ```json
  {
    "title": "Todo title",
    "completed": false
  }
  ```

- **PUT /api/todos/:id** - Update an existing todo

  ```json
  {
    "title": "Updated title",
    "completed": true
  }
  ```

- **DELETE /api/todos/:id** - Delete a todo by ID

### Sample Todo Object

```json
{
  "id": 1,
  "userId": "user1",
  "title": "Complete project proposal",
  "completed": true,
  "createdAt": "2025-04-15T10:00:00Z",
  "updatedAt": "2025-04-18T14:30:00Z"
}
```

## Dependencies

- `firebase_core`: Firebase core functionality
- `firebase_auth`: Firebase Authentication
- `http`: HTTP client for API calls
- `cupertino_icons`: iOS-style icons

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

Dineth Siriwardana - [GitHub](https://github.com/dinethsiriwardana)
