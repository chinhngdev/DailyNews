┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                       │
│  - UIViewController / SwiftUI Views                         │
│  - ViewModels                                               │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   Application Layer                         │
│  - UseCases (Business Logic)                                │
│    * GetNewsUseCase                                         │
│    * SearchNewsUseCase                                      │
│    * SaveToFavoritesUseCase                                 │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                 Infrastructure Layer                        │
│  ┌─────────────────────┐  ┌─────────────────────────────┐   │
│  │   Repositories      │  │      Services               │   │
│  │ - NewsRepository    │  │ - CacheService              │   │
│  │ - FavoritesRepo     │  │ - ConnectivityService       │   │
│  │ - UserRepository    │  │ - AnalyticsService          │   │
│  └─────────────────────┘  └─────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     Data Sources                            │
│  - REST APIs                                                │
│  - CoreData / Realm                                         │
│  - UserDefaults                                             │
│  - File System                                              │
└─────────────────────────────────────────────────────────────┘