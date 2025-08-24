import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/subject_type.dart';
import '../utils/app_colors.dart';
import 'home_screen.dart';

class GestureTutorialScreen extends StatefulWidget {
  const GestureTutorialScreen({super.key});

  @override
  State<GestureTutorialScreen> createState() => _GestureTutorialScreenState();
}

class _GestureTutorialScreenState extends State<GestureTutorialScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late AnimationController _gestureAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  int _currentPage = 0;
  bool _isPracticeMode = false;
  Set<GestureDirection> _completedGestures = {};
  GestureDirection? _currentPracticeGesture;
  String? _currentDemoQuestion;
  String? _currentDemoAnswer;
  bool _showDemoQuestion = false;
  bool _showAnswerInput = false;
  bool _showCorrectAnswer = false;
  final TextEditingController _answerController = TextEditingController();
  
  // Sample questions and answers for each subject
  final Map<GestureDirection, List<Map<String, String>>> _sampleQuestions = {
    GestureDirection.down: [
      {"question": "What is 15 × 8?", "answer": "120"},
      {"question": "Solve for x: 2x + 5 = 17", "answer": "x = 6"},
      {"question": "What is the area of a circle with radius 4?", "answer": "50.27 square units (π × 4²)"},
      {"question": "Calculate: 144 ÷ 12 + 7", "answer": "19"},
      {"question": "What is 25% of 80?", "answer": "20"},
    ],
    GestureDirection.up: [
      {"question": "What is the chemical symbol for gold?", "answer": "Au"},
      {"question": "How many bones are in the human body?", "answer": "206 bones"},
      {"question": "What gas do plants absorb during photosynthesis?", "answer": "Carbon dioxide (CO₂)"},
      {"question": "What is the speed of light in a vacuum?", "answer": "299,792,458 meters per second"},
      {"question": "Which planet is closest to the Sun?", "answer": "Mercury"},
    ],
    GestureDirection.right: [
      {"question": "In which year did World War II end?", "answer": "1945"},
      {"question": "Who was the first President of the United States?", "answer": "George Washington"},
      {"question": "Which ancient wonder was located in Alexandria?", "answer": "The Lighthouse of Alexandria"},
      {"question": "What year did the Berlin Wall fall?", "answer": "1989"},
      {"question": "Who painted the Mona Lisa?", "answer": "Leonardo da Vinci"},
    ],
    GestureDirection.left: [
      {"question": "What is the capital of Australia?", "answer": "Canberra"},
      {"question": "Which is the longest river in the world?", "answer": "The Nile River"},
      {"question": "How many continents are there?", "answer": "7 continents"},
      {"question": "What is the smallest country in the world?", "answer": "Vatican City"},
      {"question": "Which mountain range contains Mount Everest?", "answer": "The Himalayas"},
    ],
  };
  
  final List<TutorialStep> _tutorialSteps = [
    TutorialStep(
      title: 'Welcome to ScrollLearn AI',
      description: 'Learn through intuitive gestures! Swipe in different directions to access subjects.',
      gestureDirection: null,
      isInteractive: false,
    ),
    TutorialStep(
      title: 'Swipe Down for Math',
      description: 'Try swiping down in the area below to see a math question generated!',
      gestureDirection: GestureDirection.down,
      isInteractive: true,
    ),
    TutorialStep(
      title: 'Swipe Up for Science',
      description: 'Try swiping up in the area below to see a science question generated!',
      gestureDirection: GestureDirection.up,
      isInteractive: true,
    ),
    TutorialStep(
      title: 'Swipe Right for History',
      description: 'Try swiping right in the area below to see a history question generated!',
      gestureDirection: GestureDirection.right,
      isInteractive: true,
    ),
    TutorialStep(
      title: 'Swipe Left for Geography',
      description: 'Try swiping left in the area below to see a geography question generated!',
      gestureDirection: GestureDirection.left,
      isInteractive: true,
    ),
    TutorialStep(
      title: 'Practice Time!',
      description: 'Now try the gestures yourself. Complete all four directions to continue.',
      gestureDirection: null,
      isInteractive: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _gestureAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
    _startGestureAnimation();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _gestureAnimationController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _startGestureAnimation() {
    _gestureAnimationController.repeat();
  }

  void _nextPage() {
    if (_currentPage < _tutorialSteps.length - 1) {
      setState(() {
        _currentPage++;
        if (_currentPage == _tutorialSteps.length - 1) {
          _isPracticeMode = true;
        }
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _animationController.reset();
      _animationController.forward();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
        if (_currentPage < _tutorialSteps.length - 1) {
          _isPracticeMode = false;
        }
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _animationController.reset();
      _animationController.forward();
    }
  }

  void _handleGesture(GestureDirection direction) {
    if (!_isPracticeMode) return;
    
    HapticFeedback.lightImpact();
    
    // Get a random question for this subject
    final questions = _sampleQuestions[direction];
    Map<String, String>? randomQuestionData;
    if (questions != null && questions.isNotEmpty) {
      randomQuestionData = questions[(DateTime.now().millisecondsSinceEpoch % questions.length)];
    }
    
    setState(() {
      _completedGestures.add(direction);
      _currentPracticeGesture = direction;
      if (randomQuestionData != null) {
        _currentDemoQuestion = randomQuestionData['question'];
        _currentDemoAnswer = randomQuestionData['answer'];
        _showDemoQuestion = true;
        _showAnswerInput = true;
        _showCorrectAnswer = false;
        _answerController.clear();
      }
    });
    
    // Show feedback for completed gesture
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '✓ ${direction.subject.displayName} gesture completed!',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: direction.subject.color,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleDemoGesture(GestureDirection direction) {
    // Only handle demo gestures on interactive pages
    final currentStep = _tutorialSteps[_currentPage];
    if (!currentStep.isInteractive || currentStep.gestureDirection != direction) return;
    
    HapticFeedback.lightImpact();
    
    // Get a random question for this subject
    final questions = _sampleQuestions[direction];
    if (questions != null && questions.isNotEmpty) {
      final randomQuestionData = questions[(DateTime.now().millisecondsSinceEpoch % questions.length)];
      
      setState(() {
        _currentDemoQuestion = randomQuestionData['question'];
        _currentDemoAnswer = randomQuestionData['answer'];
        _showDemoQuestion = true;
        _showAnswerInput = true;
        _showCorrectAnswer = false;
        _answerController.clear();
      });
      
      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✓ Great! Here\'s a ${direction.subject.displayName} question for you!',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: direction.subject.color,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showAnswerButton() {
    setState(() {
      _showCorrectAnswer = true;
    });
  }

  void _closeQuestion() {
    setState(() {
      _showDemoQuestion = false;
      _showAnswerInput = false;
      _showCorrectAnswer = false;
      _currentDemoQuestion = null;
      _currentDemoAnswer = null;
      _currentPracticeGesture = null;
      _answerController.clear();
    });
  }

  void _completeTutorial() {
    print('_completeTutorial called'); // Debug log
    
    // Show completion message first
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tutorial completed! Ready to start learning.'),
        backgroundColor: AppColors.success,
        duration: Duration(seconds: 1),
      ),
    );
    
    // Navigate to home screen after a brief delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        print('Navigating to HomeScreen'); // Debug log
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else {
        print('Widget not mounted, cannot navigate'); // Debug log
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Disable swipe navigation
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                    if (index == _tutorialSteps.length - 1) {
                      _isPracticeMode = true;
                    } else {
                      _isPracticeMode = false;
                    }
                  });
                  _animationController.reset();
                  _animationController.forward();
                },
                itemCount: _tutorialSteps.length,
                itemBuilder: (context, index) {
                  return _buildTutorialPage(_tutorialSteps[index]);
                },
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          if (_currentPage > 0)
            IconButton(
              onPressed: _previousPage,
              icon: const Icon(Icons.arrow_back),
              color: AppColors.textPrimary,
            ),
          Expanded(
            child: LinearProgressIndicator(
              value: (_currentPage + 1) / _tutorialSteps.length,
              backgroundColor: AppColors.lightGrey,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '${_currentPage + 1}/${_tutorialSteps.length}',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialPage(TutorialStep step) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isPracticeMode)
                _buildPracticeArea()
              else
                _buildDemonstrationArea(step),
              const SizedBox(height: 48),
              Text(
                step.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                step.description,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              if (_isPracticeMode) ...[
                const SizedBox(height: 24),
                _buildPracticeProgress(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDemonstrationArea(TutorialStep step) {
    if (step.gestureDirection == null) {
      return Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Icon(
          Icons.school,
          size: 80,
          color: AppColors.primaryBlue,
        ),
      );
    }

    Widget demoArea = Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        color: step.gestureDirection!.subject.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(125),
        border: Border.all(
          color: step.gestureDirection!.subject.color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            step.gestureDirection!.subject.icon,
            size: 60,
            color: step.gestureDirection!.subject.color,
          ),
          _buildAnimatedGestureIndicator(step.gestureDirection!),
          if (_showDemoQuestion && _currentDemoQuestion != null)
            _buildQuestionOverlay(_currentDemoQuestion!),
        ],
      ),
    );

    // Add gesture detection for interactive steps
    if (step.isInteractive) {
      return GestureDetector(
        onPanEnd: (details) {
          final velocity = details.velocity.pixelsPerSecond;
          final dx = velocity.dx.abs();
          final dy = velocity.dy.abs();
          
          GestureDirection detectedDirection;
          
          if (dx > dy) {
            // Horizontal swipe
            if (velocity.dx > 0) {
              detectedDirection = GestureDirection.right;
            } else {
              detectedDirection = GestureDirection.left;
            }
          } else {
            // Vertical swipe
            if (velocity.dy > 0) {
              detectedDirection = GestureDirection.down;
            } else {
              detectedDirection = GestureDirection.up;
            }
          }
          
          _handleDemoGesture(detectedDirection);
        },
        child: demoArea,
      );
    }

    return demoArea;
  }

  Widget _buildQuestionOverlay(String question) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(maxWidth: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          if (_showAnswerInput) ...[
            const SizedBox(height: 16),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(
                hintText: 'Enter your answer...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _showAnswerButton,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Show Answer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _closeQuestion,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      side: const BorderSide(color: AppColors.primaryBlue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (_showCorrectAnswer && _currentDemoAnswer != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.success.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Correct Answer:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _currentDemoAnswer!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAnimatedGestureIndicator(GestureDirection direction) {
    return AnimatedBuilder(
      animation: _gestureAnimationController,
      builder: (context, child) {
        final progress = _gestureAnimationController.value;
        Offset startOffset, endOffset;
        
        switch (direction) {
          case GestureDirection.up:
            startOffset = const Offset(0, 50);
            endOffset = const Offset(0, -50);
            break;
          case GestureDirection.down:
            startOffset = const Offset(0, -50);
            endOffset = const Offset(0, 50);
            break;
          case GestureDirection.left:
            startOffset = const Offset(50, 0);
            endOffset = const Offset(-50, 0);
            break;
          case GestureDirection.right:
            startOffset = const Offset(-50, 0);
            endOffset = const Offset(50, 0);
            break;
        }
        
        final currentOffset = Offset.lerp(startOffset, endOffset, progress)!;
        final opacity = (1 - progress).clamp(0.3, 1.0);
        
        return Transform.translate(
          offset: currentOffset,
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: direction.subject.color,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: direction.subject.color.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                _getGestureIcon(direction),
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getGestureIcon(GestureDirection direction) {
    switch (direction) {
      case GestureDirection.up:
        return Icons.keyboard_arrow_up;
      case GestureDirection.down:
        return Icons.keyboard_arrow_down;
      case GestureDirection.left:
        return Icons.keyboard_arrow_left;
      case GestureDirection.right:
        return Icons.keyboard_arrow_right;
    }
  }

  Widget _buildPracticeArea() {
    return GestureDetector(
      onPanEnd: (details) {
        final velocity = details.velocity.pixelsPerSecond;
        final dx = velocity.dx.abs();
        final dy = velocity.dy.abs();
        
        if (dx > dy) {
          // Horizontal swipe
          if (velocity.dx > 0) {
            _handleGesture(GestureDirection.right);
          } else {
            _handleGesture(GestureDirection.left);
          }
        } else {
          // Vertical swipe
          if (velocity.dy > 0) {
            _handleGesture(GestureDirection.down);
          } else {
            _handleGesture(GestureDirection.up);
          }
        }
      },
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(150),
          border: Border.all(
            color: AppColors.primaryBlue.withOpacity(0.3),
            width: 3,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (!_showDemoQuestion)
              const Text(
                'Try swiping in\nany direction',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            if (_currentPracticeGesture != null && !_showDemoQuestion)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _currentPracticeGesture!.subject.color,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  _currentPracticeGesture!.subject.icon,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            if (_showDemoQuestion && _currentDemoQuestion != null)
              _buildQuestionOverlay(_currentDemoQuestion!),
            // Direction indicators
            ..._buildDirectionIndicators(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDirectionIndicators() {
    return GestureDirection.values.map((direction) {
      final isCompleted = _completedGestures.contains(direction);
      Alignment alignment;
      
      switch (direction) {
        case GestureDirection.up:
          alignment = Alignment.topCenter;
          break;
        case GestureDirection.down:
          alignment = Alignment.bottomCenter;
          break;
        case GestureDirection.left:
          alignment = Alignment.centerLeft;
          break;
        case GestureDirection.right:
          alignment = Alignment.centerRight;
          break;
      }
      
      return Align(
        alignment: alignment,
        child: Container(
          margin: const EdgeInsets.all(20),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isCompleted 
                ? direction.subject.color 
                : direction.subject.color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(
            isCompleted ? Icons.check : direction.subject.icon,
            color: Colors.white,
            size: 24,
          ),
        ),
      );
    }).toList();
  }

  Widget _buildPracticeProgress() {
    final completedCount = _completedGestures.length;
    final totalCount = GestureDirection.values.length;
    
    return Column(
      children: [
        Text(
          'Progress: $completedCount/$totalCount gestures completed',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: completedCount / totalCount,
          backgroundColor: AppColors.lightGrey,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Skip practice button (only show in practice mode when not all gestures completed)
          if (_isPracticeMode && _completedGestures.length < 4)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextButton(
                onPressed: _completeTutorial,
                child: const Text(
                  'Skip Practice & Start Learning',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          
          // Main navigation row
          Row(
            children: [
              if (_currentPage > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _previousPage,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppColors.primaryBlue),
                    ),
                    child: const Text(
                      'Previous',
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              if (_currentPage > 0) const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isPracticeMode && _completedGestures.length < 4
                      ? null
                      : (_currentPage == _tutorialSteps.length - 1
                          ? _completeTutorial
                          : _nextPage),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    _currentPage == _tutorialSteps.length - 1
                        ? 'Start Learning'
                        : 'Next',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TutorialStep {
  final String title;
  final String description;
  final GestureDirection? gestureDirection;
  final bool isInteractive;

  TutorialStep({
    required this.title,
    required this.description,
    this.gestureDirection,
    required this.isInteractive,
  });
}