import 'package:flutter/material.dart';

import 'constants.dart';

import 'my_colors.dart';

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

      // DIALOG
      dialogTheme: DialogThemeData(
        // insetPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.symmetric(horizontal: 46),
        backgroundColor: colors.tertiary2,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(34)),
          side: BorderSide(
            width: 1,
            color: colors.tertiary3,
          ),
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
        fillColor: colors.tertiary2,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        hintStyle: TextStyle(
          color: colors.text2,
          fontSize: 16,
          fontFamily: AppFonts.w500,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            width: 1,
            color: colors.tertiary3,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            width: 1,
            color: colors.tertiary3,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            width: 1,
            color: colors.tertiary3,
          ),
        ),
      ),
      extensions: [colors],
    );
  }
}
