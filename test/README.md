# Test Organization Guide

This document explains how the tests are organized in the ScrollLearn AI project.

## Test Structure

```
test/
├── README.md                    # This file - test organization guide
├── blocs/                       # Unit tests for BLoC components
│   └── gesture_bloc_test.dart
├── e2e/                         # End-to-end and smoke tests
│   ├── smoke_test.dart          # Basic app startup verification
│   └── app_test_without_main.dart # Full app functionality tests
├── integration/                 # Integration tests for user flows
│   ├── api_keys_flow_test.dart
│   ├── app_startup_test.dart
│   └── language_switching_test.dart
├── providers/                   # Unit tests for providers
│   └── language_provider_test.dart
├── repositories/                # Unit tests for data repositories
│   └── secure_storage_repository_test.dart
├── runners/                     # Test runner scripts
│   ├── quick_app_test.dart      # Quick functionality check
│   ├── run_full_app_tests.dart  # Comprehensive test suite
│   └── run_language_tests.dart  # Language-specific tests
├── screens/                     # Widget tests for screens
│   ├── api_keys_screen_test.dart
│   ├── home_screen_simple_test.dart
│   └── home_screen_test.dart
├── system/                      # Build and system tests
│   └── build_test.dart          # Build process verification
├── unit/                        # Pure unit tests
│   └── language_provider_test.dart
├── validation/                  # Data validation tests
│   └── arb_validation_test.dart
└── widgets/                     # Widget and UI component tests
    ├── language_selection_test.dart # Custom widget tests
    ├── simple_widget_test.dart  # Basic widget tests
    └── widget_test.dart         # Main widget tests
```

## Test Categories

### 1. Unit Tests (`unit/`, `blocs/`, `providers/`, `repositories/`)
- **Purpose**: Test individual components in isolation
- **Scope**: Single classes, functions, or methods
- **Dependencies**: Mocked or stubbed
- **Speed**: Very fast
- **Examples**: Testing a single provider method, BLoC state changes

### 2. Widget Tests (`widgets/`, `screens/`)
- **Purpose**: Test UI components and their interactions
- **Scope**: Individual widgets or screens
- **Dependencies**: Flutter test framework
- **Speed**: Fast
- **Examples**: Testing if a button appears, form validation, screen rendering

### 3. Integration Tests (`integration/`)
- **Purpose**: Test complete user workflows
- **Scope**: Multiple components working together
- **Dependencies**: Real or near-real implementations
- **Speed**: Medium
- **Examples**: Complete login flow, navigation between screens

### 4. End-to-End Tests (`e2e/`)
- **Purpose**: Test the entire application as a user would
- **Scope**: Full application functionality
- **Dependencies**: Complete app setup
- **Speed**: Slow but comprehensive
- **Examples**: App startup, complete user journeys

### 5. System Tests (`system/`)
- **Purpose**: Test build process and system requirements
- **Scope**: Development environment and build pipeline
- **Dependencies**: Flutter SDK, build tools
- **Speed**: Slow
- **Examples**: Build verification, dependency checks

### 6. Validation Tests (`validation/`)
- **Purpose**: Test data integrity and format validation
- **Scope**: Configuration files, data formats
- **Dependencies**: File system access
- **Speed**: Fast
- **Examples**: ARB file validation, configuration checks

### 7. Test Runners (`runners/`)
- **Purpose**: Orchestrate multiple test suites
- **Scope**: Test execution and reporting
- **Dependencies**: Flutter test command
- **Speed**: Varies based on tests run
- **Examples**: Running all tests, specific test categories

## Running Tests

### Quick Tests (Recommended for development)
```bash
flutter test test/runners/quick_app_test.dart
```

### Full Test Suite
```bash
flutter test test/runners/run_full_app_tests.dart
```

### Language-Specific Tests
```bash
flutter test test/runners/run_language_tests.dart
```

### Individual Test Categories
```bash
# Unit tests
flutter test test/unit/
flutter test test/blocs/
flutter test test/providers/
flutter test test/repositories/

# Widget tests
flutter test test/widgets/
flutter test test/screens/

# Integration tests
flutter test test/integration/

# End-to-end tests
flutter test test/e2e/

# System tests
flutter test test/system/

# Validation tests
flutter test test/validation/
```

### Single Test Files
```bash
flutter test test/unit/language_provider_test.dart
flutter test test/widgets/simple_widget_test.dart
flutter test test/e2e/smoke_test.dart
```

## Test Development Guidelines

### 1. Naming Conventions
- Test files should end with `_test.dart`
- Test descriptions should be clear and specific
- Use descriptive group names for related tests

### 2. Test Structure
```dart
void main() {
  group('Component Name', () {
    setUp(() {
      // Setup code here
    });

    testWidgets('should do something when condition', (tester) async {
      // Arrange
      // Act
      // Assert
    });
  });
}
```

### 3. Test Categories by Speed
- **Fast Tests**: Unit, Widget, Validation (< 1 second each)
- **Medium Tests**: Integration (1-10 seconds each)
- **Slow Tests**: E2E, System (10+ seconds each)

### 4. When to Use Each Test Type

#### Use Unit Tests When:
- Testing business logic
- Testing data transformations
- Testing individual functions
- Testing state management

#### Use Widget Tests When:
- Testing UI components
- Testing user interactions
- Testing screen layouts
- Testing form validation

#### Use Integration Tests When:
- Testing user workflows
- Testing navigation flows
- Testing data persistence
- Testing API interactions

#### Use E2E Tests When:
- Testing complete user journeys
- Testing app startup
- Testing critical paths
- Testing cross-platform behavior

## Best Practices

1. **Test Pyramid**: More unit tests, fewer integration tests, minimal E2E tests
2. **Fast Feedback**: Run quick tests during development
3. **Comprehensive Coverage**: Use full test suite before releases
4. **Isolated Tests**: Each test should be independent
5. **Clear Assertions**: Use descriptive expect statements
6. **Setup/Teardown**: Clean up after tests to avoid side effects

## Continuous Integration

The test runners are designed to work with CI/CD pipelines:

```yaml
# Example GitHub Actions workflow
- name: Run Quick Tests
  run: flutter test test/runners/quick_app_test.dart

- name: Run Full Test Suite
  run: flutter test test/runners/run_full_app_tests.dart
```

## Troubleshooting

### Common Issues
1. **Tests timing out**: Increase timeout or optimize test setup
2. **Widget tests failing**: Check for proper widget tree setup
3. **Integration tests flaky**: Add proper wait conditions
4. **Build tests failing**: Verify Flutter environment setup

### Debug Commands
```bash
# Run tests with verbose output
flutter test --verbose

# Run specific test with debugging
flutter test test/unit/language_provider_test.dart --verbose

# Check test coverage
flutter test --coverage
```