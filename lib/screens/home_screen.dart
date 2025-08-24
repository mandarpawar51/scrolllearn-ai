import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;
import '../blocs/gesture_bloc.dart';
import '../models/gesture_models.dart';
import '../models/subject_type.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GestureBloc(),
      child: const _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatelessWidget {
  const _HomeScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: BlocListener<GestureBloc, GestureBlocState>(
          listener: (context, state) {
            if (state is GestureRecognized) {
              _navigateToProblemScreen(context, state.result.subject);
            } else if (state is GestureInvalid) {
              _showGestureError(context, state.reason);
            }
          },
          child: BlocBuilder<GestureBloc, GestureBlocState>(
            builder: (context, state) {
              return GestureDetector(
                onPanStart: (details) {
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
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: AppColors.backgroundGradient,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Main content
                      _buildMainContent(context, state),
                      
                      // Gesture feedback overlay
                      if (state is GestureDetecting)
                        _buildGestureOverlay(context, state.gestureData),
                      
                      // Recognition feedback
                      if (state is GestureRecognized)
                        _buildRecognitionFeedback(context, state.result),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, GestureBlocState state) {
    return Column(
      children: [
        // Header
        _buildHeader(context),
        
        // Main gesture area
        Expanded(
          child: _buildGestureArea(context, state),
        ),
        
        // Bottom instructions
        _buildInstructions(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppConstants.appName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          IconButton(
            onPressed: () => _navigateToSettings(context),
            icon: const Icon(
              Icons.settings,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGestureArea(BuildContext context, GestureBlocState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Central icon/logo
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.school,
              size: 60,
              color: AppColors.primaryBlue,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Status text
          _buildStatusText(context, state),
          
          const SizedBox(height: 24),
          
          // Subject hints
          _buildSubjectHints(context, state),
        ],
      ),
    );
  }

  Widget _buildStatusText(BuildContext context, GestureBlocState state) {
    String text;
    Color color;
    
    if (state is GestureDetecting) {
      if (state.gestureData.detectedDirection != null) {
        text = 'Detected: ${state.gestureData.detectedDirection!.subject.displayName}';
        color = state.gestureData.detectedDirection!.subject.color;
      } else {
        text = 'Keep swiping...';
        color = AppColors.textSecondary;
      }
    } else if (state is GestureRecognized) {
      text = 'Opening ${state.result.subject.displayName}...';
      color = state.result.subject.color;
    } else if (state is GestureInvalid) {
      text = state.reason;
      color = AppColors.error;
    } else {
      text = 'Swipe to start learning';
      color = AppColors.textPrimary;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Text(
        text,
        key: ValueKey(text),
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSubjectHints(BuildContext context, GestureBlocState state) {
    return Column(
      children: [
        // Top - Science
        _buildSubjectHint(
          context,
          SubjectType.science,
          GestureDirection.up,
          Alignment.topCenter,
          isActive: state is GestureDetecting && 
                   state.gestureData.detectedDirection == GestureDirection.up,
        ),
        
        const SizedBox(height: 16),
        
        // Middle row - Geography and History
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSubjectHint(
              context,
              SubjectType.geography,
              GestureDirection.left,
              Alignment.centerLeft,
              isActive: state is GestureDetecting && 
                       state.gestureData.detectedDirection == GestureDirection.left,
            ),
            const SizedBox(width: 120), // Space for center icon
            _buildSubjectHint(
              context,
              SubjectType.history,
              GestureDirection.right,
              Alignment.centerRight,
              isActive: state is GestureDetecting && 
                       state.gestureData.detectedDirection == GestureDirection.right,
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Bottom - Math
        _buildSubjectHint(
          context,
          SubjectType.math,
          GestureDirection.down,
          Alignment.bottomCenter,
          isActive: state is GestureDetecting && 
                   state.gestureData.detectedDirection == GestureDirection.down,
        ),
      ],
    );
  }

  Widget _buildSubjectHint(
    BuildContext context,
    SubjectType subject,
    GestureDirection direction,
    Alignment alignment,
    {bool isActive = false}
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? subject.color.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? subject.color : AppColors.textLight,
          width: isActive ? 2 : 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            subject.icon,
            size: 20,
            color: isActive ? subject.color : AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          Text(
            subject.displayName,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isActive ? subject.color : AppColors.textSecondary,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Text(
            'Swipe in any direction to access subjects',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDirectionIndicator('↑ Science', AppColors.scienceColor),
              const SizedBox(width: 16),
              _buildDirectionIndicator('↓ Math', AppColors.mathColor),
              const SizedBox(width: 16),
              _buildDirectionIndicator('← Geography', AppColors.geographyColor),
              const SizedBox(width: 16),
              _buildDirectionIndicator('→ History', AppColors.historyColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionIndicator(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildGestureOverlay(BuildContext context, GestureData gestureData) {
    return Positioned.fill(
      child: CustomPaint(
        painter: GestureTrailPainter(gestureData),
      ),
    );
  }

  Widget _buildRecognitionFeedback(BuildContext context, GestureResult result) {
    return Positioned.fill(
      child: Container(
        color: result.subject.color.withOpacity(0.1),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  result.subject.icon,
                  size: 48,
                  color: result.subject.color,
                ),
                const SizedBox(height: 16),
                Text(
                  result.subject.displayName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: result.subject.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Loading problem...',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToProblemScreen(BuildContext context, SubjectType subject) {
    // TODO: Navigate to problem screen
    // For now, just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${subject.displayName} problems...'),
        backgroundColor: subject.color,
        duration: const Duration(seconds: 2),
      ),
    );
    
    // Reset gesture state after navigation
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (context.mounted) {
        context.read<GestureBloc>().add(const GestureReset());
      }
    });
  }

  void _navigateToSettings(BuildContext context) {
    // TODO: Navigate to settings screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings screen coming soon...'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showGestureError(BuildContext context, String reason) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(reason),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

class GestureTrailPainter extends CustomPainter {
  final GestureData gestureData;

  GestureTrailPainter(this.gestureData);

  @override
  void paint(Canvas canvas, Size size) {
    if (gestureData.distance < 20) return; // Don't draw for very small movements

    final paint = Paint()
      ..color = gestureData.detectedDirection?.subject.color.withOpacity(0.3) ?? 
                AppColors.textLight.withOpacity(0.3)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // Draw line from start to current position
    canvas.drawLine(
      gestureData.startPosition,
      gestureData.currentPosition,
      paint,
    );

    // Draw arrow head if direction is detected
    if (gestureData.detectedDirection != null && gestureData.distance > 50) {
      _drawArrowHead(canvas, paint);
    }
  }

  void _drawArrowHead(Canvas canvas, Paint paint) {
    final direction = gestureData.currentPosition - gestureData.startPosition;
    final angle = math.atan2(direction.dy, direction.dx);
    
    const arrowLength = 20.0;
    const arrowAngle = math.pi / 6; // 30 degrees

    final arrowPoint1 = Offset(
      gestureData.currentPosition.dx - arrowLength * math.cos(angle - arrowAngle),
      gestureData.currentPosition.dy - arrowLength * math.sin(angle - arrowAngle),
    );

    final arrowPoint2 = Offset(
      gestureData.currentPosition.dx - arrowLength * math.cos(angle + arrowAngle),
      gestureData.currentPosition.dy - arrowLength * math.sin(angle + arrowAngle),
    );

    canvas.drawLine(gestureData.currentPosition, arrowPoint1, paint);
    canvas.drawLine(gestureData.currentPosition, arrowPoint2, paint);
  }

  @override
  bool shouldRepaint(GestureTrailPainter oldDelegate) {
    return oldDelegate.gestureData != gestureData;
  }
}