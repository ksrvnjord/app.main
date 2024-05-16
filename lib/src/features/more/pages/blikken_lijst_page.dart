import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/more/api/get_blikkenlijst.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/blikkenlijst_tab_content.dart';

class BlikkenLijstPage extends ConsumerStatefulWidget {
  const BlikkenLijstPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BlikkenLijstPageState createState() => _BlikkenLijstPageState();
}

class _BlikkenLijstPageState extends ConsumerState<BlikkenLijstPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    ref.read(blikkenLijstProvider.notifier).fetchBlikkenLijst('regulier');
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      ref
          .read(blikkenLijstProvider.notifier)
          .fetchBlikkenLijst(_tabController.index == 0 ? 'regulier' : 'stuur');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blikkenLijstState = ref.watch(blikkenLijstProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eeuwige Blikkenlijst'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Blikkenlijst'),
            Tab(text: 'Stuurblikkenlijst'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BlikkenLijstTabContent(
            state: blikkenLijstState,
            type: 'regulier',
          ),
          BlikkenLijstTabContent(
            state: blikkenLijstState,
            type: 'stuur',
          ),
        ],
      ),
    );
  }
}
