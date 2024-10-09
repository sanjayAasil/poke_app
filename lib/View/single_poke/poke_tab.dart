import 'package:flutter/material.dart';
import 'package:poke_app/View/single_poke/forms_tab.dart';

import '../../Model/poke.dart';

class PokeTab extends StatefulWidget {
  final Poke poke;

  const PokeTab({super.key, required this.poke});

  @override
  State<PokeTab> createState() => _PokeTabState();
}

class _PokeTabState extends State<PokeTab> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: tabController,
          isScrollable: true,
          dividerColor: Colors.transparent,
          indicatorColor: Colors.transparent,
          tabAlignment: TabAlignment.start,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.black,
            fontSize: 16.0,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black.withOpacity(0.5),
            fontSize: 14.0,
          ),
          tabs: const [
            Tab(text: 'Forms'),
            Tab(text: 'Detail'),
            Tab(text: 'Types'),
            Tab(text: 'Stats'),
            Tab(text: 'Weather'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              SingleChildScrollView(
                child: FormsTab(poke: widget.poke),
              ),
              const SizedBox(),
              const SizedBox(),
              const SizedBox(),
              const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
