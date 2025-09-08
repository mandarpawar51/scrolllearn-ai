// TODO: Uncomment when flutter_secure_storage is properly configured
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageRepository {
  // TODO: Uncomment when flutter_secure_storage is properly configured
  // static const _storage = FlutterSecureStorage(
  //   aOptions: AndroidOptions(
  //     encryptedSharedPreferences: true,
  //   ),
  //   iOptions: IOSOptions(
  //     accessibility: KeychainItemAccessibility.first_unlock_this_device,
  //   ),
  // );

  // Mock storage for development/testing
  static final Map<String, String> _mockStorage = {};

  // API Key storage keys
  static const String _openaiKeyKey = 'openai_api_key';
  static const String _geminiKeyKey = 'gemini_api_key';
  static const String _anthropicKeyKey = 'anthropic_api_key';
  static const String _openrouterKeyKey = 'openrouter_api_key';

  // Store API keys
  Future<void> setOpenAIKey(String key) async {
    // TODO: Use secure storage when properly configured
    // await _storage.write(key: _openaiKeyKey, value: key);
    _mockStorage[_openaiKeyKey] = key;
  }

  Future<void> setGeminiKey(String key) async {
    // TODO: Use secure storage when properly configured
    // await _storage.write(key: _geminiKeyKey, value: key);
    _mockStorage[_geminiKeyKey] = key;
  }

  Future<void> setAnthropicKey(String key) async {
    // TODO: Use secure storage when properly configured
    // await _storage.write(key: _anthropicKeyKey, value: key);
    _mockStorage[_anthropicKeyKey] = key;
  }

  Future<void> setOpenRouterKey(String key) async {
    // TODO: Use secure storage when properly configured
    // await _storage.write(key: _openrouterKeyKey, value: key);
    _mockStorage[_openrouterKeyKey] = key;
  }

  // Retrieve API keys
  Future<String?> getOpenAIKey() async {
    // TODO: Use secure storage when properly configured
    // return await _storage.read(key: _openaiKeyKey);
    return _mockStorage[_openaiKeyKey];
  }

  Future<String?> getGeminiKey() async {
    // TODO: Use secure storage when properly configured
    // return await _storage.read(key: _geminiKeyKey);
    return _mockStorage[_geminiKeyKey];
  }

  Future<String?> getAnthropicKey() async {
    // TODO: Use secure storage when properly configured
    // return await _storage.read(key: _anthropicKeyKey);
    return _mockStorage[_anthropicKeyKey];
  }

  Future<String?> getOpenRouterKey() async {
    // TODO: Use secure storage when properly configured
    // return await _storage.read(key: _openrouterKeyKey);
    return _mockStorage[_openrouterKeyKey];
  }

  // Check if any API key is set
  Future<bool> hasAnyApiKey() async {
    final openai = await getOpenAIKey();
    final gemini = await getGeminiKey();
    final anthropic = await getAnthropicKey();
    final openrouter = await getOpenRouterKey();
    
    return openai != null || gemini != null || anthropic != null || openrouter != null;
  }

  // Clear all API keys
  Future<void> clearAllKeys() async {
    // TODO: Use secure storage when properly configured
    // await _storage.delete(key: _openaiKeyKey);
    // await _storage.delete(key: _geminiKeyKey);
    // await _storage.delete(key: _anthropicKeyKey);
    // await _storage.delete(key: _openrouterKeyKey);
    _mockStorage.clear();
  }

  // Validate API key format (basic validation)
  static bool isValidApiKeyFormat(String key, String provider) {
    if (key.trim().isEmpty) return false;
    
    switch (provider.toLowerCase()) {
      case 'openai':
        return key.startsWith('sk-') && key.length > 20;
      case 'gemini':
        return key.length > 20; // Basic length check for Gemini
      case 'anthropic':
        return key.startsWith('sk-ant-') && key.length > 20;
      case 'openrouter':
        return key.startsWith('sk-') && key.length > 20; // OpenRouter keys often start with sk-
      default:
        return key.length > 10; // Generic validation
    }
  }
}