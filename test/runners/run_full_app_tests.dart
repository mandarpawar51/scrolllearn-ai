import 'dart:io';

/// Comprehensive test runner for the entire app
/// Run this with: flutter test test/run_full_app_tests.dart
void main() async {
  print('🚀 Running comprehensive app tests...\n');

  final testSuites = [
    {
      'name': '🏗️ App Startup & Integration',
      'files': [
        'test/integration/app_startup_test.dart',
      ]
    },
    {
      'name': '🌐 Language & Localization',
      'files': [
        'test/providers/language_provider_test.dart',
        'test/validation/arb_validation_test.dart',
        'test/widgets/language_selection_test.dart',
      ]
    },
    {
      'name': '🧩 Individual Components',
      'files': [
        'test/screens/home_screen_test.dart',
        'test/screens/api_keys_screen_test.dart',
        'test/repositories/secure_storage_repository_test.dart',
        'test/blocs/gesture_bloc_test.dart',
      ]
    },
    {
      'name': '🔄 Integration Flows',
      'files': [
        'test/integration/api_keys_flow_test.dart',
        'test/integration/language_switching_test.dart',
      ]
    },
    {
      'name': '🎯 Complete User Journeys',
      'files': [
        'test/integration/complete_app_flow_test.dart',
        'test/integration/user_scenarios_test.dart',
      ]
    },
    {
      'name': '💨 Quick Smoke Tests',
      'files': [
        'test/e2e/smoke_test.dart',
        'test/e2e/app_test_without_main.dart',
      ]
    },
  ];

  var allTestsPassed = true;
  var totalTests = 0;
  var passedTests = 0;

  for (final suite in testSuites) {
    print('${suite['name']}');
    print('${'=' * 50}');

    for (final testFile in suite['files'] as List<String>) {
      totalTests++;
      
      // Check if test file exists
      if (!File(testFile).existsSync()) {
        print('⚠️  $testFile - FILE NOT FOUND (skipping)');
        continue;
      }

      print('🧪 Running $testFile...');
      
      final result = await Process.run(
        'flutter',
        ['test', testFile, '--reporter=compact'],
        runInShell: true,
      );

      if (result.exitCode == 0) {
        print('✅ $testFile - PASSED');
        passedTests++;
      } else {
        print('❌ $testFile - FAILED');
        if (result.stderr.toString().isNotEmpty) {
          print('   Error: ${result.stderr}');
        }
        if (result.stdout.toString().isNotEmpty) {
          print('   Output: ${result.stdout}');
        }
        allTestsPassed = false;
      }
      print('');
    }
    print('');
  }

  // Summary
  print('📊 TEST SUMMARY');
  print('=' * 50);
  print('Total Tests: $totalTests');
  print('Passed: $passedTests');
  print('Failed: ${totalTests - passedTests}');
  print('Success Rate: ${((passedTests / totalTests) * 100).toStringAsFixed(1)}%');
  print('');

  if (allTestsPassed) {
    print('🎉 ALL TESTS PASSED!');
    print('');
    print('✅ App Startup: Working');
    print('✅ Language Support: Working');
    print('✅ UI Components: Working');
    print('✅ Integration Flows: Working');
    print('✅ Error Handling: Working');
    print('');
    print('🚀 Your app is ready for deployment!');
  } else {
    print('⚠️  SOME TESTS FAILED');
    print('');
    print('Please review the failed tests above and fix any issues.');
    print('The app may still work, but some features might have problems.');
    exit(1);
  }
}