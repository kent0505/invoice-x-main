import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/field.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/no_data.dart';
import '../bloc/client_bloc.dart';
import '../models/client.dart';
import '../widgets/client_tile.dart';
import 'create_client_screen.dart';
import 'edit_client_screen.dart';

class ClientsTab extends StatefulWidget {
  const ClientsTab({super.key});

  @override
  State<ClientsTab> createState() => _ClientsTabState();
}

class _ClientsTabState extends State<ClientsTab> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientBloc, List<Client>>(
      builder: (context, clients) {
        clients = clients.reversed.toList();

        final query = searchController.text.toLowerCase();

        final sorted = query.isEmpty
            ? clients
            : clients.where((client) {
                return client.name.toLowerCase().contains(query.toLowerCase());
              }).toList();

        return Stack(
          children: [
            Positioned(
              top: 8,
              left: 16,
              right: 16,
              child: Field(
                controller: searchController,
                onChanged: (_) {
                  setState(() {});
                },
                hintText: 'Search client',
                asset: Assets.search,
              ),
            ),
            sorted.isEmpty
                ? NoData(
                    description:
                        'You haven’t created any clients yet. Tap the button below to create your first one.',
                    buttonTitle: 'Create client',
                    onPressed: () {
                      context.push(CreateClientScreen.routePath);
                    },
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 64),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16).copyWith(bottom: 100),
                      itemCount: sorted.length,
                      itemBuilder: (context, index) {
                        final client = sorted[index];

                        return ClientTile(
                          client: client,
                          onPressed: () {
                            context.push(
                              EditClientScreen.routePath,
                              extra: client,
                            );
                          },
                        );
                      },
                    ),
                  ),
            if (sorted.isNotEmpty)
              Positioned(
                right: 10,
                bottom: 10,
                child: MainButton(
                  title: 'Create client',
                  onPressed: () {},
                ),
              ),
          ],
        );
      },
    );
  }
}
