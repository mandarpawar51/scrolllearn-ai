import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/subject_type.dart';
import '../models/problem.dart';
import '../utils/app_colors.dart';

import '../providers/language_provider.dart';

import 'settings_screen.dart';
import '../providers/ai_provider.dart';
import '../widgets/question_skeleton_loader.dart';


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

  // Gesture tracking variables
  Offset? _startPosition;
  static const double _minSwipeDistance = 100.0;

  @override
  void initState() {
    super.initState();
    _initializeTutorialAnimations();
    _startTutorial();
    _loadCustomSubjects();
    _loadInitialQuestion();
  }

  Future<void> _loadCustomSubjects() async {
    await SubjectType.loadUserSubjects();
    if (mounted) {
      setState(() {
        // Trigger rebuild to show custom subjects
      });
    }
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
    if (!mounted || !_showTutorial || _hasUserSwiped) return; 
    
    _fingerController.forward().then((_) {
      if (mounted && _showTutorial && !_hasUserSwiped) {
        _fingerController.reset();
        Future.delayed(const Duration(milliseconds: 500), () {
          _repeatFingerAnimation();
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        // Prevent back navigation from home screen
        return;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: _buildContent(),
        ),
        bottomNavigationBar: _buildBottomNavigation(),
      ),
    );
  }

  Widget _buildContent() {
    return GestureDetector(
      onPanStart: (details) {
        _hideTutorial();
        _startPosition = details.localPosition;
      },
      onPanEnd: (details) {
        if (_startPosition != null) {
          final delta = details.localPosition - _startPosition!;
          final distance = delta.distance;
          
          if (distance >= _minSwipeDistance) {
            final direction = _detectGestureDirection(delta);
            if (direction != null) {
              print('Gesture detected: $direction');
              _switchSubject(direction.subject);
            }
          }
          
          _startPosition = null;
        }
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
  }

  GestureDirection? _detectGestureDirection(Offset delta) {
    final absX = delta.dx.abs();
    final absY = delta.dy.abs();
    
    if (absY > absX) {
      // Vertical gesture
      return delta.dy > 0 ? GestureDirection.down : GestureDirection.up;
    } else {
      // Horizontal gesture
      return delta.dx > 0 ? GestureDirection.right : GestureDirection.left;
    }
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
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3CD),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: Color(0xFFFFB800),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '3',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFB8860B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: _showSubjectMenu,
                icon: Icon(
                  Icons.menu,
                  color: Theme.of(context).iconTheme.color,
                  size: 24,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
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
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            
            // Question text or loading indicator
            SizedBox(
              height: 180, // Fixed height to prevent layout shifting
              child: _isLoadingQuestion
                ? QuestionSkeletonLoader(subjectName: _currentSubject.getLocalizedName(context))
                : _currentProblem != null
                  ? Text(
                      _currentProblem!.question,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      _getFallbackQuestionForSubject(_currentSubject),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
            ),
            
            const Spacer(flex: 1),
            
            // Always show the answer input section
            Text(
              'Enter your answer below:',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 24),
            
            // Answer input field
            _buildAnswerInput(),
            
            const SizedBox(height: 32),
            
            // Show Solution button
            _buildShowSolutionButton(),
            
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerInput() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _answerController,
        readOnly: _isSolutionDisplayedInAnswerBox,
        decoration: InputDecoration(
          hintText: 'Your Answer',
          hintStyle: TextStyle(
            color: Theme.of(context).hintColor,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: _isSolutionDisplayedInAnswerBox ? const Color(0xFF28A745) : Theme.of(context).textTheme.bodyLarge?.color,
        ),
        onChanged: (value) {
          if (_showSolution || _isSolutionDisplayedInAnswerBox) {
            setState(() {
              _showSolution = false;
              _isSolutionDisplayedInAnswerBox = false;
            });
          }
        },
      ),
    );
  }

  Widget _buildShowSolutionButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: _showSolutionAction,
        icon: Icon(
          _showSolution ? Icons.visibility_off : Icons.remove_red_eye,
          size: 20,
          color: Colors.white,
        ),
        label: Text(
          _showSolution ? 'Hide Solution' : 'Show Solution',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF007AFF),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
      ),
    );
  }

  

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor ?? Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
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
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
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
              // Scrollable subject list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: SubjectType.allSubjects.length,
                  itemBuilder: (context, index) {
                    final subject = SubjectType.allSubjects[index];
                    final isCustomSubject = !['math', 'science', 'history', 'geography'].contains(subject.id);
                    
                    return ListTile(
                      leading: Icon(subject.icon, color: subject.color),
                      title: Text(
                        subject.getLocalizedName(context),
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      trailing: isCustomSubject ? IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          Navigator.pop(context);
                          _showDeleteSubjectConfirmation(subject);
                        },
                      ) : null,
                      onTap: () {
                        Navigator.pop(context);
                        _switchSubject(subject);
                      },
                    );
                  },
                ),
              ),
              // Fixed Add Subject button at bottom
              const Divider(),
              ListTile(
                leading: Icon(Icons.add, color: Theme.of(context).iconTheme.color),
                title: Text(
                  'Add Subject',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showAddSubjectDialog();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteSubjectConfirmation(SubjectType subject) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Subject'),
          content: Text(
            'Are you sure you want to delete "${subject.displayName}"?\n\nThis action cannot be undone.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _deleteSubject(subject);
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteSubject(SubjectType subject) async {
    // Remove from user subjects
    await SubjectType.removeSubject(subject.id);
    
    // If the deleted subject was currently active, switch to math
    if (_currentSubject.id == subject.id) {
      setState(() {
        _currentSubject = SubjectType.math;
      });
      await _getQuestionForSubject(SubjectType.math);
    } else {
      setState(() {
        // Trigger rebuild to update UI
      });
    }
    
    // Show confirmation
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${subject.displayName}" has been deleted'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showAddSubjectDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController nameController = TextEditingController();
        Color selectedColor = Colors.blue;
        IconData selectedIcon = Icons.class_;

        return AlertDialog(
          title: Text('Add New Subject'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Subject Name'),
                    ),
                    SizedBox(height: 20),
                    Text('Select a color'),
                    Wrap(
                      spacing: 10,
                      children: [
                        for (var color in [Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple])
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedColor = color;
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: color,
                              child: selectedColor == color ? Icon(Icons.check, color: Colors.white) : null,
                            ),
                          )
                      ],
                    ),
                    SizedBox(height: 20),
                    Text('Select an icon'),
                    Wrap(
                      spacing: 10,
                      children: [
                        for (var icon in [Icons.class_, Icons.book, Icons.translate, Icons.computer, Icons.code])
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIcon = icon;
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: selectedIcon == icon ? Colors.blue.withOpacity(0.3) : Colors.transparent,
                              child: Icon(icon, color: selectedIcon == icon ? Colors.blue : Colors.grey),
                            ),
                          )
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  final newSubject = SubjectType(
                    id: nameController.text.toLowerCase().replaceAll(' ', '_'),
                    displayName: nameController.text,
                    icon: selectedIcon,
                    color: selectedColor,
                  );
                  await SubjectType.addSubject(newSubject);
                  setState(() {
                    _currentSubject = newSubject;
                  });
                  Navigator.of(context).pop();
                  // Load a question for the new subject
                  await _getQuestionForSubject(newSubject);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
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

  

  String _getFallbackQuestionForSubject(SubjectType subject) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) {
      // Fallback to English if localization is not available
      switch (subject.id) {
        case 'math':
          return 'Solve for x: 2x + 5 = 15';
        case 'science':
          return 'What is the chemical formula for water?';
        case 'history':
          return 'In which year did World War II end?';
        case 'geography':
          return 'What is the capital of Australia?';
        default:
          return 'What is a key concept in ${subject.displayName}?';
      }
    }
    switch (subject.id) {
      case 'math':
        return localizations.solveForX;
      case 'science':
        return localizations.chemicalFormula;
      case 'history':
        return localizations.worldWarEnd;
      case 'geography':
        return localizations.australiaCapital;
      default:
        return 'What is a key concept in ${subject.displayName}?';
    }
  }

  String _getSolutionForCurrentProblem() {
    switch (_currentSubject.id) {
      case 'math':
        return '2x + 5 = 15\n2x = 15 - 5\n2x = 10\nx = 5';
      case 'science':
        return 'H₂O - Water consists of two hydrogen atoms and one oxygen atom.';
      case 'history':
        return '1945 - World War II ended on September 2, 1945.';
      case 'geography':
        return 'Canberra - The capital of Australia is Canberra, not Sydney or Melbourne.';
      default:
        return 'This depends on the specific concepts and principles of ${_currentSubject.displayName}.';
    }
  }

  Future<void> _getQuestionForSubject(SubjectType subject) async {
    final aiProviderManager = Provider.of<AIProviderManager>(context, listen: false);
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    setState(() {
      _isLoadingQuestion = true;
    });

    try {
      String currentLanguage = _getLanguageName(languageProvider.currentLocale.languageCode);
      final questionText = await aiProviderManager.generateSubjectQuestion(subject, language: currentLanguage);
      
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
            color: Colors.black.withAlpha(179),
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
        color: Colors.white.withAlpha(230),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(77),
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
      children: SubjectType.allSubjects.map((subject) {
        final isActive = subject == _currentSubject;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? subject.color.withAlpha(204) : Colors.white.withAlpha(51),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isActive ? subject.color : Colors.white.withAlpha(128),
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