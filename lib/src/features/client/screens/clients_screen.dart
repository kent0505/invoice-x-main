import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/field.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/no_data.dart';
import '../bloc/client_bloc.dart';
import '../models/client.dart';
import '../widgets/client_tile.dart';
import 'create_client_screen.dart';
import 'edit_client_screen.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key, required this.select});

  final bool select;

  static const routePath = '/ClientsScreen';

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final searchController = TextEditingController();

  void onSearch(String _) {
    setState(() {});
  }

  void onClient(Client client) {
    widget.select
        ? context.pop(client)
        : context.push(
            EditClientScreen.routePath,
            extra: client,
          );
  }

  void onCreate() {
    context.push(CreateClientScreen.routePath);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const Appbar(title: 'Clients'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Field(
              controller: searchController,
              onChanged: onSearch,
              hintText: 'Search client',
              asset: Assets.search,
            ),
          ),
          Expanded(
            child: BlocBuilder<ClientBloc, ClientState>(
              builder: (context, state) {
                final clients = state.clients;

                final query = searchController.text.toLowerCase();

                final sorted = query.isEmpty
                    ? clients
                    : clients.where((client) {
                        return client.name.toLowerCase().contains(query);
                      }).toList();

                return sorted.isEmpty
                    ? NoData(
                        description:
                            'You haven’t created any clients yet. Tap the button below to create your first one.',
                        buttonTitle: 'Create client',
                        onPressed: () {},
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: sorted.length,
                        itemBuilder: (context, index) {
                          final client = sorted[index];

                          return ClientTile(
                            client: client,
                            onPressed: () {
                              onClient(client);
                            },
                          );
                        },
                      );
              },
            ),
          ),
          MainButtonWrapper(
            children: [
              MainButton(
                title: 'Create',
                onPressed: onCreate,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
