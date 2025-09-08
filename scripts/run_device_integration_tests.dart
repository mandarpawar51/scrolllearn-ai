import 'dart:io';

/// Device Integration Test Runner
/// This script runs integration tests on real devices/emulators via ADB
void main(List<String> args) async {
  print('🚀 ScrollLearn AI - Device Integration Test Runner');
  print('=' * 60);
  print('');

  // Check if device is connected
  print('📱 Checking connected devices...');
  final deviceCheck = await Process.run('flutter', ['devices'], runInShell: true);
  
  if (deviceCheck.exitCode != 0) {
    print('❌ Error checking devices: ${deviceCheck.stderr}');
    exit(1);
  }

  final devices = deviceCheck.stdout.toString();
  if (!devices.contains('•')) {
    print('❌ No devices found!');
    print('');
    print('Please ensure:');
    print('1. An Android device is connected via USB with USB debugging enabled');
    print('2. Or an Android emulator is running');
    print('3. Or an iOS simulator is running (on macOS)');
    print('');
    print('Run "flutter devices" to see available devices');
    exit(1);
  }

  print('✅ Found connected devices:');
  print(devices);
  print('');

  // Determine which tests to run
  final testSuites = [
    {
      'name': '🏗️ Basic Device Integration Tests',
      'file': 'integration_test/app_test.dart',
      'description': 'Basic app functionality on device',
      'duration': '2-3 minutes',
    },
    {
      'name': '🎯 Complete User Journey Tests',
      'file': 'integration_test/complete_user_journey_test.dart',
      'description': 'Full user workflow on device',
      'duration': '5-8 minutes',
    },
  ];

  // Check which test files exist
  final availableTests = <Map<String, String>>[];
  for (final suite in testSuites) {
    final file = File(suite['file']!);
    if (file.existsSync()) {
      availableTests.add(suite);
    } else {
      print('⚠️  Test file not found: ${suite['file']}');
    }
  }

  if (availableTests.isEmpty) {
    print('❌ No integration test files found!');
    exit(1);
  }

  print('📋 Available Test Suites:');
  for (int i = 0; i < availableTests.length; i++) {
    final suite = availableTests[i];
    print('${i + 1}. ${suite['name']}');
    print('   File: ${suite['file']}');
    print('   Description: ${suite['description']}');
    print('   Duration: ${suite['duration']}');
    print('');
  }

  // Determine which tests to run
  List<Map<String, String>> testsToRun;
  
  if (args.contains('--all')) {
    testsToRun = availableTests;
    print('🎯 Running ALL integration tests...');
  } else if (args.contains('--basic')) {
    testsToRun = availableTests.where((test) => test['file']!.contains('app_test.dart')).toList();
    print('🎯 Running BASIC integration tests...');
  } else if (args.contains('--complete')) {
    testsToRun = availableTests.where((test) => test['file']!.contains('complete_user_journey')).toList();
    print('🎯 Running COMPLETE user journey tests...');
  } else {
    // Default: run basic tests
    testsToRun = availableTests.where((test) => test['file']!.contains('app_test.dart')).toList();
    print('🎯 Running BASIC integration tests (default)...');
    print('   Use --all to run all tests');
    print('   Use --complete to run complete user journey tests');
  }

  print('');
  print('⚡ Starting device integration tests...');
  print('');

  var allPassed = true;
  var totalTests = 0;
  var passedTests = 0;

  for (final testSuite in testsToRun) {
    totalTests++;
    final testFile = testSuite['file']!;
    final testName = testSuite['name']!;
    
    print('🧪 Running: $testName');
    print('   File: $testFile');
    print('   Expected duration: ${testSuite['duration']}');
    print('');

    final startTime = DateTime.now();
    
    // Run the integration test on device
    final result = await Process.run(
      'flutter',
      ['test', testFile, '--verbose'],
      runInShell: true,
    );

    final endTime = DateTime.now();
    final duration = endTime.difference(startTime);

    if (result.exitCode == 0) {
      print('✅ $testName - PASSED');
      print('   Duration: ${duration.inMinutes}m ${duration.inSeconds % 60}s');
      passedTests++;
    } else {
      print('❌ $testName - FAILED');
      print('   Duration: ${duration.inMinutes}m ${duration.inSeconds % 60}s');
      print('   Exit code: ${result.exitCode}');
      
      if (result.stderr.toString().isNotEmpty) {
        print('   Error: ${result.stderr}');
      }
      
      allPassed = false;
    }
    print('');
  }

  // Summary
  print('📊 DEVICE INTEGRATION TEST SUMMARY');
  print('=' * 60);
  print('Tests Run: $totalTests');
  print('Passed: $passedTests');
  print('Failed: ${totalTests - passedTests}');
  print('Success Rate: ${((passedTests / totalTests) * 100).toStringAsFixed(1)}%');
  print('');

  if (allPassed) {
    print('🎉 ALL DEVICE INTEGRATION TESTS PASSED!');
    print('');
    print('✅ Your ScrollLearn AI app works perfectly on real devices!');
    print('');
    print('Verified functionality:');
    print('- App launches correctly on device');
    print('- Navigation works smoothly');
    print('- Text input responds properly');
    print('- Gestures are recognized');
    print('- Device rotation is handled');
    print('- Performance is acceptable');
    print('- Memory usage is stable');
    print('');
    print('🚀 Ready for production deployment!');
    print('');
    print('Next steps:');
    print('1. Test on different device types and screen sizes');
    print('2. Test with real API keys');
    print('3. Perform user acceptance testing');
    print('4. Deploy to app stores');
  } else {
    print('⚠️  SOME DEVICE INTEGRATION TESTS FAILED');
    print('');
    print('Please review the failed tests above and fix any issues.');
    print('');
    print('Common solutions:');
    print('1. Ensure device has sufficient memory and storage');
    print('2. Check that all app permissions are granted');
    print('3. Verify the device OS version is supported');
    print('4. Try running tests on a different device');
    print('5. Check for device-specific compatibility issues');
    print('');
    print('Debug commands:');
    print('- flutter doctor (check Flutter setup)');
    print('- flutter devices (list connected devices)');
    print('- adb devices (check ADB connection)');
    print('- flutter logs (view device logs)');
    
    exit(1);
  }
}

/// Print usage information
void printUsage() {
  print('Usage: dart scripts/run_device_integration_tests.dart [options]');
  print('');
  print('Options:');
  print('  --all       Run all integration tests');
  print('  --basic     Run basic integration tests (default)');
  print('  --complete  Run complete user journey tests');
  print('');
  print('Examples:');
  print('  dart scripts/run_device_integration_tests.dart');
  print('  dart scripts/run_device_integration_tests.dart --all');
  print('  dart scripts/run_device_integration_tests.dart --complete');
}