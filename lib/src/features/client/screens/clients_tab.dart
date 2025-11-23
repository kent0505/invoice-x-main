import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/field.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/no_data.dart';
import '../../../core/widgets/title_text.dart';
import '../bloc/client_bloc.dart';
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

  void onCreateClient() {
    context.push(CreateClientScreen.routePath);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientBloc, ClientState>(
      builder: (context, state) {
        final clients = state.clients;

        final query = searchController.text.toLowerCase();

        final sorted = query.isEmpty
            ? clients
            : clients.where((client) {
                final name = client.name.toLowerCase();
                final email = client.email.toLowerCase();

                return name.contains(query) || email.contains(query);
              }).toList();

        return Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: Field(
                    controller: searchController,
                    onChanged: (_) {
                      setState(() {});
                    },
                    hintText: 'Search by client name...',
                    asset: Assets.search,
                  ),
                ),
                const SizedBox(height: 8),
                const TitleText(
                  title: 'All created clients',
                  left: 16,
                ),
                Expanded(
                  child: sorted.isEmpty
                      ? NoData(
                          description:
                              'You haven’t created any clients yet. Tap the button below to create your first one.',
                          buttonTitle: 'Create client',
                          onPressed: onCreateClient,
                        )
                      : ListView.builder(
                          padding:
                              const EdgeInsets.all(16).copyWith(bottom: 100),
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
              ],
            ),
            if (sorted.isNotEmpty)
              Positioned(
                right: 10,
                bottom: 10,
                child: MainButton(
                  title: 'Create client',
                  onPressed: onCreateClient,
                ),
              ),
          ],
        );
      },
    );
  }
}
