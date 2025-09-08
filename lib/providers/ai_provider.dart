import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/secure_storage_repository.dart';
import '../services/openrouter_service.dart';
import '../services/gemini_service.dart';
import '../models/ai_provider.dart';
import '../models/subject_type.dart';
import '../utils/constants.dart';

class AIProviderManager extends ChangeNotifier {
  AIProvider _selectedProvider = AIProvider.none;
  late SharedPreferences _prefs;
  final SecureStorageRepository _secureStorageRepository;
  bool _isInitialized = false;

  AIProviderManager(this._secureStorageRepository) {
    _loadSelectedProvider();
  }

  AIProvider get selectedProvider => _selectedProvider;
  bool get isInitialized => _isInitialized;

  Future<void> _loadSelectedProvider() async {
    _prefs = await SharedPreferences.getInstance();
    final providerName = _prefs.getString(AppConstants.keySelectedAIProvider);
    
    if (providerName != null) {
      try {
        _selectedProvider = AIProvider.values.firstWhere(
          (e) => e.toString() == 'AIProvider.$providerName',
          orElse: () => AIProvider.none,
        );
      } catch (e) {
        debugPrint('Error loading AI provider: $e');
        _selectedProvider = AIProvider.none;
      }
    } else {
      // Auto-select provider if one has an API key configured
      _selectedProvider = await _autoSelectProvider();
    }
    
    _isInitialized = true;
    notifyListeners();
  }

  Future<AIProvider> _autoSelectProvider() async {
    // Check for available API keys and auto-select the first available provider
    final openRouterKey = await _secureStorageRepository.getOpenRouterKey();
    if (openRouterKey != null && openRouterKey.isNotEmpty) {
      await setSelectedProvider(AIProvider.openrouter);
      return AIProvider.openrouter;
    }

    final openAIKey = await _secureStorageRepository.getOpenAIKey();
    if (openAIKey != null && openAIKey.isNotEmpty) {
      await setSelectedProvider(AIProvider.openai);
      return AIProvider.openai;
    }

    final geminiKey = await _secureStorageRepository.getGeminiKey();
    if (geminiKey != null && geminiKey.isNotEmpty) {
      await setSelectedProvider(AIProvider.gemini);
      return AIProvider.gemini;
    }

    final anthropicKey = await _secureStorageRepository.getAnthropicKey();
    if (anthropicKey != null && anthropicKey.isNotEmpty) {
      await setSelectedProvider(AIProvider.anthropic);
      return AIProvider.anthropic;
    }

    return AIProvider.none;
  }

  Future<void> setSelectedProvider(AIProvider provider) async {
    _selectedProvider = provider;
    await _prefs.setString(AppConstants.keySelectedAIProvider, provider.name);
    notifyListeners();
  }

  Future<String> generateQuestion(String prompt, {String? model}) async {
    if (_selectedProvider == AIProvider.none) {
      // Try to auto-select a provider
      final autoSelected = await _autoSelectProvider();
      if (autoSelected == AIProvider.none) {
        throw Exception('No AI provider configured. Please add an API key in settings.');
      }
    }

    switch (_selectedProvider) {
      case AIProvider.openai:
        final apiKey = await _secureStorageRepository.getOpenAIKey();
        if (apiKey == null || apiKey.isEmpty) {
          throw Exception('OpenAI API key not found. Please configure it in settings.');
        }
        // TODO: Implement OpenAI service
        throw UnimplementedError('OpenAI service not yet implemented. Please use OpenRouter instead.');
        
      case AIProvider.gemini:
        final apiKey = await _secureStorageRepository.getGeminiKey();
        if (apiKey == null || apiKey.isEmpty) {
          throw Exception('Gemini API key not found. Please configure it in settings.');
        }
        final geminiService = GeminiService(_secureStorageRepository);
        return await geminiService.generateQuestion(prompt, model: model);
        
      case AIProvider.anthropic:
        final apiKey = await _secureStorageRepository.getAnthropicKey();
        if (apiKey == null || apiKey.isEmpty) {
          throw Exception('Anthropic API key not found. Please configure it in settings.');
        }
        // TODO: Implement Anthropic service
        throw UnimplementedError('Anthropic service not yet implemented. Please use OpenRouter instead.');
        
      case AIProvider.openrouter:
        final apiKey = await _secureStorageRepository.getOpenRouterKey();
        if (apiKey == null || apiKey.isEmpty) {
          throw Exception('OpenRouter API key not found. Please configure it in settings.');
        }
        final openRouterService = OpenRouterService(_secureStorageRepository);
        return await openRouterService.generateQuestion(prompt, model: model);
        
      case AIProvider.none:
        throw Exception('No AI provider configured. Please add an API key in settings.');
    }
  }

