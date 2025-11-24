import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/field.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/no_data.dart';
import '../../../core/widgets/title_text.dart';
import '../bloc/item_bloc.dart';
import 'edit_item_screen.dart';
import '../widgets/item_tile.dart';

class ItemsList extends StatefulWidget {
  const ItemsList({super.key});

  @override
  State<ItemsList> createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  final searchController = TextEditingController();

  void onCreate() {
    context.push(
      EditItemScreen.routePath,
      extra: null,
    );
  }

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

        final sorted = query.isEmpty
            ? state.items
            : state.items.where((element) {
                return element.title.toLowerCase().contains(query);
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
                  child: sorted.isEmpty
                      ? NoData(
                          description:
                              'You haven’t created any items yet. Tap the button below to create your first one.',
                          buttonTitle: 'Create item',
                          onPressed: onCreate,
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: sorted.length,
                          itemBuilder: (context, index) {
                            final item = sorted[index];

                            return ItemTile(
                              item: item,
                              onPressed: () {
                                context.push(
                                  EditItemScreen.routePath,
                                  extra: item,
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
                  title: 'Add item',
                  onPressed: onCreate,
                ),
              ),
          ],
        );
      },
    );
  }
}
