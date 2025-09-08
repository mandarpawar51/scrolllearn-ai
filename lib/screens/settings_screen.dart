import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/localization_service.dart';
import '../repositories/secure_storage_repository.dart';
import '../utils/app_colors.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../models/ai_provider.dart'; // Added
import '../providers/ai_provider.dart'; // Added

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
  final _openrouterController = TextEditingController();
  
  // Settings state
  bool _appNotifications = true;
  bool _emailNotifications = false;
  
  // API Keys visibility
  bool _obscureOpenAI = true;
  bool _obscureGemini = true;
  bool _obscureAnthropic = true;
  bool _obscureOpenRouter = true;
  bool _isLoadingKeys = false;

  AIProvider? _selectedAIProvider; // Added

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadExistingKeys();
    // Initialize _selectedAIProvider from AIProviderManager
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final aiProviderManager = Provider.of<AIProviderManager>(context, listen: false);
      setState(() {
        _selectedAIProvider = aiProviderManager.selectedProvider;
      });
    });
  }

  @override
  void dispose() {
    _openaiController.dispose();
    _geminiController.dispose();
    _anthropicController.dispose();
    _openrouterController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    // Load user preferences from storage
    setState(() {
      _appNotifications = true;
      _emailNotifications = false;
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
      final openrouterKey = await _secureStorage.getOpenRouterKey();

      _openaiController.text = openaiKey ?? '';
      _geminiController.text = geminiKey ?? '';
      _anthropicController.text = anthropicKey ?? '';
      _openrouterController.text = openrouterKey ?? '';
    } catch (e) {
      _showErrorSnackBar(AppLocalizations.of(context)?.apiKeysLoadFailed(e.toString()) ?? 'Failed to load API keys: $e');
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
      if (_openrouterController.text.isNotEmpty) {
        await _secureStorage.setOpenRouterKey(_openrouterController.text.trim());
      }

      // Removed SnackBar as per user request
    } catch (e) {
      _showErrorSnackBar(AppLocalizations.of(context)?.apiKeysSaveFailed(e.toString()) ?? 'Failed to save API keys: $e');
    } finally {
      setState(() {
        _isLoadingKeys = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildAccountSection(),
            const SizedBox(height: 32),
            _buildPreferencesSection(themeProvider, languageProvider),
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
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          isRTL ? Icons.arrow_forward : Icons.arrow_back,
          color: Theme.of(context).appBarTheme.foregroundColor,
          size: 24,
        ),
      ),
      title: Text(
        AppLocalizations.of(context)?.settings ?? 'Settings',
        style: TextStyle(
          color: Theme.of(context).appBarTheme.foregroundColor,
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
        Text(
          AppLocalizations.of(context)?.account ?? 'Account',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        const SizedBox(height: 16),
        _buildSettingsItem(
          icon: Icons.person_outline,
          title: AppLocalizations.of(context)?.profile ?? 'Profile',
          subtitle: AppLocalizations.of(context)?.manageProfile ?? 'Manage your profile',
          onTap: () => _showComingSoon('Profile management'),
          showAvatar: true,
        ),
        _buildSettingsItem(
          icon: Icons.email_outlined,
          title: AppLocalizations.of(context)?.email ?? 'Email',
          subtitle: AppLocalizations.of(context)?.changeEmail ?? 'Change your email',
          onTap: () => _showComingSoon('Email management'),
        ),
        _buildSettingsItem(
          icon: Icons.lock_outline,
          title: AppLocalizations.of(context)?.password ?? 'Password',
          subtitle: AppLocalizations.of(context)?.changePassword ?? 'Change your password',
          onTap: () => _showComingSoon('Password management'),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(ThemeProvider themeProvider, LanguageProvider languageProvider) {
    final currentLanguage = LanguageProvider.supportedLanguages.firstWhere(
      (lang) => lang['code'] == languageProvider.currentLocale.languageCode,
      orElse: () => LanguageProvider.supportedLanguages.first,
    );
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)?.preferences ?? 'Preferences',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        const SizedBox(height: 16),
        _buildSettingsItem(
          icon: Icons.language_outlined,
          title: AppLocalizations.of(context)?.language ?? 'Language',
          subtitle: AppLocalizations.of(context)?.currentLanguage('${currentLanguage['nativeName']} (${currentLanguage['name']})') ?? 'Current: ${currentLanguage['nativeName']} (${currentLanguage['name']})',
          onTap: () => _showLanguageSelector(languageProvider),
          trailing: Icon(
            Directionality.of(context) == TextDirection.rtl 
                ? Icons.chevron_left 
                : Icons.chevron_right,
            color: AppColors.textSecondary,
            size: 20,
          ),
        ),
        _buildSettingsItem(
          icon: Icons.dark_mode_outlined,
          title: AppLocalizations.of(context)?.darkMode ?? 'Dark Mode',
          subtitle: AppLocalizations.of(context)?.darkModeDescription ?? 'Enable dark mode for a\ncomfortable viewing experience',
          trailing: Switch(
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme();
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
        Text(
          AppLocalizations.of(context)?.apiConfiguration ?? 'API Configuration',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.titleLarge?.color,
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
                  Text(
                    AppLocalizations.of(context)?.aiProviderKeys ?? 'AI Provider Keys',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)?.apiKeysDescription ?? 'Configure your API keys to enable AI-powered learning features',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16), // Added
              // AI Provider Selection Dropdown
              DropdownButtonFormField<AIProvider>( // Added
                value: _selectedAIProvider,
                decoration: InputDecoration(
                  labelText: 'Select AI Provider',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                ),
                items: AIProvider.values.map((provider) {
                  return DropdownMenuItem(
                    value: provider,
                    child: Text(provider.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (AIProvider? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedAIProvider = newValue;
                    });
                    Provider.of<AIProviderManager>(context, listen: false).setSelectedProvider(newValue);
                  }
                },
              ),
              const SizedBox(height: 16), // Added
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildApiKeyField(
          label: AppLocalizations.of(context)?.openaiApiKey ?? 'OpenAI API Key',
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
          label: AppLocalizations.of(context)?.geminiApiKey ?? 'Google Gemini API Key',
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
          label: AppLocalizations.of(context)?.anthropicApiKey ?? 'Anthropic Claude API Key',
          controller: _anthropicController,
          obscureText: _obscureAnthropic,
          onVisibilityToggle: () {
            setState(() {
              _obscureAnthropic = !_obscureAnthropic;
            });
          },
        ),
        const SizedBox(height: 12),
        _buildApiKeyField(
          label: AppLocalizations.of(context)?.openrouterApiKey ?? 'OpenRouter API Key',
          controller: _openrouterController,
          obscureText: _obscureOpenRouter,
          onVisibilityToggle: () {
            setState(() {
              _obscureOpenRouter = !_obscureOpenRouter;
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
                : Text(
                    AppLocalizations.of(context)?.saveApiKeys ?? 'Save API Keys',
                    style: const TextStyle(
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
        Text(
          AppLocalizations.of(context)?.notifications ?? 'Notifications',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        const SizedBox(height: 16),
        _buildSettingsItem(
          icon: Icons.notifications_outlined,
          title: AppLocalizations.of(context)?.appNotifications ?? 'App Notifications',
          subtitle: AppLocalizations.of(context)?.appNotificationsDescription ?? 'Receive notifications for new\ncontent and updates',
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
          title: AppLocalizations.of(context)?.emailNotifications ?? 'Email Notifications',
          subtitle: AppLocalizations.of(context)?.emailNotificationsDescription ?? 'Get email notifications for\nimportant updates',
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
        Text(
          AppLocalizations.of(context)?.support ?? 'Support',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        const SizedBox(height: 16),
        _buildSettingsItem(
          icon: Icons.help_outline,
          title: AppLocalizations.of(context)?.helpCenter ?? 'Help Center',
          subtitle: AppLocalizations.of(context)?.getHelp ?? 'Get help and support',
          onTap: () => _showComingSoon('Help Center'),
          trailing: Icon(
            Directionality.of(context) == TextDirection.rtl 
                ? Icons.chevron_left 
                : Icons.chevron_right,
            color: AppColors.textSecondary,
            size: 20,
          ),
        ),
        _buildSettingsItem(
          icon: Icons.chat_bubble_outline,
          title: AppLocalizations.of(context)?.contactUs ?? 'Contact Us',
          subtitle: AppLocalizations.of(context)?.contactSupport ?? 'Contact us for assistance',
          onTap: () => _showComingSoon('Contact support'),
          trailing: Icon(
            Directionality.of(context) == TextDirection.rtl 
                ? Icons.chevron_left 
                : Icons.chevron_right,
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
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor ?? Theme.of(context).cardColor,
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
            // Removed SnackBar as per user request
          }
          // Settings tab (index 2) - already here
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor ?? Theme.of(context).cardColor,
        selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor ?? const Color(0xFF007AFF),
        unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor ?? const Color(0xFF888888),
        elevation: 0,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: AppLocalizations.of(context)?.home ?? 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up_outlined),
            activeIcon: Icon(Icons.trending_up),
            label: AppLocalizations.of(context)?.progress ?? 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: AppLocalizations.of(context)?.settings ?? 'Settings',
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
                // backgroundImage: const AssetImage('assets/images/profile_placeholder.png'), // You can add a placeholder image
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
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.grey[800] 
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            if (controller.text.isNotEmpty)
              TextButton.icon(
                onPressed: () => _deleteApiKey(controller, label),
                icon: const Icon(Icons.delete_outline, size: 16, color: AppColors.error),
                label: const Text('Delete', style: TextStyle(color: AppColors.error, fontSize: 12)),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                ),
              ),
          ],
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
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (controller.text.isNotEmpty)
                  IconButton(
                    onPressed: () => _clearApiKey(controller),
                    icon: const Icon(Icons.clear, color: AppColors.textSecondary, size: 18),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                IconButton(
                  onPressed: onVisibilityToggle,
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
          onChanged: (value) {
            setState(() {}); // Refresh to show/hide delete button
          },
        ),
      ],
    );
  }

  void _deleteApiKey(TextEditingController controller, String label) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete $label'),
        content: Text('Are you sure you want to delete this API key? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Clear from controller
              controller.clear();
              
              // Clear from secure storage
              if (label.contains('OpenAI')) {
                await _secureStorage.setOpenAIKey('');
              } else if (label.contains('Gemini')) {
                await _secureStorage.setGeminiKey('');
              } else if (label.contains('Anthropic')) {
                await _secureStorage.setAnthropicKey('');
              } else if (label.contains('OpenRouter')) {
                await _secureStorage.setOpenRouterKey('');
              }
              
              setState(() {});
              Navigator.pop(context);
              
              // Removed SnackBar as per user request
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _clearApiKey(TextEditingController controller) {
    controller.clear();
    setState(() {});
  }

  void _showLanguageSelector(LanguageProvider languageProvider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)?.selectLanguage ?? 'Select Language',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: LanguageProvider.supportedLanguages.length,
                itemBuilder: (context, index) {
                  final language = LanguageProvider.supportedLanguages[index];
                  final isSelected = language['code'] == languageProvider.currentLocale.languageCode;
                  
                  return ListTile(
                    title: Text(
                      language['name']!,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      language['nativeName']!,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: AppColors.primaryBlue)
                        : null,
                    onTap: () {
                      languageProvider.changeLanguage(language['code']!);
                      Navigator.pop(context);
                      // Removed SnackBar as per user request
                    },
                  );
                },
              ),
            ),
          ],
        ),
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

  void _showComingSoon(String featureName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$featureName is coming soon!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}