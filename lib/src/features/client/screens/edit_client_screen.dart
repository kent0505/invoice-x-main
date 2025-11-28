import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import '../bloc/client_bloc.dart';
import '../models/client.dart';

class EditClientScreen extends StatefulWidget {
  const EditClientScreen({super.key, required this.client});

  final Client? client;

  static const routePath = '/EditClientScreen';

  @override
  State<EditClientScreen> createState() => _EditClientScreenState();
}

class _EditClientScreenState extends State<EditClientScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  late Client client;

  bool active = true;

  void onChanged(String _) {
    setState(() {
      active = nameController.text.isNotEmpty;
    });
  }

  void onContact() async {
    await getContact(context).then((client) {
      if (client != null) {
        nameController.text = client.name;
        emailController.text = client.email;
        phoneController.text = client.phone;
        addressController.text = client.address;
        onChanged('');
      }
    });
  }

  void onDelete() {
    DialogWidget.show(
      context,
      title: 'Delete client?',
      delete: true,
      onPressed: () {
        context.read<ClientBloc>().add(DeleteClient(client: widget.client!));
        context.pop();
        context.pop();
      },
    );
  }

  void onEdit() {
    client.name = nameController.text;
    client.email = emailController.text;
    client.phone = phoneController.text;
    client.address = addressController.text;

    context.read<ClientBloc>().add(
          widget.client == null
              ? AddClient(client: client)
              : EditClient(client: client),
        );
    context.pop();
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.client?.name ?? '';
    emailController.text = widget.client?.email ?? '';
    phoneController.text = widget.client?.phone ?? '';
    addressController.text = widget.client?.address ?? '';

    client = Client(
      id: widget.client?.id ?? 0,
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      address: addressController.text,
    );
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
      resizeToAvoidBottomInset: false,
      appBar: Appbar(
        title: widget.client == null ? 'Create new client' : 'Edit client',
        right: widget.client == null
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
                onPressed: onEdit,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
