import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../bloc/client_bloc.dart';
import '../models/client.dart';
import '../widgets/client_body.dart';

class CreateClientScreen extends StatefulWidget {
  const CreateClientScreen({super.key});

  static const routePath = '/CreateClientScreen';

  @override
  State<CreateClientScreen> createState() => _CreateClientScreenState();
}

class _CreateClientScreenState extends State<CreateClientScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  bool active = false;

  void checkActive(String _) {
    setState(() {
      active = checkControllers([
        nameController,
      ]);
    });
  }

  void onContact() async {
    await getContact(context).then((value) {
      nameController.text = value.name;
      emailController.text = value.email;
      phoneController.text = value.phone;
      addressController.text = value.address;
      checkActive('');
    });
  }

  void onContinue() {
    context.read<ClientBloc>().add(
          AddClient(
            client: Client(
              name: nameController.text,
              email: emailController.text,
              phone: phoneController.text,
              address: addressController.text,
            ),
          ),
        );
    context.pop();
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const Appbar(title: 'Create new client'),
      body: ClientBody(
        active: active,
        nameController: nameController,
        phoneController: phoneController,
        emailController: emailController,
        addressController: addressController,
        onContact: onContact,
        onContinue: onContinue,
        onChanged: checkActive,
      ),
    );
  }
}
