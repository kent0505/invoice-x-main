import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../features/client/models/client.dart';
import 'widgets/snack_widget.dart';

void logger(Object message) => developer.log(message.toString());

bool isIOS() {
  return Platform.isIOS;
}

int getTimestamp() {
  return DateTime.now().millisecondsSinceEpoch;
}

String formatTimestamp(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return DateFormat('d MMMM yyyy').format(date);
}

String formatTimestamp2(int timestamp) {
  if (timestamp == 0) return '';
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return DateFormat('dd.MM.yyyy').format(date);
}

Future<XFile> pickImage() async {
  final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (image == null) return XFile('');
  return image;
}

Future<List<XFile>> pickImages() async {
  final image = await ImagePicker().pickMultiImage(limit: 6);
  return image;
}

String formatInvoiceNumber(int number) {
  return number.toString().padLeft(3, '0');
}

bool checkControllers(List<TextEditingController> controllers) {
  return controllers.every((element) => element.text.isNotEmpty);
}

Future<Client> getContact(BuildContext context) async {
  final isGranted = await FlutterContacts.requestPermission(readonly: true);
  if (isGranted) {
    await FlutterContacts.requestPermission();
    final contact = await FlutterContacts.openExternalPick();
    if (contact != null) {
      return Client(
        id: 0,
        billTo: '',
        name: '${contact.name.first} ${contact.name.last}',
        phone: contact.phones.isNotEmpty ? contact.phones[0].number : '',
        email: contact.emails.isNotEmpty ? contact.emails[0].address : '',
        address:
            contact.addresses.isNotEmpty ? contact.addresses[0].address : '',
      );
    }
  }
  if (context.mounted) {
    SnackWidget.show(
      context,
      message: 'Contact permission not granted',
    );
  }
  return Client(id: 0, billTo: '', name: '', phone: '', email: '', address: '');
}

extension FirstWhereOrNullExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
