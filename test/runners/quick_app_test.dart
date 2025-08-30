import 'dart:io';

/// Quick test runner to verify the app works
/// This runs the most essential tests to check if your app is functional
void main() async {
  print('⚡ Running quick app functionality test...\n');

  final essentialTests = [
    'test/smoke_test.dart',
    'test/integration/app_startup_test.dart',
  ];

  var allPassed = true;

  for (final testFile in essentialTests) {
    if (!File(testFile).existsSync()) {
      print('⚠️  $testFile not found, skipping...');
      continue;
    }

    print('🧪 Testing: ${testFile.split('/').last}');
    
    final result = await Process.run(
      'flutter',
      ['test', testFile, '--reporter=compact'],
      runInShell: true,
    );

    if (result.exitCode == 0) {
      print('✅ PASSED\n');
    } else {
      print('❌ FAILED');
      print('Error: ${result.stderr}');
      print('Output: ${result.stdout}\n');
      allPassed = false;
    }
  }

  if (allPassed) {
    print('🎉 QUICK TEST PASSED!');
    print('Your app starts and runs correctly.');
    print('\nTo run comprehensive tests, use:');
    print('flutter test test/run_full_app_tests.dart');
  } else {
    print('⚠️  QUICK TEST FAILED!');
    print('Your app has startup issues that need to be fixed.');
    exit(1);
  }
}