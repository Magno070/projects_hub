Project Architecture - Projects Hub

Overview

This project follows the principles of Clean Architecture combined with a feature-based architecture, ensuring clean, testable, and scalable code.

Architectural Principles

- Separation of Concerns: Each layer has a specific responsibility.
- Dependency Inversion: Dependencies point inwards (towards the Domain layer).
- Testability: Easy to test each component in isolation.
- Scalability: Easy to add new features without impacting existing ones.
- Maintainability: Organized and easy-to-maintain code.

Folder Structure

lib/
├── core/ # Shared components
│ ├── constants/ # Global constants
│ │ ├── app_constants.dart
│ │ ├── api_constants.dart
│ │ └── theme_constants.dart
│ ├── errors/ # Error handling
│ │ ├── exceptions.dart
│ │ ├── failures.dart
│ │ └── error_handler.dart
│ ├── network/ # Network configuration
│ │ ├── network_info.dart
│ │ └── api_client.dart
│ ├── usecases/ # Base use cases
│ │ └── usecase.dart
│ ├── utils/ # Utilities
│ │ ├── validators.dart
│ │ ├── extensions.dart
│ │ └── helpers.dart
│ ├── theme/ # Themes and styles
│ │ ├── app_theme.dart
│ │ ├── colors.dart
│ │ ├── text_styles.dart
│ │ └── dimensions.dart
│ └── injection/ # Dependency injection
│ └── injection_container.dart
├── features/ # Feature modules
│ ├── [feature_name]/
│ │ ├── data/
│ │ │ ├── datasources/
│ │ │ ├── models/
│ │ │ └── repositories/
│ │ ├── domain/
│ │ │ ├── entities/
│ │ │ ├── repositories/
│ │ │ └── usecases/
│ │ └── presentation/
│ │ ├── bloc/
│ │ ├── pages/
│ │ └── widgets/
│ └── [other_features]/ # Other features
├── shared/ # Components shared between features
│ ├── widgets/
│ │ ├── loading_widget.dart
│ │ ├── error_widget.dart
│ │ └── custom_button.dart
│ └── services/
│ ├── storage_service.dart
│ └── navigation_service.dart
└── main.dart

Architecture Layers

1. CORE

Contains components shared across the entire application:

- constants/: Global constants, API URLs, and settings.
- errors/: Centralized error and exception handling.
- network/: HTTP client configuration and connectivity checking.
- usecases/: Base class for all use cases.
- utils/: Reusable extensions, validators, and helpers.
- theme/: Configuration for themes, colors, and styles.
- injection/: Dependency injection container.

2. FEATURES

Each feature follows the Clean Architecture pattern with 3 layers:

DATA Layer
Responsible for data retrieval and storage:

- datasources/: Data sources (API, local database).
- models/: Data models that are coupled to the data sources.
- repositories/: Implementation of the repositories defined in the Domain layer.

DOMAIN Layer
Contains the core business logic:

- entities/: Pure business entities.
- repositories/: Contracts (interfaces) for the repositories.
- usecases/: Specific business rules and logic.

PRESENTATION Layer
Manages the user interface and user interaction:

- bloc/: State management (using the BLoC pattern).
- pages/: Application screens.
- widgets/: UI components specific to the feature.

3. SHARED

Contains components that are reusable across different features:

- widgets/: Reusable UI components (e.g., custom buttons, loading indicators).
- services/: Global services (e.g., navigation, local storage).

Data Flow

UI (Presentation) -> BLoC -> UseCase -> Repository -> DataSource -> API/Database

1. The UI triggers an event to the BLoC.
2. The BLoC calls the appropriate UseCase.
3. The UseCase executes the business logic and interacts with the Repository.
4. The Repository determines which DataSource to use (remote or local).
5. The DataSource fetches the data from the API or a local database.
6. The data flows back through the layers to update the UI.

Technologies and Patterns

State Management

- BLoC Pattern with flutter_bloc.
- Immutable states with equatable.

Dependency Injection

- get_it for service location.
- injectable for automatic code generation.

Networking

- dio for HTTP requests.
- retrofit for API client generation.

Serialization

- json_annotation and json_serializable.
- freezed for immutable classes.

Local Storage

- hive for the local database.
- shared_preferences for simple key-value storage.

Navigation

- go_router for declarative routing.

Naming Conventions

Files

- snake_case for filenames.

Classes

- PascalCase for class names.
- Descriptive names: UserModel, UserBloc, GetUsers.

Variables and Methods

- camelCase for variables and methods.
- Descriptive names: getUserData(), isValid.
