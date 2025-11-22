import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/dialog_widget.dart';
import '../../../core/widgets/svg_widget.dart';
import '../bloc/client_bloc.dart';
import '../models/client.dart';
import '../widgets/client_body.dart';

class EditClientScreen extends StatefulWidget {
  const EditClientScreen({super.key, required this.client});

  final Client client;

  static const routePath = '/EditClientScreen';

  @override
  State<EditClientScreen> createState() => _EditClientScreenState();
}

class _EditClientScreenState extends State<EditClientScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  bool active = true;

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

  void onDelete() {
    DialogWidget.show(
      context,
      title: 'Delete?',
      delete: true,
      onPressed: () {
        context.read<ClientBloc>().add(DeleteClient(client: widget.client));
        context.pop();
        context.pop();
      },
    );
  }

  void onEdit() {
    final client = widget.client;
    client.name = nameController.text;
    client.email = emailController.text;
    client.phone = phoneController.text;
    client.address = addressController.text;
    context.read<ClientBloc>().add(EditClient(client: client));
    context.pop();
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.client.name;
    emailController.text = widget.client.email;
    phoneController.text = widget.client.phone;
    addressController.text = widget.client.address;
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
      appBar: Appbar(
        title: 'Edit Client',
        right: Button(
          onPressed: onDelete,
          child: const SvgWidget(Assets.delete),
        ),
      ),
      body: ClientBody(
        active: active,
        nameController: nameController,
        emailController: emailController,
        phoneController: phoneController,
        addressController: addressController,
        onContact: onContact,
        onContinue: onEdit,
        onChanged: checkActive,
      ),
    );
  }
}
