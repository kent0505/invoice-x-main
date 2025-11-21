import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/no_data.dart';
import '../../../core/widgets/search_field.dart';
import '../bloc/item_bloc.dart';
import '../models/item.dart';
import '../widgets/item_tile.dart';
import 'create_item_screen.dart';
import 'edit_item_screen.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key, required this.select});

  final bool select;

  static const routePath = '/ItemsScreen';

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final searchController = TextEditingController();

  void onSearch(String _) {
    setState(() {});
  }

  void onItem(Item item) {
    widget.select
        ? context.pop(item)
        : context.push(
            EditItemScreen.routePath,
            extra: item,
          );
  }

  void onCreate() async {
    Item? item = await context.push<Item?>(
      CreateItemScreen.routePath,
      extra: widget.select,
    );
    if (widget.select && mounted) context.pop(item);
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
      appBar: const Appbar(title: 'Items'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SearchField(
              controller: searchController,
              onChanged: onSearch,
            ),
          ),
          Expanded(
            child: BlocBuilder<ItemBloc, List<Item>>(
              builder: (context, items) {
                items = items.where((element) {
                  return element.invoiceID == 0;
                }).toList();

                items = items.reversed.toList();

                final sorted = searchController.text.isEmpty
                    ? items
                    : items.where((client) {
                        return client.title
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase());
                      }).toList();

                return sorted.isEmpty
                    ? const NoData()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: sorted.length,
                        itemBuilder: (context, index) {
                          final item = sorted[index];

                          return ItemTile(
                            item: item,
                            onPressed: () {
                              onItem(item);
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
