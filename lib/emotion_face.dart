import 'package:flutter/material.dart';

class EmotionFace extends StatelessWidget {
  final dynamic icon;

  const EmotionFace({
    Key? key,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[600],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Icon(
          icon is IconData ? icon : IconData(icon),
          size: 28,
          color: Colors.white,
        ),
      ),
    );
  }
}
