#!/bin/bash

# ScrollLearn AI - Device Integration Test Runner (macOS/Linux)
# This script runs integration tests on connected devices/emulators

echo ""
echo "========================================"
echo "ScrollLearn AI - Device Integration Tests"
echo "========================================"
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    echo "Please install Flutter and add it to your PATH"
    exit 1
fi

# Check for connected devices
echo "📱 Checking for connected devices..."
flutter devices
if [ $? -ne 0 ]; then
    echo "❌ Error checking devices"
    exit 1
fi

echo ""
echo "Choose test type:"
echo "1. Basic Integration Tests (2-3 minutes)"
echo "2. Complete User Journey Tests (5-8 minutes)"
echo "3. All Integration Tests (7-11 minutes)"
echo ""
read -p "Enter your choice (1-3): " choice

case $choice in
    1)
        echo ""
        echo "🧪 Running Basic Integration Tests..."
        flutter test integration_test/app_test.dart
        ;;
    2)
        echo ""
        echo "🧪 Running Complete User Journey Tests..."
        flutter test integration_test/complete_user_journey_test.dart
        ;;
    3)
        echo ""
        echo "🧪 Running All Integration Tests..."
        flutter test integration_test/
        ;;
    *)
        echo "Invalid choice. Running basic tests by default..."
        flutter test integration_test/app_test.dart
        ;;
esac

echo ""
if [ $? -eq 0 ]; then
    echo "✅ Integration tests completed successfully!"
    echo "Your app works great on real devices! 🚀"
else
    echo "❌ Some tests failed. Please check the output above."
fi

echo ""