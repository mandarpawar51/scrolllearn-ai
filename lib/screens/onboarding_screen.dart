import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_colors.dart';
import 'subject_selection_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.height < 700;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.primaryGradient,
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background pattern/decoration
            Positioned.fill(
              child: CustomPaint(
                painter: BackgroundPatternPainter(),
              ),
            ),
            
            // Main content
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.08,
                ),
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            Spacer(flex: isSmallScreen ? 1 : 2),
                            
                            // Main illustration/icon area
                            _buildMainIllustration(screenSize, isSmallScreen),
                            
                            SizedBox(height: isSmallScreen ? 32 : 48),
                            
                            // Main title
                            _buildMainTitle(context, screenSize),
                            
                            SizedBox(height: isSmallScreen ? 12 : 16),
                            
                            // Subtitle
                            _buildSubtitle(context, screenSize),
                            
                            Spacer(flex: isSmallScreen ? 2 : 3),
                            
                            // Feature highlights
                            _buildFeatureHighlights(context, isSmallScreen),
                            
                            SizedBox(height: isSmallScreen ? 24 : 32),
                            
                            // Begin Journey Button
                            _buildBeginJourneyButton(context),
                            
                            SizedBox(height: isSmallScreen ? 16 : 24),
                            
                            // Skip option
                            _buildSkipButton(context),
                            
                            SizedBox(height: isSmallScreen ? 24 : 32),
                          ],
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

  Widget _buildMainIllustration(Size screenSize, bool isSmallScreen) {
    final size = isSmallScreen ? 160.0 : 200.0;
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: isSmallScreen ? 60 : 80,
            color: Colors.white,
          ),
          // Animated rings
          ...List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final delay = index * 0.2;
                final animation = Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(delay, 1.0, curve: Curves.easeOut),
                ));
                
                return Transform.scale(
                  scale: 1.0 + (animation.value * 0.3 * (index + 1)),
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1 * animation.value),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(size / 2),
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMainTitle(BuildContext context, Size screenSize) {
    return Text(
      'Unlock Your Learning Potential',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: screenSize.width < 350 ? 28 : 32,
        height: 1.2,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context, Size screenSize) {
    return Text(
      'Experience interactive learning through intuitive gestures and AI-powered study problems',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: Colors.white.withOpacity(0.9),
        fontSize: screenSize.width < 350 ? 14 : 16,
        height: 1.5,
      ),
    );
  }

  Widget _buildFeatureHighlights(BuildContext context, bool isSmallScreen) {
    final features = [
      {'icon': Icons.swipe, 'text': 'Gesture Navigation'},
      {'icon': Icons.psychology, 'text': 'AI-Powered'},
      {'icon': Icons.school, 'text': 'Multi-Subject'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: features.map((feature) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                feature['icon'] as IconData,
                color: Colors.white,
                size: isSmallScreen ? 20 : 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              feature['text'] as String,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.8),
                fontSize: isSmallScreen ? 11 : 12,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildBeginJourneyButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => _navigateToSubjectSelection(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primaryBlue,
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Begin Your Journey',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkipButton(BuildContext context) {
    return TextButton(
      onPressed: () => _navigateToSubjectSelection(context),
      child: Text(
        'Skip for now',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.white.withOpacity(0.8),
          fontSize: 14,
          decoration: TextDecoration.underline,
          decorationColor: Colors.white.withOpacity(0.8),
        ),
      ),
    );
  }

  void _navigateToSubjectSelection(BuildContext context) {
    // Add haptic feedback
    HapticFeedback.lightImpact();
    
    // Navigate to subject selection screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SubjectSelectionScreen(),
      ),
    );
  }
}

class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    // Draw subtle geometric patterns
    for (int i = 0; i < 20; i++) {
      final x = (i % 5) * (size.width / 4);
      final y = (i ~/ 5) * (size.height / 4);
      
      canvas.drawCircle(
        Offset(x, y),
        20,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}