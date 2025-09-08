import 'dart:io';

/// Test to verify the app can be built successfully
/// This checks compilation and build process
void main() async {
  print('🔨 Testing app build process...\n');

  final buildTests = [
    {
      'name': 'Flutter Doctor Check',
      'command': 'flutter',
      'args': ['doctor', '--verbose'],
      'description': 'Checking Flutter installation and dependencies'
    },
    {
      'name': 'Dependencies Check',
      'command': 'flutter',
      'args': ['pub', 'get'],
      'description': 'Installing and checking dependencies'
    },
    {
      'name': 'Code Analysis',
      'command': 'flutter',
      'args': ['analyze'],
      'description': 'Running static code analysis'
    },
    {
      'name': 'Localization Generation',
      'command': 'flutter',
      'args': ['gen-l10n'],
      'description': 'Generating localization files'
    },
    {
      'name': 'Build Test (Debug)',
      'command': 'flutter',
      'args': ['build', 'apk', '--debug'],
      'description': 'Building debug APK'
    },
  ];

  var allPassed = true;
  var testsRun = 0;
  var testsPassed = 0;

  for (final test in buildTests) {
    testsRun++;
    print('🔧 ${test['description']}...');
    
    try {
      final result = await Process.run(
        test['command'] as String,
        test['args'] as List<String>,
        runInShell: true,
      );

      if (result.exitCode == 0) {
        print('✅ ${test['name']} - PASSED');
        testsPassed++;
      } else {
        print('❌ ${test['name']} - FAILED');
        print('   Exit code: ${result.exitCode}');
        if (result.stderr.toString().isNotEmpty) {
          print('   Error: ${result.stderr}');
        }
        allPassed = false;
      }
    } catch (e) {
      print('❌ ${test['name']} - ERROR: $e');
      allPassed = false;
    }
    
    print('');
  }

  // Summary
  print('📊 BUILD TEST SUMMARY');
  print('=' * 40);
  print('Tests Run: $testsRun');
  print('Passed: $testsPassed');
  print('Failed: ${testsRun - testsPassed}');
  print('');

  if (allPassed) {
    print('🎉 BUILD TESTS PASSED!');
    print('');
    print('✅ Flutter environment is properly set up');
    print('✅ Dependencies are correctly installed');
    print('✅ Code passes static analysis');
    print('✅ Localization files generate successfully');
    print('✅ App builds without errors');
    print('');
    print('🚀 Your app is ready to run!');
    print('');
    print('Next steps:');
    print('1. Run: flutter test test/quick_app_test.dart');
    print('2. Run: flutter run (to test on device)');
  } else {
    print('⚠️  BUILD TESTS FAILED!');
    print('');
    print('Please fix the issues above before running the app.');
    print('Common solutions:');
    print('- Run: flutter doctor --android-licenses');
    print('- Run: flutter clean && flutter pub get');
    print('- Check your Flutter and Dart SDK versions');
    exit(1);
  }
}