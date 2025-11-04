import 'package:flutter/material.dart';
import 'package:summercamp/core/config/app_theme.dart';

class CustomTypingIndicator extends StatefulWidget {
  const CustomTypingIndicator({super.key});

  @override
  State<CustomTypingIndicator> createState() => _CustomTypingIndicatorState();
}

class _CustomTypingIndicatorState extends State<CustomTypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _anim1;
  late Animation<Offset> _anim2;
  late Animation<Offset> _anim3;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    final bounceTween = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(begin: Offset.zero, end: const Offset(0, -6.0)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0, -6.0), end: Offset.zero),
        weight: 50,
      ),
    ]);

    _anim1 = bounceTween.animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _anim2 = bounceTween.animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.65, curve: Curves.easeInOut),
      ),
    );

    _anim3 = bounceTween.animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(Animation<Offset> animation) {
    return SlideTransition(
      position: animation,
      child: Container(
        width: 6,
        height: 6,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: const BoxDecoration(
          color: AppTheme.summerPrimary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [_buildDot(_anim1), _buildDot(_anim2), _buildDot(_anim3)],
    );
  }
}
