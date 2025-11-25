import 'package:flutter/material.dart';

import '../constants.dart';

class TabWidget extends StatefulWidget {
  const TabWidget({
    super.key,
    required this.titles,
    required this.pages,
  }) : assert(titles.length == pages.length);

  final List<String> titles;
  final List<Widget> pages;

  @override
  State<TabWidget> createState() => _TabWidgetState();
}

class _TabWidgetState extends State<TabWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.titles.length,
      animationDuration: const Duration(milliseconds: Constants.milliseconds),
      vsync: this,
    );
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Column(
      children: [
        Container(
          height: 40,
          width: 218,
          padding: const EdgeInsets.all(4),
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: colors.tertiary1,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.label,
            labelPadding: EdgeInsets.zero,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: _tabController.index == _selectedIndex ? colors.bg : null,
            ),
            labelStyle: TextStyle(
              color: colors.text,
              fontSize: 16,
              fontFamily: AppFonts.w500,
            ),
            unselectedLabelStyle: TextStyle(
              color: colors.text,
              fontSize: 16,
              fontFamily: AppFonts.w400,
            ),
            tabs: List.generate(
              widget.titles.length,
              (index) {
                return Tab(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    height: 32,
                    alignment: Alignment.center,
                    child: Text(
                      widget.titles[index],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.pages,
          ),
        ),
      ],
    );
  }
}
