import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../utils/language_debug_helper.dart';

/// Debug screen for testing language switching
/// Only available in debug mode
class LanguageTestScreen extends StatelessWidget {
  const LanguageTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Test Screen'),
        backgroundColor: Colors.blue,
      ),
      body: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Language',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Code: ${languageProvider.currentLocale.languageCode}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          'Country: ${languageProvider.currentLocale.countryCode}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          'RTL: ${LanguageDebugHelper.isRTLLanguage(languageProvider.currentLocale.languageCode)}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Test All Languages',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    LanguageDebugHelper.testAllLanguages(languageProvider);
                  },
                  child: const Text('Run All Language Tests'),
                ),
                const SizedBox(height: 16),
                Text(
                  'Available Languages',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: LanguageProvider.supportedLanguages.length,
                    itemBuilder: (context, index) {
                      final language = LanguageProvider.supportedLanguages[index];
                      final code = language['code']!;
                      final name = language['name']!;
                      final nativeName = language['nativeName']!;
                      final isRTL = LanguageDebugHelper.isRTLLanguage(code);
                      final isCurrent = languageProvider.currentLocale.languageCode == code;
                      
                      return Card(
                        color: isCurrent ? Colors.blue.shade50 : null,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isRTL ? Colors.orange : Colors.blue,
                            child: Text(
                              code.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(nativeName),
                              if (isRTL) 
                                const Text(
                                  'RTL Language',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                          trailing: isCurrent 
                              ? const Icon(Icons.check_circle, color: Colors.green)
                              : const Icon(Icons.arrow_forward_ios),
                          onTap: () async {
                            try {
                              await languageProvider.changeLanguage(code);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Switched to $name'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to switch to $name: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          LanguageDebugHelper.logAllSupportedLanguages();
          LanguageDebugHelper.logRTLLanguages();
        },
        child: const Icon(Icons.info),
      ),
    );
  }
}