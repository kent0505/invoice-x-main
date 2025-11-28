import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import 'svg_widget.dart';

enum FieldType {
  text,
  password,
  multiline,
  number,
  decimal,
  phone,
  url,
}

class Field extends StatelessWidget {
  const Field({
    super.key,
    this.controller,
    this.focusNode,
    required this.hintText,
    this.asset = '',
    this.maxLength = 50,
    this.fieldType = FieldType.text,
    this.readOnly = false,
    this.textCapitalization = TextCapitalization.sentences,
    this.suffixIcon,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String hintText;
  final String asset;
  final int? maxLength;
  final bool readOnly;
  final FieldType fieldType;
  final TextCapitalization textCapitalization;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function()? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: switch (fieldType) {
        FieldType.text => TextInputType.text,
        FieldType.password => TextInputType.text,
        FieldType.multiline => TextInputType.multiline,
        FieldType.number => TextInputType.number,
        FieldType.decimal =>
          const TextInputType.numberWithOptions(decimal: true),
        FieldType.phone => TextInputType.phone,
        FieldType.url => TextInputType.url,
      },
      obscureText: fieldType == FieldType.password,
      readOnly: readOnly,
      showCursor: !readOnly,
      enableInteractiveSelection: !readOnly,
      inputFormatters: [
        LengthLimitingTextInputFormatter(maxLength),
        if (fieldType == FieldType.number)
          FilteringTextInputFormatter.digitsOnly,
        if (fieldType == FieldType.decimal) _SingleDotInputFormatter(),
        if (fieldType == FieldType.phone) _PhoneInputFormatter()
      ],
      textCapitalization: textCapitalization,
      minLines: fieldType == FieldType.multiline ? 4 : 1,
      maxLines: fieldType == FieldType.multiline ? 8 : 1,
      style: TextStyle(
        color: colors.text,
        fontSize: 14,
        fontFamily: AppFonts.w400,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: asset.isEmpty
            ? null
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgWidget(
                    asset,
                    color: colors.text2,
                  ),
                ],
              ),
        suffixIcon: suffixIcon,
      ),
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onChanged: onChanged,
      onTap: onTap,
      onEditingComplete: onEditingComplete,
    );
  }
}

class _SingleDotInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(',', '.');
    if (RegExp(r'^[0-9]*\.?[0-9]*$').hasMatch(text)) {
      final dotCount = '.'.allMatches(text).length;
      if (dotCount > 1) return oldValue;
      return newValue.copyWith(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }
    return oldValue;
  }
}

class _PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;
    if (RegExp(r'^\+?[0-9]*$').hasMatch(text)) {
      if (text.contains('+') && !text.startsWith('+')) return oldValue;
      return newValue;
    }
    return oldValue;
  }
}
