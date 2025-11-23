import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/field.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../../core/widgets/title_text.dart';
import '../../business/bloc/business_bloc.dart';
import '../../business/models/business.dart';
import '../../home/screens/home_screen.dart';
import '../data/onboard_repository.dart';

class BusinessInfoScreen extends StatefulWidget {
  const BusinessInfoScreen({super.key});

  static const routePath = '/BusinessInfoScreen';

  @override
  State<BusinessInfoScreen> createState() => _BusinessInfoScreenState();
}

class _BusinessInfoScreenState extends State<BusinessInfoScreen> {
  String imageLogo = '';

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  bool active = false;

  void onPickImage() async {
    final file = await pickImage();
    setState(() {
      imageLogo = file.path;
    });
  }

  void onSave() async {
    final business = Business(
      imageLogo: imageLogo,
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      address: addressController.text,
    );

    context.read<BusinessBloc>().add(AddBusiness(business: business));

    context.read<OnboardRepository>().removeOnboard();

    context.replace(
      HomeScreen.routePath,
      extra: false,
    );
  }

  void onChanged(String _) {
    setState(() {
      active = nameController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  SizedBox(
                    height: 44,
                    child: Text(
                      'Business info',
                      style: TextStyle(
                        color: colors.text,
                        fontSize: 32,
                        fontFamily: AppFonts.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Button(
                      onPressed: onPickImage,
                      child: SizedBox(
                        width: 164,
                        height: 164,
                        child: imageLogo.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(164),
                                child: Image.file(
                                  File(imageLogo),
                                  errorBuilder: ImageWidget.errorBuilder,
                                  frameBuilder: ImageWidget.frameBuilder,
                                  height: 164,
                                  width: 164,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : DottedBorder(
                                options: CircularDottedBorderOptions(
                                  strokeWidth: 6,
                                  dashPattern: [21, 21],
                                  color: colors.tertiary3,
                                ),
                                child: Center(
                                  child: SvgWidget(
                                    Assets.add,
                                    height: 60,
                                    color: colors.accent,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const TitleText(title: 'Name'),
                  Field(
                    controller: nameController,
                    hintText: 'Full name',
                    onChanged: onChanged,
                  ),
                  const SizedBox(height: 16),
                  const TitleText(
                    title: 'E-mail',
                    additional: 'Optional',
                  ),
                  Field(
                    controller: emailController,
                    hintText: 'example@gmail.com',
                  ),
                  const SizedBox(height: 16),
                  const TitleText(
                    title: 'Phone number',
                    additional: 'Optional',
                  ),
                  Field(
                    controller: phoneController,
                    hintText: '+XX XXX XXX XXX',
                  ),
                  const SizedBox(height: 16),
                  const TitleText(
                    title: 'Address',
                    additional: 'Optional',
                  ),
                  Field(
                    controller: addressController,
                    hintText: 'Business address',
                  ),
                ],
              ),
            ),
            MainButtonWrapper(
              children: [
                MainButton(
                  title: 'Done',
                  active: active,
                  onPressed: onSave,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
