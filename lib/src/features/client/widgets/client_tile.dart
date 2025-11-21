import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/button.dart';
import '../models/client.dart';

class ClientTile extends StatelessWidget {
  const ClientTile({
    super.key,
    required this.client,
    required this.onPressed,
  });

  final Client client;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: onPressed,
      child: Container(
        height: 44,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.5,
              color: Color(0xff7D81A3),
            ),
          ),
        ),
        child: Row(
          children: [
            Text(
              client.name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: AppFonts.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
