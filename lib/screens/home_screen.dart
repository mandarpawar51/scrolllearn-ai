import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/gesture_bloc.dart';
import '../models/subject_type.dart';
import '../utils/app_colors.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentTabIndex = 0;
  final TextEditingController _answerController = TextEditingController();
  SubjectType _currentSubject = SubjectType.math;
  String _currentQuestion = "Solve for x: 2x + 5 = 15";
  bool _showSolution = false;
  
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
          backgroundColor: Colors.white,
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
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _currentSubject.displayName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          IconButton(
            onPressed: () => _showSubjectMenu(),
            icon: const Icon(
              Icons.menu,
              color: Color(0xFF666666),
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
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Problem illustration/diagram area
            _buildProblemIllustration(),
            
            const SizedBox(height: 32),
            
            // Question text
            Text(
              _currentQuestion,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            
            const SizedBox(height: 12),
            
            const Text(
              'Enter your answer below:',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF888888),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Answer input field
            _buildAnswerInput(),
            
            const SizedBox(height: 24),
            
            // Show solution button
            _buildShowSolutionButton(),
            
            // Solution display
            if (_showSolution) _buildSolutionDisplay(),
            
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildProblemIllustration() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
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
            '${_currentSubject.displayName} Problem',
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
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: _answerController,
        decoration: const InputDecoration(
          hintText: 'Answer',
          hintStyle: TextStyle(
            color: Color(0xFFADB5BD),
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF1A1A1A),
        ),
        onChanged: (value) {
          setState(() {
            _showSolution = false;
          });
        },
      ),
    );
  }

  Widget _buildShowSolutionButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: _showSolutionAction,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF007AFF),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        child: const Text(
          'Show Solution',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSolutionDisplay() {
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
          const Text(
            'Solution:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getSolutionForCurrentProblem(),
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
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
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
          _handleBottomNavigation(index);
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

  // Action methods
  void _switchSubject(SubjectType newSubject) {
    setState(() {
      _currentSubject = newSubject;
      _currentQuestion = _getQuestionForSubject(newSubject);
      _answerController.clear();
      _showSolution = false;
    });

    // Show subject switch feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Switched to ${newSubject.displayName}'),
        backgroundColor: newSubject.color,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showSubjectMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Subject',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            ...SubjectType.values.map((subject) => ListTile(
              leading: Icon(subject.icon, color: subject.color),
              title: Text(subject.displayName),
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
      _showSolution = true;
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

  String _getQuestionForSubject(SubjectType subject) {
    switch (subject) {
      case SubjectType.math:
        return 'Solve for x: 2x + 5 = 15';
      case SubjectType.science:
        return 'What is the chemical formula for water?';
      case SubjectType.history:
        return 'In which year did World War II end?';
      case SubjectType.geography:
        return 'What is the capital of Australia?';
    }
  }

  String _getSolutionForCurrentProblem() {
    switch (_currentSubject) {
      case SubjectType.math:
        return '2x + 5 = 15\\n2x = 15 - 5\\n2x = 10\\nx = 5';
      case SubjectType.science:
        return 'H₂O - Water consists of two hydrogen atoms and one oxygen atom.';
      case SubjectType.history:
        return '1945 - World War II ended on September 2, 1945.';
      case SubjectType.geography:
        return 'Canberra - The capital of Australia is Canberra, not Sydney or Melbourne.';
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
                      const Text(
                        'Swipe to Switch Subjects',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Swipe left or right to explore\\ndifferent subjects',
                        style: TextStyle(
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
                    child: const Text(
                      'Skip',
                      style: TextStyle(
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: SubjectType.values.map((subject) {
        final isActive = subject == _currentSubject;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                subject.displayName,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.white70,
                  fontSize: 12,
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

