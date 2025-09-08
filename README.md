# ScrollLearn AI 🎓

A gesture-based learning mobile app powered by AI that makes studying interactive and engaging across multiple subjects.

## 📱 Features

- **Gesture Navigation**: Swipe in different directions to access subjects
  - ⬇️ Down: Math problems
  - ⬆️ Up: Science problems  
  - ➡️ Right: History problems
  - ⬅️ Left: Geography problems
- **AI-Powered Questions**: Generate problems using OpenAI, Gemini, Claude via OpenRouter
- **Customizable Learning**: Select subjects and difficulty levels
- **Secure API Management**: Bring your own API keys
- **Cross-Platform**: Works on Android and iOS

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/scrolllearn-ai.git
   cd scrolllearn-ai
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### 🔐 API Configuration

This app requires AI API keys to generate problems. You'll need to:

1. Get API keys from one or more providers:
   - [Google AI (Gemini)](https://makersuite.google.com/app/apikey)
   - openrouter

2. Add your keys in the app settings (they're stored securely on your device)

**⚠️ IMPORTANT**: Never commit API keys to version control!

## 🏗️ Project Structure

```
lib/
├── blocs/          # State management (BLoC pattern)
├── models/         # Data models
├── repositories/   # Data access layer
├── screens/        # UI screens
├── services/       # Business logic services
├── utils/          # Utilities and constants
└── widgets/        # Reusable UI components
```

## 🧪 Testing

Run tests with:
```bash
flutter test
```

## 🔒 Security & Privacy

- API keys are stored securely using FlutterSecureStorage
- No personal data is transmitted without consent
- All data processing happens locally or through your chosen AI provider
- Open source - you can verify what the app does

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with Flutter and Dart
- AI integration via OpenRouter
- Icons from Material Design
- Inspired by modern gesture-based interfaces

## 📞 Support

If you have questions or need help:
- Open an issue on GitHub
- Check the [Flutter documentation](https://docs.flutter.dev/)
- Review the [BLoC documentation](https://bloclibrary.dev/)

---

**Made with ❤️ for learners everywhere**
