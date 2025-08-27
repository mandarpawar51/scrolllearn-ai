import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../repositories/secure_storage_repository.dart';
import '../utils/app_colors.dart';
import 'home_screen.dart';

class APIKeysScreen extends StatefulWidget {
  const APIKeysScreen({super.key});

  @override
  State<APIKeysScreen> createState() => _APIKeysScreenState();
}

class _APIKeysScreenState extends State<APIKeysScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _formKey = GlobalKey<FormState>();
  final _openaiController = TextEditingController();
  final _geminiController = TextEditingController();
  final _anthropicController = TextEditingController();

  final _secureStorage = SecureStorageRepository();
  
  bool _isLoading = false;
  bool _obscureOpenAI = true;
  bool _obscureGemini = true;
  bool _obscureAnthropic = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadExistingKeys();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));

    _animationController.forward();
  }

  Future<void> _loadExistingKeys() async {
    try {
      final openaiKey = await _secureStorage.getOpenAIKey();
      final geminiKey = await _secureStorage.getGeminiKey();
      final anthropicKey = await _secureStorage.getAnthropicKey();

      if (mounted) {
        setState(() {
          if (openaiKey != null) _openaiController.text = openaiKey;
          if (geminiKey != null) _geminiController.text = geminiKey;
          if (anthropicKey != null) _anthropicController.text = anthropicKey;
        });
      }
    } catch (e) {
      // Handle error silently for now
      debugPrint('Error loading API keys: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _openaiController.dispose();
    _geminiController.dispose();
    _anthropicController.dispose();
    super.dispose();
  }

  // Basic API key format validation
  bool _isValidApiKeyFormat(String key, String provider) {
    if (key.trim().isEmpty) return false;
    
    switch (provider.toLowerCase()) {
      case 'openai':
        return key.startsWith('sk-') && key.length > 20;
      case 'gemini':
        return key.length > 20; // Basic length check for Gemini
      case 'anthropic':
        return key.startsWith('sk-ant-') && key.length > 20;
      default:
        return key.length > 10; // Generic validation
    }
  }

  void _navigateBack() {
    HapticFeedback.lightImpact();
    Navigator.of(context).pop();
  }

  Future<void> _skipConfiguration() async {
    HapticFeedback.lightImpact();
    
    // Navigate to gesture tutorial screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  Future<void> _saveAndContinue() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Save API keys to secure storage
      if (_openaiController.text.trim().isNotEmpty) {
        await _secureStorage.setOpenAIKey(_openaiController.text.trim());
      }
      
      if (_geminiController.text.trim().isNotEmpty) {
        await _secureStorage.setGeminiKey(_geminiController.text.trim());
      }
      
      if (_anthropicController.text.trim().isNotEmpty) {
        await _secureStorage.setAnthropicKey(_anthropicController.text.trim());
      }

      HapticFeedback.lightImpact();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('API keys saved successfully!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        
        // Navigate to gesture tutorial screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving API keys: ${e.toString()}'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.height < 700;
    
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back arrow and title
            _buildHeader(context),
            
            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.06,
                ),
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: isSmallScreen ? 16 : 24),
                              
                              // Instructions
                              _buildInstructions(context),
                              
                              SizedBox(height: isSmallScreen ? 24 : 32),
                              
                              // API Key input fields
                              _buildOpenAIField(context, isSmallScreen),
                              SizedBox(height: isSmallScreen ? 16 : 20),
                              
                              _buildGeminiField(context, isSmallScreen),
                              SizedBox(height: isSmallScreen ? 16 : 20),
                              
                              _buildAnthropicField(context, isSmallScreen),
                              
                              SizedBox(height: isSmallScreen ? 24 : 32),
                              
                              // Help text
                              _buildHelpText(context),
                              
                              SizedBox(height: isSmallScreen ? 32 : 40),
                              
                              // Action buttons
                              _buildActionButtons(context),
                              
                              SizedBox(height: isSmallScreen ? 16 : 24),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: _navigateBack,
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.textPrimary,
              size: 24,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              shadowColor: Colors.black.withOpacity(0.1),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'API Keys',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Configure AI Providers',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Add your API keys to enable AI-powered problem generation. You can skip this step and configure later in settings.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildOpenAIField(BuildContext context, bool isSmallScreen) {
    return _buildApiKeyField(
      context: context,
      controller: _openaiController,
      label: 'OpenAI API Key',
      hint: 'sk-...',
      provider: 'openai',
      obscureText: _obscureOpenAI,
      onToggleVisibility: () => setState(() => _obscureOpenAI = !_obscureOpenAI),
      icon: Icons.psychology,
      color: AppColors.primaryBlue,
      isSmallScreen: isSmallScreen,
    );
  }

  Widget _buildGeminiField(BuildContext context, bool isSmallScreen) {
    return _buildApiKeyField(
      context: context,
      controller: _geminiController,
      label: 'Google Gemini API Key',
      hint: 'Enter your Gemini API key',
      provider: 'gemini',
      obscureText: _obscureGemini,
      onToggleVisibility: () => setState(() => _obscureGemini = !_obscureGemini),
      icon: Icons.auto_awesome,
      color: AppColors.warning,
      isSmallScreen: isSmallScreen,
    );
  }

  Widget _buildAnthropicField(BuildContext context, bool isSmallScreen) {
    return _buildApiKeyField(
      context: context,
      controller: _anthropicController,
      label: 'Anthropic (Claude) API Key',
      hint: 'sk-ant-...',
      provider: 'anthropic',
      obscureText: _obscureAnthropic,
      onToggleVisibility: () => setState(() => _obscureAnthropic = !_obscureAnthropic),
      icon: Icons.smart_toy,
      color: AppColors.success,
      isSmallScreen: isSmallScreen,
    );
  }

  Widget _buildApiKeyField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String hint,
    required String provider,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required IconData icon,
    required Color color,
    required bool isSmallScreen,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.textLight,
              fontSize: isSmallScreen ? 14 : 16,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.2),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.2),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: color,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            suffixIcon: IconButton(
              onPressed: onToggleVisibility,
              icon: Icon(
                obscureText ? Icons.visibility : Icons.visibility_off,
                color: AppColors.textLight,
                size: 20,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: isSmallScreen ? 12 : 16,
            ),
          ),
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            color: AppColors.textPrimary,
          ),
          validator: (value) {
            if (value != null && value.trim().isNotEmpty) {
              if (!_isValidApiKeyFormat(value.trim(), provider)) {
                return 'Invalid $provider API key format';
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildHelpText(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.info.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.info,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'How to get API keys:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.info,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '• OpenAI: Visit platform.openai.com/api-keys\n'
            '• Gemini: Visit makersuite.google.com/app/apikey\n'
            '• Anthropic: Visit console.anthropic.com/account/keys',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Save & Continue Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveAndContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.withOpacity(0.3),
              disabledForegroundColor: Colors.grey.withOpacity(0.6),
              elevation: _isLoading ? 0 : 4,
              shadowColor: AppColors.primaryBlue.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.save,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Save & Continue',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Skip Button
        TextButton(
          onPressed: _isLoading ? null : _skipConfiguration,
          child: Text(
            'Skip for now',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}