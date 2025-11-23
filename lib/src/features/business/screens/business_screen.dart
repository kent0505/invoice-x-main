import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/field.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/no_data.dart';
import '../../../core/widgets/title_text.dart';
import '../bloc/business_bloc.dart';
import '../widgets/business_tile.dart';
import 'edit_business_screen.dart';

class BusinessScreen extends StatefulWidget {
  const BusinessScreen({super.key});

  static const routePath = '/BusinessScreen';

  @override
  State<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {
  final searchController = TextEditingController();

  void onCreate() {
    context.push(
      EditBusinessScreen.routePath,
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
    return BlocBuilder<BusinessBloc, BusinessState>(
      builder: (context, state) {
        final businesses = state.businesses;

        final query = searchController.text.toLowerCase();

        final sorted = query.isEmpty
            ? businesses
            : businesses.where((business) {
                return business.name.toLowerCase().contains(query);
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
                    hintText: 'Search by business name...',
                    asset: Assets.search,
                  ),
                ),
                const SizedBox(height: 8),
                const TitleText(
                  title: 'All created accounts',
                  left: 16,
                ),
                Expanded(
                  child: sorted.isEmpty
                      ? NoData(
                          description:
                              'You haven’t created any business account yet. Tap the button below to create your first one.',
                          buttonTitle: 'Create account',
                          onPressed: onCreate,
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16).copyWith(
                            bottom: 100,
                          ),
                          itemCount: sorted.length,
                          itemBuilder: (context, index) {
                            final business = sorted[index];

                            return BusinessTile(
                              business: business,
                              onPressed: () {
                                context.push(
                                  EditBusinessScreen.routePath,
                                  extra: business,
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
                  title: 'Create account',
                  onPressed: onCreate,
                ),
              ),
          ],
        );
      },
    );
  }
}
