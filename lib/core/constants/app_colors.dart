import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds - Luxury Bahamian Ice & Crisp White
  static const Color background = Color(0xFFF4F9FD); // Soft ice-blue light surface
  static const Color surface = Color(0xFFFFFFFF);    // Crisp white
  static const Color card = Color(0xFFFFFFFF);       // White cards
  static const Color cardLight = Color(0xFFF0F6FA);  // Secondary soft tint
  static const Color cardTouchpoint = Color(0xFFE4F1F7); // Touchpoint card ice-cyan tint

  // Primary Brand Colors - Deep Sovereign Ocean Teal
  static const Color cyan = Color(0xFF007A8C);       // Sovereign Deep Teal
  static const Color primaryTeal = Color(0xFF007A8C); // Alias for cyan
  static const Color cyanDark = Color(0xFF006373);   // Darker teal
  static const Color teal = Color(0xFF0B879B);
  static const Color cyanPill = Color(0xFFD2EEF4);   // Pastel Cyan Pill for Action Buttons
  static const Color cyanLight = Color(0xFFE2F4F7);  // Soft Badge Background
  static const Color badgeCyan = Color(0xFFE2F4F7);  // Alias for cyanLight
  static const Color badgeTeal = Color(0xFFE2F4F7);  // Alias for cyanLight
  static const Color badgeGold = Color(0xFFFDEED9);  // Alias for goldLight

  // Accent & Domain Colors
  static const Color gold = Color(0xFFB87315);       // Warm Bahamian Gold
  static const Color goldLight = Color(0xFFFDEED9);  // Soft Peach/Gold Pill
  static const Color courierBlue = Color(0xFF2C648F);
  static const Color courierBlueLight = Color(0xFFDCECF8);
  static const Color fleetTan = Color(0xFF966020);
  static const Color fleetTanLight = Color(0xFFFAEBD7);
  static const Color staysTeal = Color(0xFF1D6E82);
  static const Color staysTealLight = Color(0xFFDDF0F5);

  // Status Colors
  static const Color green = Color(0xFF1B8A44);
  static const Color greenLight = Color(0xFFE2F6EA);
  static const Color red = Color(0xFFDC3545);
  static const Color error = Color(0xFFDC3545);
  static const Color errorRed = Color(0xFFDC3545);
  static const Color redLight = Color(0xFFFCE8E6);
  static const Color orange = Color(0xFFE65100);
  static const Color orangeLight = Color(0xFFFFF0E5);

  // Text Colors
  static const Color textPrimary = Color(0xFF102A3A);   // Deep Navy-Charcoal
  static const Color primaryNavy = Color(0xFF102A3A);   // Deep Sovereign Navy
  static const Color textSecondary = Color(0xFF5A7387); // Muted Island Slate
  static const Color textMuted = Color(0xFF8FA4B5);     // Soft Steel / Placeholder
  static const Color textCyan = Color(0xFF007A8C);      // Teal Accent Text
  static const Color textGold = Color(0xFFB87315);      // Gold Accent Text

  // Borders
  static const Color border = Color(0xFFE2EDF5);        // Soft delicate border
  static const Color borderLight = Color(0xFFEDF4F9);

  // Gradients
  static const LinearGradient cyanGradient = LinearGradient(
    colors: [Color(0xFF007A8C), Color(0xFF006373)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFF7FAFD), Color(0xFFEDF5FA)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF9FCFE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroCardGradient = LinearGradient(
    colors: [Color(0xFFE6F3F8), Color(0xFFF2F8FB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Card Shadows
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0A0B2238),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> softShadow = [
    BoxShadow(
      color: Color(0x080B2238),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];
}
