import 'dart:io';

/// Comprehensive test runner for language functionality
/// Run this with: flutter test test/run_language_tests.dart
void main() async {
  print('🌐 Running comprehensive language tests...\n');

  final testFiles = [
    'test/providers/language_provider_test.dart',
    'test/validation/arb_validation_test.dart',
    'test/widgets/language_selection_test.dart',
  ];

  var allTestsPassed = true;

  for (final testFile in testFiles) {
    print('📋 Running $testFile...');
    
    final result = await Process.run(
      'flutter',
      ['test', testFile],
      runInShell: true,
    );

    if (result.exitCode == 0) {
      print('✅ $testFile - PASSED\n');
    } else {
      print('❌ $testFile - FAILED');
      print('Error output: ${result.stderr}');
      print('Standard output: ${result.stdout}\n');
      allTestsPassed = false;
    }
  }

  if (allTestsPassed) {
    print('🎉 All language tests passed successfully!');
    print('\n📝 Test Summary:');
    print('- Language Provider: ✅ All supported languages work');
    print('- ARB Files: ✅ All files are valid and consistent');
    print('- UI Components: ✅ Language switching works in UI');
    print('- RTL Support: ✅ Right-to-left languages handled correctly');
  } else {
    print('⚠️  Some tests failed. Please check the output above.');
    exit(1);
  }
}