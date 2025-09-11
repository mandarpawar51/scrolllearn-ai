import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../repositories/secure_storage_repository.dart';
import '../utils/constants.dart';
import '../models/subject_type.dart';

class OpenRouterService {
  final SecureStorageRepository _secureStorageRepository;
  final String _baseUrl = AppConstants.openRouterBaseUrl;
  final String _chatEndpoint = AppConstants.openRouterChatEndpoint;

  OpenRouterService(this._secureStorageRepository);

  Future<String> generateQuestion(String prompt, {String? model}) async {
    final apiKey = await _secureStorageRepository.getOpenRouterKey();

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('OpenRouter API key not found. Please configure it in settings.');
    }

    final url = Uri.parse('$_baseUrl$_chatEndpoint');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
      'HTTP-Referer': 'https://scrolllearn.ai', // Optional: for analytics
      'X-Title': 'ScrollLearn AI', // Optional: for analytics
    };

    final body = jsonEncode({
      'model': model ?? 'mistralai/mistral-7b-instruct:free', // Use free model as default
      'messages': [
        {
          'role': 'system',
          'content': 'You are an educational AI assistant that creates challenging but fair study problems for college students. Always provide clear, well-structured questions that test understanding of key concepts.'
        },
        {
          'role': 'user', 
          'content': prompt
        }
      ],
      'max_tokens': 200,
      'temperature': 0.7,
      'top_p': 0.9,
    });

    try {
      final response = await http.post(
        url, 
        headers: headers, 
        body: body,
      ).timeout(Duration(seconds: AppConstants.apiTimeoutSeconds));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        
        if (jsonResponse['choices'] != null && 
            jsonResponse['choices'].isNotEmpty &&
            jsonResponse['choices'][0]['message'] != null) {
          return jsonResponse['choices'][0]['message']['content']?.trim() ?? 
                 'Unable to generate question content.';
        } else {
          throw Exception('Invalid response format from OpenRouter API');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key. Please check your OpenRouter API key in settings.');
      } else if (response.statusCode == 429) {
        throw Exception('Rate limit exceeded. Please try again in a moment.');
      } else if (response.statusCode >= 500) {
        throw Exception('OpenRouter service is temporarily unavailable. Please try again later.');
      } else {
        final errorBody = response.body;
        debugPrint('OpenRouter API Error: ${response.statusCode} - $errorBody');
        throw Exception('Failed to generate question: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Request timed out. Please check your internet connection and try again.');
      }
      rethrow;
    }
  }

  Future<String> generateSubjectQuestion(SubjectType subject, {String? model, String language = 'English'}) async {
    String prompt = _buildSubjectPrompt(subject, language: language);
    return await generateQuestion(prompt, model: model);
  }

  String _buildSubjectPrompt(SubjectType subject, {String language = 'English'}) {
    String languageInstruction = language != 'English' ? 'Generate the question in $language language. ' : '';
    
    switch (subject.id) {
      case 'math':
        return '''${languageInstruction}Generate a concise mathematics problem for a college student. 
        Choose from calculus, algebra, or geometry. Keep it short and focused.
        Format: Question on one line, then "Solution:" followed by the answer Do NOT include any explanations.''';
        
      case 'science':
        return '''${languageInstruction}Generate a short science question for a college student.
        Choose from physics, chemistry, or biology. Keep it concise and clear.
        Format: Question on one line, then "Solution:" followed by the answer Do NOT include any explanations.''';
        
      case 'history':
        return '''${languageInstruction}Generate a brief history question for a college student.
        Focus on significant events or figures. Keep it short and engaging.
        Format: Question on one line, then "Solution:" followed by the answer Do NOT include any explanations.''';
        
      case 'geography':
        return '''${languageInstruction}Generate a short geography question for a college student.
        Focus on countries, capitals, or geographic features. Keep it concise.
        Format: Question on one line, then "Solution:" followed by the answer Do NOT include any explanations.''';
        
      default:
        return '${languageInstruction}Generate a short educational question about ${subject.displayName} for a college student.';
    }
  }

  Future<bool> validateApiKey() async {
    try {
      final apiKey = await _secureStorageRepository.getOpenRouterKey();
      if (apiKey == null || apiKey.isEmpty) {
        return false;
      }

      // Test with a simple request
      final url = Uri.parse('$_baseUrl$_chatEndpoint');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      };

      final body = jsonEncode({
        'model': 'mistralai/mistral-7b-instruct:free',
        'messages': [
          {'role': 'user', 'content': 'Hello'}
        ],
        'max_tokens': 10,
      });

      final response = await http.post(
        url, 
        headers: headers, 
        body: body,
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('API key validation error: $e');
      return false;
    }
  }
}