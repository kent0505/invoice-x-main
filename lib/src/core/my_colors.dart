import 'package:flutter/material.dart';

final class MyColors extends ThemeExtension<MyColors> {
  const MyColors({
    required this.accent,
    required this.bg,
    required this.error,
    required this.text,
    required this.text2,
    required this.tertiary1,
    required this.tertiary2,
    required this.tertiary3,
    required this.tertiary4,
  });

  final Color accent;
  final Color bg;
  final Color error;
  final Color text;
  final Color text2;
  final Color tertiary1;
  final Color tertiary2;
  final Color tertiary3;
  final Color tertiary4;

  factory MyColors.light() {
    return const MyColors(
      accent: Color(0xff007144),
      bg: Color(0xffffffff),
      error: Color(0xffd2090d),
      text: Color(0xff000000),
      text2: Color(0xff717171),
      tertiary1: Color(0xfff6f6f6),
      tertiary2: Color(0xffbabebd),
      tertiary3: Color(0xffd9d9d9),
      tertiary4: Color(0xffdde9e4),
    );
  }

  factory MyColors.dark() {
    return const MyColors(
      accent: Color(0xff007144),
      bg: Color(0xffffffff),
      error: Color(0xffd2090d),
      text: Color(0xff000000),
      text2: Color(0xff717171),
      tertiary1: Color(0xfff6f6f6),
      tertiary2: Color(0xffbabebd),
      tertiary3: Color(0xffd9d9d9),
      tertiary4: Color(0xffdde9e4),
    );
  }

  @override
  MyColors copyWith({
    Color? accent,
    Color? bg,
    Color? error,
    Color? text,
    Color? text2,
    Color? tertiary1,
    Color? tertiary2,
    Color? tertiary3,
    Color? tertiary4,
  }) {
    return MyColors(
      accent: accent ?? this.accent,
      bg: bg ?? this.bg,
      error: error ?? this.error,
      text: text ?? this.text,
      text2: text2 ?? this.text2,
      tertiary1: tertiary1 ?? this.tertiary1,
      tertiary2: tertiary2 ?? this.tertiary2,
      tertiary3: tertiary3 ?? this.tertiary3,
      tertiary4: tertiary4 ?? this.tertiary4,
    );
  }

  @override
  MyColors lerp(ThemeExtension<MyColors>? other, double t) {
    if (other is! MyColors) return this;
    return MyColors(
      accent: Color.lerp(accent, other.accent, t)!,
      bg: Color.lerp(bg, other.bg, t)!,
      error: Color.lerp(error, other.error, t)!,
      text: Color.lerp(text, other.text, t)!,
      text2: Color.lerp(text2, other.text2, t)!,
      tertiary1: Color.lerp(tertiary1, other.tertiary1, t)!,
      tertiary2: Color.lerp(tertiary2, other.tertiary2, t)!,
      tertiary3: Color.lerp(tertiary3, other.tertiary3, t)!,
      tertiary4: Color.lerp(tertiary4, other.tertiary4, t)!,
    );
  }
}
