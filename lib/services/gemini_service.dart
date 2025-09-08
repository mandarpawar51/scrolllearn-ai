import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../repositories/secure_storage_repository.dart';
import '../utils/constants.dart';
import '../models/subject_type.dart';

class GeminiService {
  final SecureStorageRepository _secureStorageRepository;
  final String _baseUrl = AppConstants.geminiBaseUrl;
  final String _generateEndpoint = AppConstants.geminiGenerateEndpoint;
  final http.Client _httpClient; // New field for http client

  // Modified constructor to accept optional http.Client
  GeminiService(this._secureStorageRepository, {http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  Future<String> generateQuestion(String prompt, {String? model}) async {
    final apiKey = await _secureStorageRepository.getGeminiKey();

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Gemini API key not found. Please configure it in settings.');
    }

    final url = Uri.parse('$_baseUrl$_generateEndpoint?key=$apiKey');
    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {
              'text': '''You are an educational AI assistant that creates challenging but fair study problems for college students. Always provide clear, well-structured questions that test understanding of key concepts.

$prompt'''
            }
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.7,
        'topP': 0.9,
        'maxOutputTokens': 1000,
      },
      'safetySettings': [
        {
          'category': 'HARM_CATEGORY_HARASSMENT',
          'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
        },
        {
          'category': 'HARM_CATEGORY_HATE_SPEECH',
          'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
        },
        {
          'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
          'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
        },
        {
          'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
          'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
        }
      ]
    });

    try {
            final response = await _httpClient.post( // Use _httpClient
        url,
        headers: headers,
        body: body,
      ).timeout(Duration(seconds: AppConstants.apiTimeoutSeconds));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        
        if (jsonResponse['candidates'] != null && 
            jsonResponse['candidates'].isNotEmpty &&
            jsonResponse['candidates'][0]['content'] != null &&
            jsonResponse['candidates'][0]['content']['parts'] != null &&
            jsonResponse['candidates'][0]['content']['parts'].isNotEmpty) {
          return jsonResponse['candidates'][0]['content']['parts'][0]['text']?.trim() ?? 
                 'Unable to generate question content.';
        } else {
          debugPrint('Gemini API: Invalid response format. Full response: ${response.body}'); // Add this line
          throw Exception('Invalid response format from Gemini API');
        }
      } else if (response.statusCode == 400) {
        final errorBody = jsonDecode(response.body);
        final errorMessage = errorBody['error']?['message'] ?? 'Bad request';
        throw Exception('Invalid request: $errorMessage');
      } else if (response.statusCode == 403) {
        throw Exception('Invalid API key or insufficient permissions. Please check your Gemini API key in settings.');
      } else if (response.statusCode == 429) {
        throw Exception('Rate limit exceeded. Please try again in a moment.');
      } else if (response.statusCode >= 500) {
        throw Exception('Gemini service is temporarily unavailable. Please try again later.');
      } else {
        final errorBody = response.body;
        debugPrint('Gemini API Error: ${response.statusCode} - $errorBody');
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
    
    switch (subject) {
      case SubjectType.math:
        return '''${languageInstruction}Generate a concise mathematics problem for a college student. 
        Choose from calculus, algebra, or geometry. Keep it short and focused.
        Format: Question on one line, then "Solution:" followed by the answer Do NOT include any explanations.''';
        
      case SubjectType.science:
        return '''${languageInstruction}Generate a short science question for a college student.
        Choose from physics, chemistry, or biology. Keep it concise and clear.
        Format: Question on one line, then "Solution:" followed by the answer Do NOT include any explanations.''';
        
      case SubjectType.history:
        return '''${languageInstruction}Generate a brief history question for a college student.
        Focus on significant events or figures. Keep it short and engaging.
        Format: Question on one line, then "Solution:" followed by the answer Do NOT include any explanations.''';
        
      case SubjectType.geography:
        return '''${languageInstruction}Generate a short geography question for a college student.
        Focus on countries, capitals, or geographic features. Keep it concise.
        Format: Question on one line, then "Solution:" followed by the answer Do NOT include any explanations.''';
        
      case SubjectType.none:
        return '${languageInstruction}Generate a short educational question for a college student.';
    }
  }

  Future<bool> validateApiKey() async {
    try {
      final apiKey = await _secureStorageRepository.getGeminiKey();
      if (apiKey == null || apiKey.isEmpty) {
        return false;
      }

      // Test with a simple request
      final url = Uri.parse('$_baseUrl$_generateEndpoint?key=$apiKey');
      final headers = {
        'Content-Type': 'application/json',
      };

      final body = jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': 'Hello'}
            ]
          }
        ],
        'generationConfig': {
          'maxOutputTokens': 10,
        }
      });

      final response = await _httpClient.post( // Use _httpClient
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