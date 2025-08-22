import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/subject_type.dart';
import '../utils/app_colors.dart';
import 'api_keys_screen.dart';

class SubjectSelectionScreen extends StatefulWidget {
  const SubjectSelectionScreen({super.key});

  @override
  State<SubjectSelectionScreen> createState() => _SubjectSelectionScreenState();
}

class _SubjectSelectionScreenState extends State<SubjectSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final Set<SubjectType> _selectedSubjects = <SubjectType>{};
  
  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSubject(SubjectType subject) {
    setState(() {
      if (_selectedSubjects.contains(subject)) {
        _selectedSubjects.remove(subject);
      } else {
        _selectedSubjects.add(subject);
      }
    });
    
    // Add haptic feedback
    HapticFeedback.selectionClick();
  }

  void _navigateBack() {
    HapticFeedback.lightImpact();
    Navigator.of(context).pop();
  }

  void _continueToNext() {
    if (_selectedSubjects.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select at least one subject to continue'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }
    
    HapticFeedback.lightImpact();
    
    // Navigate to API keys screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const APIKeysScreen(),
      ),
    );
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
              child: Padding(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: isSmallScreen ? 16 : 24),
                            
                            // Instructions
                            _buildInstructions(context),
                            
                            SizedBox(height: isSmallScreen ? 24 : 32),
                            
                            // Subject list
                            Expanded(
                              child: _buildSubjectList(context, isSmallScreen),
                            ),
                            
                            SizedBox(height: isSmallScreen ? 16 : 24),
                            
                            // Progress indicator
                            _buildProgressIndicator(context),
                            
                            SizedBox(height: isSmallScreen ? 16 : 24),
                            
                            // Continue button
                            _buildContinueButton(context),
                            
                            SizedBox(height: isSmallScreen ? 16 : 24),
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
            'Subjects',
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
          'Choose your subjects',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select the subjects you\'d like to practice. You can change these later in settings.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectList(BuildContext context, bool isSmallScreen) {
    return ListView.separated(
      itemCount: SubjectType.allSubjects.length,
      separatorBuilder: (context, index) => SizedBox(height: isSmallScreen ? 12 : 16),
      itemBuilder: (context, index) {
        final subject = SubjectType.allSubjects[index];
        final isSelected = _selectedSubjects.contains(subject);
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _toggleSubject(subject),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                decoration: BoxDecoration(
                  color: isSelected ? subject.color.withOpacity(0.1) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? subject.color : Colors.grey.withOpacity(0.2),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Subject icon
                    Container(
                      width: isSmallScreen ? 48 : 56,
                      height: isSmallScreen ? 48 : 56,
                      decoration: BoxDecoration(
                        color: subject.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        subject.icon,
                        color: subject.color,
                        size: isSmallScreen ? 24 : 28,
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Subject name
                    Expanded(
                      child: Text(
                        subject.displayName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: isSmallScreen ? 18 : 20,
                        ),
                      ),
                    ),
                    
                    // Checkbox
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isSelected ? subject.color : Colors.transparent,
                        border: Border.all(
                          color: isSelected ? subject.color : Colors.grey.withOpacity(0.4),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    final totalSubjects = SubjectType.allSubjects.length;
    final selectedCount = _selectedSubjects.length;
    final progress = selectedCount / totalSubjects;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$selectedCount/$totalSubjects',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    final isEnabled = _selectedSubjects.isNotEmpty;
    
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isEnabled ? _continueToNext : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.withOpacity(0.3),
          disabledForegroundColor: Colors.grey.withOpacity(0.6),
          elevation: isEnabled ? 4 : 0,
          shadowColor: AppColors.primaryBlue.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Continue',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: isEnabled ? Colors.white : Colors.grey.withOpacity(0.6),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward,
              size: 20,
              color: isEnabled ? Colors.white : Colors.grey.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }
}