import 'package:flutter/material.dart';

class AppProgressBar extends StatelessWidget {
  final double value;
  final Color? color;

  const AppProgressBar({super.key, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: 8,
        color: color ?? Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
    );
  }
}
