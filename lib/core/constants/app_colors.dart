import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF0D1117);
  static const Color surface = Color(0xFF1C2128);
  static const Color card = Color(0xFF161B22);
  static const Color cardLight = Color(0xFF21262D);

  // Primary
  static const Color cyan = Color(0xFF00D4FF);
  static const Color cyanDark = Color(0xFF00A8CC);
  static const Color teal = Color(0xFF00B4CC);

  // Accent
  static const Color gold = Color(0xFFF5A623);
  static const Color goldLight = Color(0xFFFFD166);

  // Status
  static const Color green = Color(0xFF3FB950);
  static const Color red = Color(0xFFFF4D4D);
  static const Color orange = Color(0xFFFF8C00);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted = Color(0xFF484F58);
  static const Color textCyan = Color(0xFF00D4FF);
  static const Color textGold = Color(0xFFF5A623);

  // Border
  static const Color border = Color(0xFF30363D);
  static const Color borderLight = Color(0xFF21262D);

  // Gradient
  static const LinearGradient cyanGradient = LinearGradient(
    colors: [Color(0xFF00D4FF), Color(0xFF0099CC)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0D1117), Color(0xFF161B22)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1C2128), Color(0xFF161B22)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
