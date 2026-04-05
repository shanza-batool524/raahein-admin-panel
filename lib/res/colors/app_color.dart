import 'package:flutter/material.dart';

class AppColor {
  // --- PRIMARY THEME (Cobalt Blue & Sunset Amber) ---
  static const Color primary = Color(0xFF2563EB);         // Royal Cobalt (Brand Action)
  static const Color secondary = Color(0xFFF59E0B);       // Sunset Amber (Accent)
  static const Color primaryDark = Color(0xFF1D4ED8);     // Dark Cobalt (For contrast/pressed states)
  static const Color primaryLight = Color(0xFFEFF6FF);    // Soft Blue (Highlight/Container)
  static const Color secondaryLight = Color(0xFFFEF3C7);  // Pale Amber (Subtle highlights)

  // --- BACKGROUND & SURFACE ---
  static const Color background = Color(0xFFF8FAFC);      // Cool Off-White
  static const Color surface = Color(0xFFFFFFFF);         // Pure White
  static const Color cardShadow = Color(0x1A1E40AF);      // Soft blue-tinted shadow (10% opacity)

  // --- TEXT COLORS ---
  static const Color textPrimary = Color(0xFF0F172A);     // Slate Dark (Headings/Main text)
  static const Color textSecondary = Color(0xFF475569);   // Medium Slate (Subtitles)
  static const Color textLight = Color(0xFF94A3B8);       // Light Slate (Hint text)

  // --- STATUS COLORS ---
  static const Color success = Color(0xFF16A34A);         // Green
  static const Color error = Color(0xFFDC2626);           // Red
  static const Color warning = Color(0xFFF59E0B);         // Amber/Yellow

  // --- BORDERS & DIVIDERS ---
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);

  // --- BASIC ---
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;
  static const Color brandDarkText = Color(0xFF1A1A1A); // Bold headings color
}