  Future<String> generateSubjectQuestion(SubjectType subject, {String? model, String language = 'English'}) async {
    if (_selectedProvider == AIProvider.none) {
      final autoSelected = await _autoSelectProvider();
      if (autoSelected == AIProvider.none) {
        throw Exception('No AI provider configured. Please add an API key in settings.');
      }
    }

    switch (_selectedProvider) {
      case AIProvider.openrouter:
        final openRouterService = OpenRouterService(_secureStorageRepository);
        return await openRouterService.generateSubjectQuestion(subject, model: model, language: language);
        
      case AIProvider.gemini:
        final geminiService = GeminiService(_secureStorageRepository);
        return await geminiService.generateSubjectQuestion(subject, model: model, language: language);
        
      default:
        // For other providers, use the generic prompt method
        String prompt = _buildSubjectPrompt(subject, language: language);
        return await generateQuestion(prompt, model: model);
    }
  }

  String _buildSubjectPrompt(SubjectType subject, {String language = 'English'}) {
    String languageInstruction = language != 'English' ? 'Generate the question in $language language. ' : '';
    
    switch (subject) {
      case SubjectType.math:
        return '${languageInstruction}Generate a short mathematics problem suitable for a college student. Include clear problem statement and make it solvable.';
      case SubjectType.science:
        return '${languageInstruction}Generate a short science problem suitable for a college student. Focus on physics, chemistry, or biology concepts.';
      case SubjectType.history:
        return '${languageInstruction}Generate a brief history question suitable for a college student about significant historical events or processes.';
      case SubjectType.geography:
        return '${languageInstruction}Generate a short geography question suitable for a college student about physical or human geography concepts.';
      case SubjectType.none:
        return '${languageInstruction}Generate a general educational question suitable for a college student.';
    }
  }

  Future<bool> validateCurrentProvider() async {
    switch (_selectedProvider) {
      case AIProvider.openrouter:
        final openRouterService = OpenRouterService(_secureStorageRepository);
        return await openRouterService.validateApiKey();
      case AIProvider.gemini:
        final geminiService = GeminiService(_secureStorageRepository);
        return await geminiService.validateApiKey();
      case AIProvider.openai:
      case AIProvider.anthropic:
        // TODO: Implement validation for other providers
        return false;
      case AIProvider.none:
        return false;
    }
  }

  Future<List<AIProvider>> getAvailableProviders() async {
    final List<AIProvider> available = [];
    
    final openRouterKey = await _secureStorageRepository.getOpenRouterKey();
    if (openRouterKey != null && openRouterKey.isNotEmpty) {
      available.add(AIProvider.openrouter);
    }

    final openAIKey = await _secureStorageRepository.getOpenAIKey();
    if (openAIKey != null && openAIKey.isNotEmpty) {
      available.add(AIProvider.openai);
    }

    final geminiKey = await _secureStorageRepository.getGeminiKey();
    if (geminiKey != null && geminiKey.isNotEmpty) {
      available.add(AIProvider.gemini);
    }

    final anthropicKey = await _secureStorageRepository.getAnthropicKey();
    if (anthropicKey != null && anthropicKey.isNotEmpty) {
      available.add(AIProvider.anthropic);
    }

    return available;
  }

  String getProviderDisplayName(AIProvider provider) {
    switch (provider) {
      case AIProvider.openai:
        return 'OpenAI GPT';
      case AIProvider.gemini:
        return 'Google Gemini';
      case AIProvider.anthropic:
        return 'Anthropic Claude';
      case AIProvider.openrouter:
        return 'OpenRouter';
      case AIProvider.none:
        return 'None Selected';
    }
  }
}