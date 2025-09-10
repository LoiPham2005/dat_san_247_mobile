// intro_model.dart
import 'package:flutter/widgets.dart';

class IntroModel {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final List<Color> gradient;
  final Color backgroundColor;

  IntroModel({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.gradient,
    required this.backgroundColor,
  });
}
