import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/field.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/title_text.dart';

class ClientBody extends StatelessWidget {
  const ClientBody({
    super.key,
    required this.active,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.addressController,
    required this.onContact,
    required this.onContinue,
    required this.onChanged,
  });

  final bool active;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final VoidCallback onContact;
  final VoidCallback onContinue;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const TitleText(title: 'Name'),
              Field(
                hintText: 'Client’s full name',
                controller: nameController,
                onChanged: onChanged,
              ),
              const SizedBox(height: 16),
              const TitleText(
                title: 'E-mail',
                additional: 'Optional',
              ),
              Field(
                hintText: 'E-Mail',
                controller: emailController,
              ),
              const SizedBox(height: 16),
              const TitleText(
                title: 'Phone number',
                additional: 'Optional',
              ),
              Field(
                hintText: '+XX XXX XXX XXX',
                controller: phoneController,
                fieldType: FieldType.phone,
              ),
              const SizedBox(height: 16),
              const TitleText(
                title: 'Address',
                additional: 'Optional',
              ),
              Field(
                hintText: 'Client’s address',
                controller: addressController,
                fieldType: FieldType.multiline,
              ),
            ],
          ),
        ),
        MainButtonWrapper(
          children: [
            SizedBox(
              height: 58,
              child: Button(
                onPressed: onContact,
                child: Center(
                  child: Text(
                    'Import from contacts',
                    style: TextStyle(
                      color: colors.accent,
                      fontSize: 16,
                      fontFamily: AppFonts.w700,
                    ),
                  ),
                ),
              ),
            ),
            MainButton(
              title: 'Save',
              active: active,
              onPressed: onContinue,
            ),
          ],
        ),
      ],
    );
  }
}
