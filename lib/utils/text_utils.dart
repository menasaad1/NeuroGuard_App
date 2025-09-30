import 'package:flutter/material.dart';

class TextUtils {
  // Safe text style for Arabic and English
  static TextStyle getSafeTextStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    String? fontFamily,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Colors.black,
      fontFamily: fontFamily ?? 'Arial',
      height: 1.2, // Fixed line height to prevent overflow
      letterSpacing: 0.0, // Fixed letter spacing
    );
  }

  // Safe text direction based on content
  static TextDirection getTextDirection(String text) {
    if (text.isEmpty) return TextDirection.ltr;
    
    // Check if text contains Arabic characters
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text) ? TextDirection.rtl : TextDirection.ltr;
  }

  // Safe text alignment based on content
  static TextAlign getTextAlign(String text) {
    if (text.isEmpty) return TextAlign.left;
    
    // Check if text contains Arabic characters
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text) ? TextAlign.right : TextAlign.left;
  }

  // Safe text field configuration
  static Map<String, dynamic> getSafeTextFieldConfig(String text) {
    final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(text);
    
    return {
      'textDirection': isArabic ? TextDirection.rtl : TextDirection.ltr,
      'textAlign': isArabic ? TextAlign.right : TextAlign.left,
      'style': getSafeTextStyle(),
    };
  }

  // Safe container constraints
  static BoxConstraints getSafeConstraints({
    double? maxWidth,
    double? maxHeight,
  }) {
    return BoxConstraints(
      maxWidth: maxWidth ?? 300,
      maxHeight: maxHeight ?? 100,
    );
  }

  // Safe text with overflow handling
  static Widget getSafeText(
    String text, {
    TextStyle? style,
    TextAlign? textAlign,
    TextDirection? textDirection,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return Text(
      text,
      style: style ?? getSafeTextStyle(),
      textAlign: textAlign ?? getTextAlign(text),
      textDirection: textDirection ?? getTextDirection(text),
      maxLines: maxLines ?? 2,
      overflow: overflow ?? TextOverflow.ellipsis,
    );
  }
}
