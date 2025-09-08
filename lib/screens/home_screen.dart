import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../blocs/gesture_bloc.dart';
import '../models/subject_type.dart';
import '../models/problem.dart';
import '../utils/app_colors.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../services/localization_service.dart';
import 'settings_screen.dart';
import '../providers/ai_provider.dart';
import '../models/ai_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentTabIndex = 0;
  final TextEditingController _answerController = TextEditingController();
  SubjectType _currentSubject = SubjectType.math;
  Problem? _currentProblem;
  bool _showSolution = false;
  bool _isLoadingQuestion = false;
  bool _isSolutionDisplayedInAnswerBox = false;
  
  // Tutorial animation controllers
  late AnimationController _tutorialController;
  late AnimationController _fingerController;
  late Animation<Offset> _fingerAnimation;
  late Animation<double> _fadeAnimation;
  bool _showTutorial = true;
  bool _hasUserSwiped = false;

  @override
  void initState() {
    super.initState();
    _initializeTutorialAnimations();
    _startTutorial();
    _loadInitialQuestion();
  }

  Future<void> _loadInitialQuestion() async {
    await _getQuestionForSubject(_currentSubject);
  }

  @override
  void dispose() {
    _answerController.dispose();
    _tutorialController.dispose();
    _fingerController.dispose();
    super.dispose();
  }

  void _initializeTutorialAnimations() {
    _tutorialController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _fingerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fingerAnimation = Tween<Offset>(
      begin: const Offset(0.5, 0.5),
      end: const Offset(0.1, 0.5),
    ).animate(CurvedAnimation(
      parent: _fingerController,
      curve: Curves.easeInOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _tutorialController,
      curve: const Interval(0.0, 0.3),
    ));
  }

  void _startTutorial() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted && _showTutorial) {
        _tutorialController.forward();
        _repeatFingerAnimation();
      }
    });
  }

  void _repeatFingerAnimation() {
    _fingerController.forward().then((_) {
      if (mounted && _showTutorial && !_hasUserSwiped) {
        _fingerController.reset();
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && _showTutorial && !_hasUserSwiped) {
            _repeatFingerAnimation();
          }
        });
      }
    });
  }

  void _hideTutorial() {
    if (_showTutorial) {
      setState(() {
        _showTutorial = false;
        _hasUserSwiped = true;
      });
      _tutorialController.reverse();
      _fingerController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GestureBloc(),
      child: WillPopScope(
        onWillPop: () async {
          // Prevent back navigation from home screen
          return false;
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: BlocListener<GestureBloc, GestureBlocState>(
              listener: (context, state) {
                if (state is GestureRecognized) {
                  _switchSubject(state.result.subject);
                }
              },
              child: _buildContent(),
            ),
          ),
          bottomNavigationBar: _buildBottomNavigation(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return BlocBuilder<GestureBloc, GestureBlocState>(
      builder: (context, state) {
        return GestureDetector(
          onPanStart: (details) {
            _hideTutorial();
            context.read<GestureBloc>().add(
              GesturePanStart(details.localPosition),
            );
          },
          onPanUpdate: (details) {
            context.read<GestureBloc>().add(
              GesturePanUpdate(details.localPosition, details.delta),
            );
          },
          onPanEnd: (details) {
            context.read<GestureBloc>().add(
              GesturePanEnd(details.velocity.pixelsPerSecond),
            );
          },
          child: Stack(
            children: [
              Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: _buildProblemContent(),
                  ),
                ],
              ),
              // Tutorial overlay
              if (_showTutorial) _buildTutorialOverlay(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 20, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _currentSubject.getLocalizedName(context),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          IconButton(
            onPressed: () => _showSubjectMenu(),
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
              size: 24,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildProblemContent() {
    return Container(
      width: double.infinity,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Problem illustration/diagram area
              _buildProblemIllustration(),
              
              const SizedBox(height: 32),
              
              // Question text or loading indicator
              _isLoadingQuestion
                  ? Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(color: AppColors.primaryBlue),
                          const SizedBox(height: 16),
                          Text(
                            'Generating ${_currentSubject.getLocalizedName(context)} question...',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    )
                  : _currentProblem != null
                      ? Text(
                          _currentProblem!.question,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.titleLarge?.color,
                            height: 1.4,
                          ),
                        )
                      : Text(
                          _getFallbackQuestionForSubject(_currentSubject),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.titleLarge?.color,
                          ),
                        ),
              
              const SizedBox(height: 12),
              
              Text(
                'Enter your answer below:',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Answer input field
              _buildAnswerInput(),
              
              const SizedBox(height: 24),
              
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Generate new question button
                  ElevatedButton.icon(
                    onPressed: _isLoadingQuestion ? null : () => _getQuestionForSubject(_currentSubject),
                    icon: _isLoadingQuestion 
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.refresh, size: 18),
                    label: Text(_isLoadingQuestion ? 'Generating...' : 'New Question'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentSubject.color.withOpacity(0.1),
                      foregroundColor: _currentSubject.color,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                  ),
                  
                  // Show solution button
                  _buildShowSolutionButton(),
                ],
              ),
              
              // Solution display
              // Solution display removed as per user request
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProblemIllustration() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: _currentSubject == SubjectType.math
          ? _buildMathDiagram()
          : _buildSubjectPlaceholder(),
    );
  }

  Widget _buildMathDiagram() {
    return Stack(
      children: [
        CustomPaint(
          painter: MathDiagramPainter(),
          size: const Size(double.infinity, 200),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Q₁: f(x) = cos(x)² - (sin²(x) + 1)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                '= f = -1(x)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFD1D5DB)),
            ),
            child: const Text(
              'Q1',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _currentSubject.icon,
            size: 48,
            color: _currentSubject.color,
          ),
          const SizedBox(height: 12),
          Text(
            '${_currentSubject.getLocalizedName(context)} Problem',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: _currentSubject.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerInput() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: TextField(
        controller: _answerController,
        readOnly: _isSolutionDisplayedInAnswerBox, // Make read-only when solution is displayed
        decoration: InputDecoration(
          hintText: 'Answer',
          hintStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        style: TextStyle(
          fontSize: 16,
          color: _isSolutionDisplayedInAnswerBox ? AppColors.success : Theme.of(context).textTheme.bodyLarge?.color,
        ),
        onChanged: (value) {
          setState(() {
            _showSolution = false;
            _isSolutionDisplayedInAnswerBox = false; // Clear color when user types
          });
        },
      ),
    );
  }

  Widget _buildShowSolutionButton() {
    return ElevatedButton.icon(
      onPressed: _showSolutionAction,
      icon: Icon(_showSolution ? Icons.visibility_off : Icons.visibility, size: 18),
      label: Text(_showSolution ? 'Hide Solution' : 'Show Solution'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF007AFF),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    );
  }

  Widget _buildSolutionDisplay() {
    final solutionText = _currentProblem?.solution ?? _getSolutionForCurrentProblem();
    
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.success.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: AppColors.success,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Solution:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            solutionText,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyLarge?.color,
              height: 1.4,
            ),
          ),
          // Removed explanation section as per user request to only show main answer
        ],
      ),
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
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
          _handleBottomNavigation(index);
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

  // Action methods
  Future<void> _switchSubject(SubjectType newSubject) async {
    setState(() {
      _isLoadingQuestion = true;
      _currentSubject = newSubject;
      _currentProblem = null;
      _answerController.clear();
      _showSolution = false;
    });

    await _getQuestionForSubject(newSubject);

    // Show subject switch feedback
    // Removed SnackBar as per user request
  }

  void _showSubjectMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Subject',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 20),
            ...SubjectType.values.where((s) => s != SubjectType.none).map((subject) => ListTile(
              leading: Icon(subject.icon, color: subject.color),
              title: Text(
                subject.getLocalizedName(context),
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _switchSubject(subject);
              },
            )),
          ],
        ),
      ),
    );
  }

    void _showSolutionAction() {
    setState(() {
      _showSolution = !_showSolution;
      if (_showSolution) { // If showing solution, populate answer box
        final solutionText = _currentProblem?.solution ?? _getSolutionForCurrentProblem();
        _answerController.text = solutionText;
        _isSolutionDisplayedInAnswerBox = true; // Set to true when solution is shown
      } else { // If hiding solution, clear answer box
        _answerController.clear();
        _isSolutionDisplayedInAnswerBox = false; // Set to false when solution is hidden
      }
    });
  }

  void _handleBottomNavigation(int index) {
    switch (index) {
      case 0:
        // Home - already here
        break;
      case 1:
        // Progress - coming soon
        setState(() {
          _currentTabIndex = 0; // Reset to home
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Progress tracking coming soon!'),
            backgroundColor: AppColors.primaryBlue,
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case 2:
        // Settings
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SettingsScreen(),
          ),
        ).then((_) {
          // Reset to home tab when returning from settings
          setState(() {
            _currentTabIndex = 0;
          });
        });
        break;
    }
  }

  Future<void> _getQuestionForSubject(SubjectType subject) async {
    final aiProviderManager = Provider.of<AIProviderManager>(context, listen: false);
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    try {
      // Get current language for AI generation
      String currentLanguage = _getLanguageName(languageProvider.currentLocale.languageCode);
      
      // Use the improved subject-specific question generation with language support
      final questionText = await aiProviderManager.generateSubjectQuestion(subject, language: currentLanguage);
      
      // Create a Problem object from the AI response
      final problem = Problem.fromAIResponse(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        subject: subject,
        aiResponse: questionText,
      );
      
      setState(() {
        _currentProblem = problem;
        _isLoadingQuestion = false;
      });
      
    } catch (e) {
      debugPrint('Error generating question with AI: $e');
      
      // Show more specific error messages to the user
      String errorMessage = 'Failed to generate question';
      if (e.toString().contains('API key not found') || e.toString().contains('No AI provider configured')) {
        errorMessage = 'Please configure an API key in settings to generate questions';
      } else if (e.toString().contains('Invalid API key')) {
        errorMessage = 'Invalid API key. Please check your settings';
      } else if (e.toString().contains('Rate limit')) {
        errorMessage = 'Rate limit exceeded. Please try again in a moment';
      } else if (e.toString().contains('timeout') || e.toString().contains('connection')) {
        errorMessage = 'Connection error. Please check your internet connection';
      }
      
      // Show error to user but don't throw - use fallback instead
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppColors.warning,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Settings',
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
          ),
        );
      }
      
      // Create fallback problem
      final fallbackProblem = Problem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        subject: subject,
        question: _getFallbackQuestionForSubject(subject),
        solution: _getSolutionForCurrentProblem(),
      );
      
      setState(() {
        _currentProblem = fallbackProblem;
        _isLoadingQuestion = false;
      });
    }
  }

  String _getFallbackQuestionForSubject(SubjectType subject) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) {
      // Fallback to English if localization is not available
      switch (subject) {
        case SubjectType.math:
          return 'Solve for x: 2x + 5 = 15';
        case SubjectType.science:
          return 'What is the chemical formula for water?';
        case SubjectType.history:
          return 'In which year did World War II end?';
        case SubjectType.geography:
          return 'What is the capital of Australia?';
        case SubjectType.none:
          return 'Please select a subject.';
      }
    }
    switch (subject) {
      case SubjectType.math:
        return localizations.solveForX;
      case SubjectType.science:
        return localizations.chemicalFormula;
      case SubjectType.history:
        return localizations.worldWarEnd;
      case SubjectType.geography:
        return localizations.australiaCapital;
      case SubjectType.none:
        return 'Please select a subject.';
    }
  }

  String _getSolutionForCurrentProblem() {
    switch (_currentSubject) {
      case SubjectType.math:
        return '2x + 5 = 15\n2x = 15 - 5\n2x = 10\nx = 5';
      case SubjectType.science:
        return 'H₂O - Water consists of two hydrogen atoms and one oxygen atom.';
      case SubjectType.history:
        return '1945 - World War II ended on September 2, 1945.';
      case SubjectType.geography:
        return 'Canberra - The capital of Australia is Canberra, not Sydney or Melbourne.';
      case SubjectType.none:
        return 'No solution available for this subject.';
    }
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

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'hi':
        return 'Hindi';
      case 'bn':
        return 'Bengali';
      case 'te':
        return 'Telugu';
      case 'mr':
        return 'Marathi';
      case 'ta':
        return 'Tamil';
      case 'gu':
        return 'Gujarati';
      case 'kn':
        return 'Kannada';
      case 'ml':
        return 'Malayalam';
      case 'pa':
        return 'Punjabi';
      case 'or':
        return 'Odia';
      case 'as':
        return 'Assamese';
      case 'ur':
        return 'Urdu';
      default:
        return 'English';
    }
  }

  Widget _buildTutorialOverlay() {
    return AnimatedBuilder(
      animation: _tutorialController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            color: Colors.black.withOpacity(0.7),
            child: Stack(
              children: [
                // Tutorial text
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.3,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)?.swipeToSwitch ?? 'Swipe to Switch Subjects',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)?.swipeInstructions ?? 'Swipe left or right to explore\ndifferent subjects',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      // Subject indicators
                      _buildSubjectIndicators(),
                    ],
                  ),
                ),
                // Animated finger
                AnimatedBuilder(
                  animation: _fingerAnimation,
                  builder: (context, child) {
                    return Positioned(
                      left: MediaQuery.of(context).size.width * _fingerAnimation.value.dx,
                      top: MediaQuery.of(context).size.height * _fingerAnimation.value.dy,
                      child: _buildAnimatedFinger(),
                    );
                  },
                ),
                // Skip button
                Positioned(
                  top: 50,
                  right: 20,
                  child: TextButton(
                    onPressed: _hideTutorial,
                    child: Text(
                      AppLocalizations.of(context)?.skip ?? 'Skip',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedFinger() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(
        Icons.touch_app,
        color: Color(0xFF007AFF),
        size: 30,
      ),
    );
  }

  Widget _buildSubjectIndicators() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: SubjectType.values.where((s) => s != SubjectType.none).map((subject) {
        final isActive = subject == _currentSubject;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? subject.color.withOpacity(0.8) : Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isActive ? subject.color : Colors.white.withOpacity(0.5),
              width: 2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                subject.icon,
                color: isActive ? Colors.white : Colors.white70,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                subject.getLocalizedName(context),
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// Custom painter for math diagram
class MathDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD1D5DB)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Position the coordinate system in the right side
    final center = Offset(size.width * 0.72, size.height * 0.6);
    
    // Draw coordinate axes
    canvas.drawLine(
      Offset(center.dx - 40, center.dy),
      Offset(center.dx + 40, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - 40),
      Offset(center.dx, center.dy + 40),
      paint,
    );

    // Draw grid lines
    paint.color = const Color(0xFFE5E7EB);
    paint.strokeWidth = 0.5;
    for (int i = -2; i <= 2; i++) {
      if (i != 0) {
        canvas.drawLine(
          Offset(center.dx + i * 12, center.dy - 40),
          Offset(center.dx + i * 12, center.dy + 40),
          paint,
        );
        canvas.drawLine(
          Offset(center.dx - 40, center.dy + i * 12),
          Offset(center.dx + 40, center.dy + i * 12),
          paint,
        );
      }
    }

    // Draw axis labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    
    // X-axis labels
    textPainter.text = const TextSpan(
      text: '2',
      style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 9),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx + 24, center.dy + 4));
    
    // Y-axis labels  
    textPainter.text = const TextSpan(
      text: '2',
      style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 9),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx + 4, center.dy - 24));

    // Draw some additional mathematical elements
    paint.color = const Color(0xFF6B7280);
    paint.strokeWidth = 1.0;
    
    // Draw some tick marks
    for (int i = -1; i <= 1; i++) {
      if (i != 0) {
        canvas.drawLine(
          Offset(center.dx + i * 24, center.dy - 2),
          Offset(center.dx + i * 24, center.dy + 2),
          paint,
        );
        canvas.drawLine(
          Offset(center.dx - 2, center.dy + i * 24),
          Offset(center.dx + 2, center.dy + i * 24),
          paint,
        );
      }
    }

    // Draw arrows on axes
    paint.strokeWidth = 1.5;
    // X-axis arrow
    canvas.drawLine(
      Offset(center.dx + 40, center.dy),
      Offset(center.dx + 35, center.dy - 3),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + 40, center.dy),
      Offset(center.dx + 35, center.dy + 3),
      paint,
    );
    
    // Y-axis arrow
    canvas.drawLine(
      Offset(center.dx, center.dy - 40),
      Offset(center.dx - 3, center.dy - 35),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - 40),
      Offset(center.dx + 3, center.dy - 35),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}