enum AIProvider {
  openai,
  gemini,
  anthropic,
  openrouter,
  none, // For cases where no provider is selected or configured
}

extension AIProviderExtension on AIProvider {
  String get displayName {
    switch (this) {
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

  String get description {
    switch (this) {
      case AIProvider.openai:
        return 'GPT-3.5 and GPT-4 models from OpenAI';
      case AIProvider.gemini:
        return 'Google\'s Gemini AI models';
      case AIProvider.anthropic:
        return 'Claude models from Anthropic';
      case AIProvider.openrouter:
        return 'Access to multiple AI models through OpenRouter';
      case AIProvider.none:
        return 'No AI provider selected';
    }
  }

  bool get isImplemented {
    switch (this) {
      case AIProvider.openrouter:
      case AIProvider.gemini:
        return true;
      case AIProvider.openai:
      case AIProvider.anthropic:
        return false; // TODO: Implement these providers
      case AIProvider.none:
        return false;
    }
  }
}