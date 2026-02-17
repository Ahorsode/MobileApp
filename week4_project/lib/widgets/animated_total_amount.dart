import 'package:flutter/material.dart';

class AnimatedTotalAmount extends StatelessWidget {
  final double value;
  final TextStyle style;

  const AnimatedTotalAmount({
    super.key,
    required this.value,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeOutExpo,
      tween: Tween<double>(begin: 0, end: value),
      builder: (context, animatedValue, child) {
        return Text(
          'GHS ${animatedValue.toStringAsFixed(2)}',
          style: style,
        );
      },
    );
  }
}
