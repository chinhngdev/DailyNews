# DailyNews iOS App - AI Coding Agent Instructions

## Architecture Overview

This is a Clean Architecture iOS app using **MVVM + Coordinator + Repository pattern**. Follow the strict layer separation:

```
Presentation → Domain (UseCases) → Data (Repositories) → DataSources (DTOs)
```

- **Domain layer**: Pure Swift entities (`Article`, `NewsSource`) + protocols + use cases
- **Data layer**: DTOs with `.toDomain()` mapping + repository implementations
- **Presentation**: Coordinators for navigation + ViewModels + UIKit views

## Critical Setup Requirements

⚠️ **Before any development work**:
1. Create `DailyNews/DailyNews/Data/Network/Base/APIKeys.swift` with your NewsAPI key:
   ```swift
   struct APIKeys {
       static let newsAPIKey = "your_actual_api_key_here"
       static let newsAPIBaseURL = "https://newsapi.org/v2"
   }
   ```
2. Run `swiftgen` to regenerate assets/strings when adding resources

## Project-Specific Patterns

### DTO → Domain Mapping
Always implement `.toDomain()` methods on DTOs. Example from `ArticleResponseDTO.swift`:
```swift
struct ArticleResponseDTO: Decodable {
    func toDomain() -> ArticleResponse {
        return ArticleResponse(/* map fields */)
    }
}
```

### Network Layer Architecture
- Use enum-based routers (`NewsRouter`) conforming to `APIRouter`
- Repository classes handle status code mapping to domain-specific `NewsError` types
- `NetworkService` returns `NetworkResponse<T>` with status codes + decoded data

### Coordinator Navigation Pattern
- Each feature has its own coordinator (see `AppCoordinator.swift`)
- Use `Router` protocol for navigation abstraction
- Tab setup in `AppCoordinator.setupTabs()` - follow this pattern for new tabs

### Code Generation Dependencies
- **SwiftGen**: Generates `L10n` strings, `Asset` images, `ColorName` colors
- Generated files in `/Generated/` - never edit manually
- Config in `swiftgen.yml` - paths are relative to project root

### Testing Patterns
- Use `MockURLProtocol` for network layer testing (see `NewsServiceTests.swift`)
- Test setup with `URLSessionConfiguration.ephemeral` + custom protocol classes
- `TestHelpers.swift` for common mock data creation

### Configuration Management
- Build configs in `/Configurations/` using `.xcconfig` files
- Base settings in `Base.xcconfig`, environment-specific overrides in `Debug.xcconfig`/`Release.xcconfig`
- Minimum iOS 15, iPhone-only target

### File Organization Rules
- Group by feature/domain, not file type
- Repository implementations in `/Data/Repositories/`
- DTOs in `/Data/DataSources/Remote/DTOs/`
- Domain entities in `/Domain/Entities/`
- Use cases in `/Domain/UseCases/`
- One class per file, named after the main type

## Common Commands

```bash
# Regenerate assets after adding images/strings
swiftgen

# Run tests
xcodebuild test -scheme "DailyNews (Debug)" -destination 'platform=iOS Simulator,name=iPhone 15'

# Build project
xcodebuild -scheme "DailyNews (Debug)" -destination 'platform=iOS Simulator,name=iPhone 15'
```

## When Adding New Features

1. **Entities**: Create in `/Domain/Entities/`
2. **Network**: Add router case in appropriate router enum
3. **Repository**: Implement protocol in `/Domain/Interfaces/Repositories/`, concrete in `/Data/Repositories/`
4. **Use Case**: Protocol + implementation in `/Domain/UseCases/`
5. **Coordinator**: For navigation, follow `AppCoordinator` pattern
6. **DTO Mapping**: Always create corresponding DTO with `.toDomain()` method

## Error Handling Convention
- Domain-specific errors in `/Domain/Errors/` (e.g., `NewsError`)
- Repository layer maps HTTP status codes to domain errors
- Use `async throws` for network operations, handle with `do-catch` in use cases