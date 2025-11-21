import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../bloc/business_bloc.dart';
import '../models/business.dart';
import '../widgets/business_body.dart';
import 'signature_screen.dart';

class EditBusinessScreen extends StatefulWidget {
  const EditBusinessScreen({super.key, required this.business});

  final Business business;

  static const routePath = '/EditBusinessScreen';

  @override
  State<EditBusinessScreen> createState() => _EditBusinessScreenState();
}

class _EditBusinessScreenState extends State<EditBusinessScreen> {
  final nameController = TextEditingController();
  final businessNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final bankController = TextEditingController();
  final swiftController = TextEditingController();
  final ibanController = TextEditingController();
  final accountNoController = TextEditingController();
  final vatController = TextEditingController();

  XFile file = XFile('');
  String signature = '';
  bool active = true;

  void checkActive(String _) {
    setState(() {
      active = checkControllers([
        nameController,
      ]);
    });
  }

  void onAddLogo() async {
    file = await pickImage();
    checkActive('');
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

  void onEdit() {
    final business = widget.business;
    business.name = nameController.text;
    business.businessName = businessNameController.text;
    business.phone = phoneController.text;
    business.email = emailController.text;
    business.address = addressController.text;
    business.bank = bankController.text;
    business.iban = ibanController.text;
    business.swift = swiftController.text;
    business.accountNo = accountNoController.text;
    business.vat = vatController.text;
    business.imageLogo = file.path;
    business.imageSignature = signature;
    context.read<BusinessBloc>().add(EditBusiness(business: business));
    context.pop();
  }

  @override
  void initState() {
    super.initState();
    file = XFile(widget.business.imageLogo);
    signature = widget.business.imageSignature;
    nameController.text = widget.business.name;
    businessNameController.text = widget.business.businessName;
    phoneController.text = widget.business.phone;
    emailController.text = widget.business.email;
    addressController.text = widget.business.address;
    bankController.text = widget.business.bank;
    swiftController.text = widget.business.swift;
    ibanController.text = widget.business.iban;
    accountNoController.text = widget.business.accountNo;
    vatController.text = widget.business.vat;
  }

  @override
  void dispose() {
    nameController.dispose();
    businessNameController.dispose();
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
    return Scaffold(
      appBar: const Appbar(title: 'Business'),
      body: BusinessBody(
        active: active,
        file: file,
        signature: signature,
        nameController: nameController,
        businessNameController: businessNameController,
        phoneController: phoneController,
        emailController: emailController,
        addressController: addressController,
        bankController: bankController,
        swiftController: swiftController,
        ibanController: ibanController,
        accountNoController: accountNoController,
        vatController: vatController,
        onAddLogo: onAddLogo,
        onSignature: onSignature,
        onSave: onEdit,
        onChanged: checkActive,
      ),
    );
  }
}
