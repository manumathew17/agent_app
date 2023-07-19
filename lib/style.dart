import 'package:flutter/material.dart';
import 'app_color.dart';

TextStyle header1 = const TextStyle(
    color: blackPrimary, fontWeight: FontWeight.bold, fontSize: 16);

TextStyle buttonText = const TextStyle(
  color: white,
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

TextStyle heading2 = const TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w700,
);

TextStyle heading5 = const TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
);

TextStyle heading6 = const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

TextStyle generalText = const TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
);

//buttons
ButtonStyle elevatedButtonPrimary = ElevatedButton.styleFrom(
  foregroundColor: blackSecondary,
  backgroundColor: primary,
).copyWith(elevation: ButtonStyleButton.allOrNull(0.0));

ButtonStyle textButtonStyle = TextButton.styleFrom(
  foregroundColor: primary,
  backgroundColor: lightPrimary_1,
  textStyle: const TextStyle(
      fontSize: 16, fontWeight: FontWeight.bold, color: primary),
).copyWith(elevation: ButtonStyleButton.allOrNull(0.0));

ButtonStyle textButtonNegativeStyle = TextButton.styleFrom(
  foregroundColor: errorPrimary,
  backgroundColor: errorSecondary,
  padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0),
  textStyle: const TextStyle(
      fontSize: 14, fontWeight: FontWeight.bold, color: primary),
).copyWith(elevation: ButtonStyleButton.allOrNull(0.0));
