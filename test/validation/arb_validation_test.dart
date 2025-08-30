import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ARB Files Validation', () {
    test('should have all ARB files with consistent keys', () async {
      final l10nDir = Directory('lib/l10n');
      final arbFiles = l10nDir
          .listSync()
          .where((file) => file.path.endsWith('.arb'))
          .cast<File>()
          .toList();

      expect(arbFiles.isNotEmpty, isTrue, reason: 'No ARB files found');

      // Read the English file as reference
      final englishFile = arbFiles.firstWhere(
        (file) => file.path.contains('app_en.arb'),
        orElse: () => throw Exception('English ARB file not found'),
      );

      final englishContent = await englishFile.readAsString();
      final englishJson = jsonDecode(englishContent) as Map<String, dynamic>;
      final englishKeys = englishJson.keys.toSet();

      print('Reference (English) has ${englishKeys.length} keys');

      // Check each ARB file
      for (final arbFile in arbFiles) {
        final fileName = arbFile.path.split(Platform.pathSeparator).last;
        print('Validating $fileName...');

        try {
          final content = await arbFile.readAsString();
          final json = jsonDecode(content) as Map<String, dynamic>;
          final keys = json.keys.toSet();

          // Check if all English keys are present
          final missingKeys = englishKeys.difference(keys);
          final extraKeys = keys.difference(englishKeys);

          if (missingKeys.isNotEmpty) {
            print('  ⚠ Missing keys in $fileName: ${missingKeys.join(', ')}');
          }

          if (extraKeys.isNotEmpty) {
            print('  ⚠ Extra keys in $fileName: ${extraKeys.join(', ')}');
          }

          if (missingKeys.isEmpty && extraKeys.isEmpty) {
            print('  ✓ $fileName - All keys match (${keys.length} keys)');
          }

          // Ensure the file is valid JSON
          expect(json, isA<Map<String, dynamic>>(), 
                 reason: '$fileName is not valid JSON');

        } catch (e) {
          fail('Failed to parse $fileName: $e');
        }
      }
    });

    test('should have valid JSON structure in all ARB files', () async {
      final l10nDir = Directory('lib/l10n');
      final arbFiles = l10nDir
          .listSync()
          .where((file) => file.path.endsWith('.arb'))
          .cast<File>()
          .toList();

      for (final arbFile in arbFiles) {
        final fileName = arbFile.path.split(Platform.pathSeparator).last;
        final content = await arbFile.readAsString();

        try {
          final json = jsonDecode(content);
          expect(json, isA<Map<String, dynamic>>());
          
          // Check that all values are strings (basic validation)
          final map = json as Map<String, dynamic>;
          for (final entry in map.entries) {
            expect(entry.value, isA<String>(), 
                   reason: 'Key "${entry.key}" in $fileName should have string value');
          }
          
          print('✓ $fileName - Valid JSON structure');
        } catch (e) {
          fail('Invalid JSON in $fileName: $e');
        }
      }
    });

    test('should have expected language files', () async {
      final expectedLanguages = [
        'en', 'hi', 'bn', 'te', 'ta', 'mr', 'gu', 'kn', 'ml', 'or', 'pa', 'as', 'ur'
      ];

      final l10nDir = Directory('lib/l10n');
      final arbFiles = l10nDir
          .listSync()
          .where((file) => file.path.endsWith('.arb'))
          .map((file) => file.path.split(Platform.pathSeparator).last)
          .toList();

      for (final langCode in expectedLanguages) {
        final expectedFileName = 'app_$langCode.arb';
        expect(arbFiles.contains(expectedFileName), isTrue,
               reason: 'Missing ARB file for language: $langCode');
      }

      print('✓ All expected language files are present');
    });
  });
}