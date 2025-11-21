import 'package:flutter/material.dart';

import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/image_widget.dart';
import '../models/photo.dart';

class PhotoScreen extends StatelessWidget {
  const PhotoScreen({super.key, required this.photo});

  final Photo photo;

  static const routePath = '/PhotoScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(title: 'Photo'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ImageWidget(
            photo.path,
            file: true,
          ),
        ],
      ),
    );
  }
}
