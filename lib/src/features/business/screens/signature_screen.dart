import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signature/signature.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/main_button.dart';

class SignatureScreen extends StatefulWidget {
  const SignatureScreen({super.key});

  static const routePath = '/SignatureScreen';

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  late SignatureController signatureController;

  bool active = false;

  void onUndo() {
    if (signatureController.canUndo) {
      signatureController.undo();
      setState(() {});
    }
  }

  void onSave() {
    final signature = signatureController.toRawSVG();
    if (signature != null) {
      context.pop(signature);
    }
  }

  @override
  void initState() {
    super.initState();
    signatureController = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
      onDrawEnd: () {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Scaffold(
      appBar: const Appbar(title: 'Create a signsature'),
      body: Column(
        children: [
          Container(
            height: 184,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.tertiary1,
              borderRadius: BorderRadius.circular(6),
            ),
            child: DottedBorder(
              options: RoundedRectDottedBorderOptions(
                radius: const Radius.circular(8),
                dashPattern: [16, 16],
                strokeWidth: 1,
                color: colors.tertiary3,
              ),
              child: Signature(
                controller: signatureController,
                backgroundColor: colors.tertiary1,
              ),
            ),
          ),
          const Spacer(),
          MainButtonWrapper(
            children: [
              MainButton(
                title: 'Undo',
                color: colors.bg,
                active: signatureController.canUndo,
                onPressed: onUndo,
              ),
              MainButton(
                title: 'Save',
                active: signatureController.canUndo,
                onPressed: onSave,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
