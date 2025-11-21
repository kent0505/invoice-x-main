import 'package:flutter/material.dart';

class TemplateBody extends StatelessWidget {
  const TemplateBody({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 500 * 1.414,
      color: Colors.white,
      child: child,
    );
  }
}
