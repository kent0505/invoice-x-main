import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/field.dart';
import '../../../core/widgets/no_data.dart';
import '../../../core/widgets/title_text.dart';
import '../bloc/item_bloc.dart';
import '../screens/create_item_screen.dart';
import 'item_tile.dart';

class ItemsList extends StatefulWidget {
  const ItemsList({super.key});

  @override
  State<ItemsList> createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemBloc, ItemState>(
      builder: (context, state) {
        final query = searchController.text.toLowerCase();

        final items = query.isEmpty
            ? state.items
            : state.items.where((element) {
                return element.title.toLowerCase().contains(query);
              }).toList();

        return Column(
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
                hintText: 'Search by item name...',
                asset: Assets.search,
              ),
            ),
            const SizedBox(height: 8),
            const TitleText(
              title: 'All created items',
              left: 16,
            ),
            Expanded(
              child: items.isEmpty
                  ? NoData(
                      description:
                          'You haven’t created any items yet. Tap the button below to create your first one.',
                      buttonTitle: 'Create item',
                      onPressed: () {
                        context.push(
                          CreateItemScreen.routePath,
                          extra: false,
                        );
                      },
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return ItemTile(
                          item: items[index],
                          onPressed: () {},
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
