import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/main_button.dart';
import '../../home/screens/home_screen.dart';
import '../../onboard/data/onboard_repository.dart';

class DefaultTemplateScreen extends StatefulWidget {
  const DefaultTemplateScreen({super.key});

  static const routePath = '/DefaultTemplateScreen';

  @override
  State<DefaultTemplateScreen> createState() => _DefaultTemplateScreenState();
}

class _DefaultTemplateScreenState extends State<DefaultTemplateScreen> {
  int id = 0;

  void onTemplate(int value) {
    setState(() {
      value == id ? id = 0 : id = value;
    });
  }

  void onSave() async {
    final repo = context.read<OnboardRepository>();
    await repo.setTemplatedID(id);
    await repo.removeOnboard();
    if (mounted) {
      context.replace(
        HomeScreen.routePath,
        extra: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Template'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(16),
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1 / 1.414,
              children: [
                _TemplateCard(
                  id: 1,
                  current: id,
                  asset: Assets.template1,
                  onPressed: onTemplate,
                ),
                _TemplateCard(
                  id: 2,
                  current: id,
                  asset: Assets.template2,
                  onPressed: onTemplate,
                ),
                _TemplateCard(
                  id: 3,
                  current: id,
                  asset: Assets.template3,
                  onPressed: onTemplate,
                ),
                _TemplateCard(
                  id: 4,
                  current: id,
                  asset: Assets.template4,
                  onPressed: onTemplate,
                ),
                _TemplateCard(
                  id: 5,
                  current: id,
                  asset: Assets.template5,
                  onPressed: onTemplate,
                ),
                _TemplateCard(
                  id: 6,
                  current: id,
                  asset: Assets.template6,
                  onPressed: onTemplate,
                ),
                _TemplateCard(
                  id: 7,
                  current: id,
                  asset: Assets.template7,
                  onPressed: onTemplate,
                ),
                _TemplateCard(
                  id: 8,
                  current: id,
                  asset: Assets.template8,
                  onPressed: onTemplate,
                ),
                _TemplateCard(
                  id: 9,
                  current: id,
                  asset: Assets.template9,
                  onPressed: onTemplate,
                ),
                _TemplateCard(
                  id: 10,
                  current: id,
                  asset: Assets.template10,
                  onPressed: onTemplate,
                ),
              ],
            ),
          ),
          MainButtonWrapper(
            children: [
              MainButton(
                title: 'Save',
                active: id != 0,
                onPressed: onSave,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({
    required this.id,
    required this.current,
    required this.asset,
    required this.onPressed,
  });

  final int id;
  final int current;
  final String asset;
  final void Function(int) onPressed;

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: () {
        onPressed(id);
      },
      child: Stack(
        children: [
          ImageWidget(
            asset,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          if (id == current)
            const Center(
              child: Icon(
                Icons.check_circle,
                color: Color(0xffFF4400),
                size: 30,
              ),
            ),
        ],
      ),
    );
  }
}
