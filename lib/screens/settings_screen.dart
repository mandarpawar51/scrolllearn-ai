import 'package:flutter/material.dart';
import '../repositories/secure_storage_repository.dart';
import '../utils/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _secureStorage = SecureStorageRepository();
  
  // API Keys controllers
  final _openaiController = TextEditingController();
  final _geminiController = TextEditingController();
  final _anthropicController = TextEditingController();
  
  // Settings state
  bool _darkMode = false;
  bool _appNotifications = true;
  bool _emailNotifications = false;
  String _selectedLanguage = 'English';
  
  // API Keys visibility
  bool _obscureOpenAI = true;
  bool _obscureGemini = true;
  bool _obscureAnthropic = true;
  bool _isLoadingKeys = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadExistingKeys();
  }

  @override
  void dispose() {
    _openaiController.dispose();
    _geminiController.dispose();
    _anthropicController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    // Load user preferences from storage
    setState(() {
      _darkMode = false;
      _appNotifications = true;
      _emailNotifications = false;
      _selectedLanguage = 'English';
    });
  }

  Future<void> _loadExistingKeys() async {
    setState(() {
      _isLoadingKeys = true;
    });

    try {
      final openaiKey = await _secureStorage.getOpenAIKey();
      final geminiKey = await _secureStorage.getGeminiKey();
      final anthropicKey = await _secureStorage.getAnthropicKey();

      _openaiController.text = openaiKey ?? '';
      _geminiController.text = geminiKey ?? '';
      _anthropicController.text = anthropicKey ?? '';
    } catch (e) {
      _showErrorSnackBar('Failed to load API keys: $e');
    } finally {
      setState(() {
        _isLoadingKeys = false;
      });
    }
  }

  Future<void> _saveApiKeys() async {
    setState(() {
      _isLoadingKeys = true;
    });

    try {
      if (_openaiController.text.isNotEmpty) {
        await _secureStorage.setOpenAIKey(_openaiController.text.trim());
      }
      if (_geminiController.text.isNotEmpty) {
        await _secureStorage.setGeminiKey(_geminiController.text.trim());
      }
      if (_anthropicController.text.isNotEmpty) {
        await _secureStorage.setAnthropicKey(_anthropicController.text.trim());
      }

      _showSuccessSnackBar('API keys saved successfully');
    } catch (e) {
      _showErrorSnackBar('Failed to save API keys: $e');
    } finally {
      setState(() {
        _isLoadingKeys = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildAccountSection(),
            const SizedBox(height: 32),
            _buildPreferencesSection(),
            const SizedBox(height: 32),
            _buildApiKeysSection(),
            const SizedBox(height: 32),
            _buildNotificationsSection(),
            const SizedBox(height: 32),
            _buildSupportSection(),
            const SizedBox(height: 120),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back,
          color: AppColors.textPrimary,
          size: 24,
        ),
      ),
      title: const Text(
        'Settings',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _buildSettingsItem(
          icon: Icons.person_outline,
          title: 'Profile',
          subtitle: 'Manage your profile',
          onTap: () => _showComingSoon('Profile management'),
          showAvatar: true,
        ),
        _buildSettingsItem(
          icon: Icons.email_outlined,
          title: 'Email',
          subtitle: 'Change your email',
          onTap: () => _showComingSoon('Email management'),
        ),
        _buildSettingsItem(
          icon: Icons.lock_outline,
          title: 'Password',
          subtitle: 'Change your password',
          onTap: () => _showComingSoon('Password management'),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preferences',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _buildSettingsItem(
          icon: Icons.language_outlined,
          title: 'Language',
          subtitle: 'Choose your preferred language',
          onTap: () => _showLanguageSelector(),
          trailing: const Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
            size: 20,
          ),
        ),
        _buildSettingsItem(
          icon: Icons.dark_mode_outlined,
          title: 'Dark Mode',
          subtitle: 'Enable dark mode for a\ncomfortable viewing experience',
          trailing: Switch(
            value: _darkMode,
            onChanged: (value) {
              setState(() {
                _darkMode = value;
              });
              _showComingSoon('Dark mode');
            },
            activeColor: AppColors.primaryBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildApiKeysSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'API Configuration',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primaryBlue.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.key,
                    color: AppColors.primaryBlue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'AI Provider Keys',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Configure your API keys to enable AI-powered learning features',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildApiKeyField(
          label: 'OpenAI API Key',
          controller: _openaiController,
          obscureText: _obscureOpenAI,
          onVisibilityToggle: () {
            setState(() {
              _obscureOpenAI = !_obscureOpenAI;
            });
          },
        ),
        const SizedBox(height: 12),
        _buildApiKeyField(
          label: 'Google Gemini API Key',
          controller: _geminiController,
          obscureText: _obscureGemini,
          onVisibilityToggle: () {
            setState(() {
              _obscureGemini = !_obscureGemini;
            });
          },
        ),
        const SizedBox(height: 12),
        _buildApiKeyField(
          label: 'Anthropic Claude API Key',
          controller: _anthropicController,
          obscureText: _obscureAnthropic,
          onVisibilityToggle: () {
            setState(() {
              _obscureAnthropic = !_obscureAnthropic;
            });
          },
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoadingKeys ? null : _saveApiKeys,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoadingKeys
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Save API Keys',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _buildSettingsItem(
          icon: Icons.notifications_outlined,
          title: 'App Notifications',
          subtitle: 'Receive notifications for new\ncontent and updates',
          trailing: Switch(
            value: _appNotifications,
            onChanged: (value) {
              setState(() {
                _appNotifications = value;
              });
            },
            activeColor: AppColors.primaryBlue,
          ),
        ),
        _buildSettingsItem(
          icon: Icons.email_outlined,
          title: 'Email Notifications',
          subtitle: 'Get email notifications for\nimportant updates',
          trailing: Switch(
            value: _emailNotifications,
            onChanged: (value) {
              setState(() {
                _emailNotifications = value;
              });
            },
            activeColor: AppColors.primaryBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Support',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _buildSettingsItem(
          icon: Icons.help_outline,
          title: 'Help Center',
          subtitle: 'Get help and support',
          onTap: () => _showComingSoon('Help Center'),
          trailing: const Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
            size: 20,
          ),
        ),
        _buildSettingsItem(
          icon: Icons.chat_bubble_outline,
          title: 'Contact Us',
          subtitle: 'Contact us for assistance',
          onTap: () => _showComingSoon('Contact support'),
          trailing: const Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: 2, // Settings tab is selected
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context); // Go back to home
          } else if (index == 1) {
            // Progress - coming soon
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Progress tracking coming soon!'),
                backgroundColor: AppColors.primaryBlue,
                duration: Duration(seconds: 2),
              ),
            );
          }
          // Settings tab (index 2) - already here
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF007AFF),
        unselectedItemColor: const Color(0xFF888888),
        elevation: 0,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up_outlined),
            activeIcon: Icon(Icons.trending_up),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
    bool showAvatar = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            if (showAvatar)
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.orange.withOpacity(0.2),
                backgroundImage: const AssetImage('assets/images/profile_placeholder.png'), // You can add a placeholder image
                child: const Icon(
                  Icons.person,
                  color: Colors.orange,
                  size: 24,
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildApiKeyField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onVisibilityToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: 'Paste your $label here',
            hintStyle: const TextStyle(
              color: AppColors.textLight,
              fontSize: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primaryBlue),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            suffixIcon: IconButton(
              onPressed: onVisibilityToggle,
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
          ),
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Language',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            ...['English', 'Spanish', 'French', 'German', 'Chinese'].map(
              (language) => ListTile(
                title: Text(language),
                trailing: _selectedLanguage == language
                    ? const Icon(Icons.check, color: AppColors.primaryBlue)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedLanguage = language;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon!'),
        backgroundColor: AppColors.primaryBlue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}