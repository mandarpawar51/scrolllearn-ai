@echo off
REM ScrollLearn AI - Device Integration Test Runner (Windows)
REM This script runs integration tests on connected Android devices/emulators

echo.
echo ========================================
echo ScrollLearn AI - Device Integration Tests
echo ========================================
echo.

REM Check if Flutter is installed
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Flutter is not installed or not in PATH
    echo Please install Flutter and add it to your PATH
    pause
    exit /b 1
)

REM Check for connected devices
echo 📱 Checking for connected devices...
flutter devices
if %errorlevel% neq 0 (
    echo ❌ Error checking devices
    pause
    exit /b 1
)

echo.
echo Choose test type:
echo 1. Basic Integration Tests (2-3 minutes)
echo 2. Complete User Journey Tests (5-8 minutes)
echo 3. All Integration Tests (7-11 minutes)
echo.
set /p choice="Enter your choice (1-3): "

if "%choice%"=="1" (
    echo.
    echo 🧪 Running Basic Integration Tests...
    flutter test integration_test/app_test.dart
) else if "%choice%"=="2" (
    echo.
    echo 🧪 Running Complete User Journey Tests...
    flutter test integration_test/complete_user_journey_test.dart
) else if "%choice%"=="3" (
    echo.
    echo 🧪 Running All Integration Tests...
    flutter test integration_test/
) else (
    echo Invalid choice. Running basic tests by default...
    flutter test integration_test/app_test.dart
)

echo.
if %errorlevel% equ 0 (
    echo ✅ Integration tests completed successfully!
    echo Your app works great on real devices! 🚀
) else (
    echo ❌ Some tests failed. Please check the output above.
)

echo.
pause