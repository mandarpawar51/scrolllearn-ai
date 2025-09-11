import 'dart:async';
import 'package:flutter/material.dart';

/// Performance utilities for optimizing widget rebuilds
class PerformanceUtils {
  /// Debounce function calls to prevent excessive executions
  static void debounce(
    String key,
    VoidCallback callback, {
    Duration delay = const Duration(milliseconds: 300),
  }) {
    _timers[key]?.cancel();
    _timers[key] = Timer(delay, callback);
  }

  static final Map<String, Timer> _timers = {};

  /// Dispose all active timers
  static void dispose() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
  }
}

/// Optimized container that only rebuilds when necessary
class OptimizedContainer extends StatelessWidget {
  const OptimizedContainer({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.decoration,
    this.width,
    this.height,
    this.color,
  });

  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final double? width;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: decoration,
      width: width,
      height: height,
      color: color,
      child: child,
    );
  }
}

/// Optimized text widget with const constructor
class OptimizedText extends StatelessWidget {
  const OptimizedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Mixin for widgets that need performance monitoring
mixin PerformanceMixin<T extends StatefulWidget> on State<T> {
  late final Stopwatch _stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
  }

  @override
  void dispose() {
    _stopwatch.stop();
    debugPrint('${widget.runtimeType} lifecycle: ${_stopwatch.elapsedMilliseconds}ms');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buildStopwatch = Stopwatch()..start();
    final widget = buildWidget(context);
    buildStopwatch.stop();
    
    if (buildStopwatch.elapsedMilliseconds > 16) {
      debugPrint('${this.widget.runtimeType} build took ${buildStopwatch.elapsedMilliseconds}ms');
    }
    
    return widget;
  }

  Widget buildWidget(BuildContext context);
}
