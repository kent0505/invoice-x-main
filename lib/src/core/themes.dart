import 'package:flutter/material.dart';

import 'constants.dart';

class Themes {
  final bool isDark;

  Themes({required this.isDark});

  MyColors get colors {
    return isDark ? MyColors.dark() : MyColors.light();
  }

  ThemeData get theme {
    return ThemeData(
      useMaterial3: false,
      brightness: isDark ? Brightness.dark : Brightness.light,
      fontFamily: AppFonts.w500,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.accent,
        selectionColor: colors.accent,
        selectionHandleColor: colors.accent,
      ),

      colorScheme: isDark
          ? ColorScheme.dark(
              primary: colors.text,
              secondary: colors.tertiary4, // overscroll
              surface: colors.bg, // bg color when push
            )
          : ColorScheme.light(
              primary: colors.text,
              secondary: colors.tertiary4,
              surface: colors.bg,
            ),

      // SCAFFOLD
      scaffoldBackgroundColor: colors.bg,

      appBarTheme: AppBarTheme(
        backgroundColor: colors.bg,
        elevation: 0,
        centerTitle: true,
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
        titleTextStyle: TextStyle(
          color: colors.text,
          fontSize: 18,
          fontFamily: AppFonts.w600,
        ),
      ),

      // DIALOG
      dialogTheme: DialogThemeData(
        backgroundColor: colors.bg,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 50),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.tertiary1,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.vertical(
            top: Radius.circular(16),
          ),
        ),
      ),

      // TEXTFIELD
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.tertiary1,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 12,
        ),
        hintStyle: TextStyle(
          color: colors.text2,
          fontSize: 14,
          fontFamily: AppFonts.w400,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
      ),
      extensions: [colors],
    );
  }
}
