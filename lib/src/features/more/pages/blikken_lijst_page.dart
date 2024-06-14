import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/blikkenlijst_tab_content.dart';

class BlikkenLijstPage extends StatelessWidget {
  const BlikkenLijstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const amountOfTabs = 2;

    return DefaultTabController(
      length: amountOfTabs,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Eeuwige Blikkenlijst'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Blikkenlijst'),
              Tab(text: 'Stuurblikkenlijst'),
            ],
          ),
        ),
        body: const TabBarView(
          // ignore: sort_child_properties_last
          children: [
            BlikkenLijstTabContent(blikType: 'regulier'),
            BlikkenLijstTabContent(blikType: 'stuur'),
          ],
        ),
      ),
    );
  }
}
