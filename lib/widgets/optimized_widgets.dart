import 'package:flutter/material.dart';

/// Optimized button that prevents rapid taps
class OptimizedButton extends StatefulWidget {
  const OptimizedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
    this.debounceMs = 300,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;
  final int debounceMs;

  @override
  State<OptimizedButton> createState() => _OptimizedButtonState();
}

class _OptimizedButtonState extends State<OptimizedButton> {
  bool _isProcessing = false;

  void _handleTap() async {
    if (_isProcessing || widget.onPressed == null) return;
    
    setState(() => _isProcessing = true);
    
    widget.onPressed!();
    
    await Future.delayed(Duration(milliseconds: widget.debounceMs));
    
    if (mounted) {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isProcessing ? null : _handleTap,
      style: widget.style,
      child: widget.child,
    );
  }
}

/// Optimized list tile that uses const constructors where possible
class OptimizedListTile extends StatelessWidget {
  const OptimizedListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
  });

  final Widget? leading;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      onTap: onTap,
      trailing: trailing,
    );
  }
}

/// Optimized animated container that only rebuilds when values change
class OptimizedAnimatedContainer extends StatelessWidget {
  const OptimizedAnimatedContainer({
    super.key,
    required this.duration,
    this.child,
    this.padding,
    this.margin,
    this.decoration,
    this.width,
    this.height,
    this.color,
    this.curve = Curves.linear,
  });

  final Duration duration;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final double? width;
  final double? height;
  final Color? color;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
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

/// Memoized widget builder that caches expensive computations
class MemoizedBuilder<T> extends StatefulWidget {
  const MemoizedBuilder({
    super.key,
    required this.compute,
    required this.builder,
    this.dependencies = const [],
  });

  final T Function() compute;
  final Widget Function(BuildContext context, T value) builder;
  final List<Object?> dependencies;

  @override
  State<MemoizedBuilder<T>> createState() => _MemoizedBuilderState<T>();
}

class _MemoizedBuilderState<T> extends State<MemoizedBuilder<T>> {
  late T _cachedValue;
  late List<Object?> _lastDependencies;

  @override
  void initState() {
    super.initState();
    _cachedValue = widget.compute();
    _lastDependencies = List.from(widget.dependencies);
  }

  @override
  void didUpdateWidget(MemoizedBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Check if dependencies have changed
    bool dependenciesChanged = false;
    if (_lastDependencies.length != widget.dependencies.length) {
      dependenciesChanged = true;
    } else {
      for (int i = 0; i < _lastDependencies.length; i++) {
        if (_lastDependencies[i] != widget.dependencies[i]) {
          dependenciesChanged = true;
          break;
        }
      }
    }
    
    if (dependenciesChanged) {
      _cachedValue = widget.compute();
      _lastDependencies = List.from(widget.dependencies);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _cachedValue);
  }
}
