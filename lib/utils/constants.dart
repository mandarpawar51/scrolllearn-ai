// App Constants
class AppConstants {
  // App Info
  static const String appName = 'ScrollLearn AI';
  static const String appVersion = '1.0.0';
  
  // Gesture Thresholds
  static const double minSwipeDistance = 100.0;
  static const double maxSwipeAngle = 30.0; // degrees from horizontal/vertical
  static const int gestureDebounceMs = 300;
  
  // API Configuration
  static const int apiTimeoutSeconds = 30;
  static const int maxRetries = 3;
  static const int retryDelaySeconds = 2;
  
  // Performance Targets
  static const int maxGestureResponseMs = 200;
  static const int maxApiResponseMs = 3000;
  
  // Storage Keys
  static const String keyEnabledSubjects = 'enabled_subjects';
  static const String keyThemeMode = 'theme_mode';
  static const String keyDifficultyLevel = 'difficulty_level';
  static const String keySelectedAIProvider = 'selected_ai_provider';
  static const String keyHasCompletedOnboarding = 'has_completed_onboarding';
  
  // Secure Storage Keys
  static const String keyOpenAIApiKey = 'openai_api_key';
  static const String keyGeminiApiKey = 'gemini_api_key';
  static const String keyClaudeApiKey = 'claude_api_key';
  
  // OpenRouter Configuration
  static const String openRouterBaseUrl = 'https://openrouter.ai/api/v1';
  static const String openRouterModelsEndpoint = '/models';
  static const String openRouterChatEndpoint = '/chat/completions';
}

// Color Constants
class AppColors {
  static const int primaryBlue = 0xFF1979E6;
  static const int textPrimary = 0xFF111418;
  static const int textSecondary = 0xFF637588;
  static const int backgroundLight = 0xFFFFFFFF;
  static const int backgroundDark = 0xFF1A1A1A;
}