import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AnimatedSection extends StatefulWidget {
  final String visibilityKey;
  final Widget child;
  final double visibleFraction;
  final Duration duration;
  final Offset slideBegin;
  final Duration delay;

  const AnimatedSection({
    super.key,
    required this.visibilityKey,
    required this.child,
    this.visibleFraction = 0.1,
    this.duration = const Duration(milliseconds: 700),
    this.slideBegin = const Offset(0, 0.25),
    this.delay = Duration.zero,
  });

  @override
  State<AnimatedSection> createState() => _AnimatedSectionState();
}

class _AnimatedSectionState extends State<AnimatedSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  late final Animation<double> _fade =
  CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);

  late final Animation<Offset> _slide = Tween<Offset>(
    begin: widget.slideBegin,
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

  bool _triggered = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onVisible(VisibilityInfo info) {
    if (info.visibleFraction > widget.visibleFraction && !_triggered && mounted) {
      _triggered = true;
      Future.delayed(widget.delay, () {
        if (mounted) _ctrl.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.visibilityKey),
      onVisibilityChanged: _onVisible,
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: widget.child,
        ),
      ),
    );
  }
}