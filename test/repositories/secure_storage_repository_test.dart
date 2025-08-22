import 'package:flutter_test/flutter_test.dart';
import 'package:scrolllearn_ai/repositories/secure_storage_repository.dart';

void main() {
  group('SecureStorageRepository', () {
    late SecureStorageRepository repository;

    setUp(() {
      repository = SecureStorageRepository();
    });

    tearDown(() async {
      // Clear all keys after each test
      await repository.clearAllKeys();
    });

    group('API Key Storage', () {
      test('should store and retrieve OpenAI API key', () async {
        const testKey = 'sk-test-openai-key-123456789';
        
        await repository.setOpenAIKey(testKey);
        final retrievedKey = await repository.getOpenAIKey();
        
        expect(retrievedKey, equals(testKey));
      });

      test('should store and retrieve Gemini API key', () async {
        const testKey = 'gemini-test-key-123456789';
        
        await repository.setGeminiKey(testKey);
        final retrievedKey = await repository.getGeminiKey();
        
        expect(retrievedKey, equals(testKey));
      });

      test('should store and retrieve Anthropic API key', () async {
        const testKey = 'sk-ant-test-key-123456789';
        
        await repository.setAnthropicKey(testKey);
        final retrievedKey = await repository.getAnthropicKey();
        
        expect(retrievedKey, equals(testKey));
      });

      test('should return null for non-existent keys', () async {
        final openaiKey = await repository.getOpenAIKey();
        final geminiKey = await repository.getGeminiKey();
        final anthropicKey = await repository.getAnthropicKey();
        
        expect(openaiKey, isNull);
        expect(geminiKey, isNull);
        expect(anthropicKey, isNull);
      });

      test('should detect when any API key is set', () async {
        // Initially no keys
        expect(await repository.hasAnyApiKey(), isFalse);
        
        // Set one key
        await repository.setOpenAIKey('sk-test-key');
        expect(await repository.hasAnyApiKey(), isTrue);
        
        // Clear and set different key
        await repository.clearAllKeys();
        await repository.setGeminiKey('gemini-test-key');
        expect(await repository.hasAnyApiKey(), isTrue);
      });

      test('should clear all API keys', () async {
        // Set all keys
        await repository.setOpenAIKey('sk-openai-test');
        await repository.setGeminiKey('gemini-test');
        await repository.setAnthropicKey('sk-ant-test');
        
        // Verify they're set
        expect(await repository.hasAnyApiKey(), isTrue);
        
        // Clear all
        await repository.clearAllKeys();
        
        // Verify they're cleared
        expect(await repository.hasAnyApiKey(), isFalse);
        expect(await repository.getOpenAIKey(), isNull);
        expect(await repository.getGeminiKey(), isNull);
        expect(await repository.getAnthropicKey(), isNull);
      });
    });

    group('API Key Validation', () {
      test('should validate OpenAI API key format', () {
        expect(SecureStorageRepository.isValidApiKeyFormat('sk-1234567890123456789012', 'openai'), isTrue);
        expect(SecureStorageRepository.isValidApiKeyFormat('sk-short', 'openai'), isFalse);
        expect(SecureStorageRepository.isValidApiKeyFormat('invalid-format', 'openai'), isFalse);
        expect(SecureStorageRepository.isValidApiKeyFormat('', 'openai'), isFalse);
      });

      test('should validate Gemini API key format', () {
        expect(SecureStorageRepository.isValidApiKeyFormat('1234567890123456789012', 'gemini'), isTrue);
        expect(SecureStorageRepository.isValidApiKeyFormat('short', 'gemini'), isFalse);
        expect(SecureStorageRepository.isValidApiKeyFormat('', 'gemini'), isFalse);
      });

      test('should validate Anthropic API key format', () {
        expect(SecureStorageRepository.isValidApiKeyFormat('sk-ant-1234567890123456789012', 'anthropic'), isTrue);
        expect(SecureStorageRepository.isValidApiKeyFormat('sk-ant-short', 'anthropic'), isFalse);
        expect(SecureStorageRepository.isValidApiKeyFormat('invalid-format', 'anthropic'), isFalse);
        expect(SecureStorageRepository.isValidApiKeyFormat('', 'anthropic'), isFalse);
      });

      test('should validate generic API key format', () {
        expect(SecureStorageRepository.isValidApiKeyFormat('12345678901', 'unknown'), isTrue);
        expect(SecureStorageRepository.isValidApiKeyFormat('short', 'unknown'), isFalse);
        expect(SecureStorageRepository.isValidApiKeyFormat('', 'unknown'), isFalse);
      });
    });
  });
}