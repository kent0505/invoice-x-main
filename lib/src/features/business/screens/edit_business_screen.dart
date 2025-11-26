import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/dialog_widget.dart';
import '../../../core/widgets/field.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../../core/widgets/title_text.dart';
import '../bloc/business_bloc.dart';
import '../models/business.dart';
import '../widgets/business_logo.dart';
import 'signature_screen.dart';

class EditBusinessScreen extends StatefulWidget {
  const EditBusinessScreen({super.key, required this.business});

  final Business? business;

  static const routePath = '/EditBusinessScreen';

  @override
  State<EditBusinessScreen> createState() => _EditBusinessScreenState();
}

class _EditBusinessScreenState extends State<EditBusinessScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final bankController = TextEditingController();
  final swiftController = TextEditingController();
  final ibanController = TextEditingController();
  final accountNoController = TextEditingController();
  final vatController = TextEditingController();

  String image = '';
  String signature = '';
  bool active = true;

  void onChanged(String _) {
    setState(() {
      active = nameController.text.isNotEmpty;
    });
  }

  void onAddLogo() async {
    image = await pickImage();
    onChanged('');
  }

  void onSignature() async {
    context.push<String?>(SignatureScreen.routePath).then(
      (value) {
        if (value != null) {
          setState(() {
            signature = value;
          });
        }
      },
    );
  }

  void onDelete() {
    DialogWidget.show(
      context,
      title: 'Delete business account?',
      delete: true,
      onPressed: () {
        context
            .read<BusinessBloc>()
            .add(DeleteBusiness(business: widget.business!));
        context.pop();
        context.pop();
      },
    );
  }

  void onSave() {
    if (widget.business == null) {
      final business = Business(
        name: nameController.text,
        phone: phoneController.text,
        email: emailController.text,
        address: addressController.text,
        bank: bankController.text,
        swift: swiftController.text,
        iban: ibanController.text,
        accountNo: accountNoController.text,
        vat: vatController.text,
        image: image,
        signature: signature,
      );
      context.read<BusinessBloc>().add(AddBusiness(business: business));
    } else {
      final business = widget.business!;
      business.name = nameController.text;
      business.phone = phoneController.text;
      business.email = emailController.text;
      business.address = addressController.text;
      business.bank = bankController.text;
      business.iban = ibanController.text;
      business.swift = swiftController.text;
      business.accountNo = accountNoController.text;
      business.vat = vatController.text;
      business.image = image;
      business.signature = signature;
      context.read<BusinessBloc>().add(EditBusiness(business: business));
    }
    context.pop();
  }

  @override
  void initState() {
    super.initState();
    if (widget.business != null) {
      nameController.text = widget.business!.name;
      phoneController.text = widget.business!.phone;
      emailController.text = widget.business!.email;
      addressController.text = widget.business!.address;
      bankController.text = widget.business!.bank;
      swiftController.text = widget.business!.swift;
      ibanController.text = widget.business!.iban;
      accountNoController.text = widget.business!.accountNo;
      vatController.text = widget.business!.vat;
      image = widget.business!.image;
      signature = widget.business!.signature;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    bankController.dispose();
    swiftController.dispose();
    ibanController.dispose();
    accountNoController.dispose();
    vatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Scaffold(
      appBar: Appbar(
        title: widget.business == null ? 'Create new account' : 'Edit account',
        right: widget.business == null
            ? null
            : Button(
                onPressed: onDelete,
                child: SvgWidget(
                  Assets.delete,
                  color: colors.text,
                ),
              ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                BusinessLogo(
                  image: image,
                  onPressed: onAddLogo,
                ),
                const SizedBox(height: 16),
                const TitleText(title: 'Name'),
                Field(
                  controller: nameController,
                  hintText: 'Name',
                  onChanged: onChanged,
                ),
                const SizedBox(height: 16),
                const TitleText(
                  title: 'E-mail',
                  additional: 'Optional',
                ),
                Field(
                  controller: emailController,
                  hintText: 'E-Mail',
                ),
                const SizedBox(height: 16),
                const TitleText(
                  title: 'Phone number',
                  additional: 'Optional',
                ),
                Field(
                  controller: phoneController,
                  hintText: 'Phone',
                  fieldType: FieldType.phone,
                ),
                const SizedBox(height: 16),
                const TitleText(
                  title: 'Address',
                  additional: 'Optional',
                ),
                Field(
                  controller: addressController,
                  hintText: 'Address',
                ),
                const SizedBox(height: 16),
                const TitleText(
                  title: 'Bank',
                  additional: 'Optional',
                ),
                Field(
                  controller: bankController,
                  hintText: 'Bank',
                ),
                const SizedBox(height: 16),
                const TitleText(
                  title: 'Swift',
                  additional: 'Optional',
                ),
                Field(
                  controller: swiftController,
                  hintText: 'Swift',
                ),
                const SizedBox(height: 16),
                const TitleText(
                  title: 'IBAN',
                  additional: 'Optional',
                ),
                Field(
                  controller: ibanController,
                  hintText: 'IBAN',
                ),
                const SizedBox(height: 16),
                const TitleText(
                  title: 'Account No',
                  additional: 'Optional',
                ),
                Field(
                  controller: accountNoController,
                  hintText: 'Account No',
                ),
                const SizedBox(height: 16),
                const TitleText(
                  title: 'VAT',
                  additional: 'Optional',
                ),
                Field(
                  controller: vatController,
                  hintText: 'VAT',
                ),
                if (signature.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const TitleText(
                    title: 'Signature',
                    additional: 'Optional',
                  ),
                  SizedBox(child: SvgPicture.string(signature)),
                ],
              ],
            ),
          ),
          MainButtonWrapper(
            children: [
              MainButton(
                title: 'Create a signature',
                color: colors.bg,
                onPressed: onSignature,
              ),
              MainButton(
                title: 'Save',
                active: active,
                onPressed: onSave,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
