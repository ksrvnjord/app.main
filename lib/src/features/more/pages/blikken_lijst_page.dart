import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/more/api/get_blikkenlijst.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/blikkenlijst_item.dart';

class BlikkenLijstPage extends ConsumerStatefulWidget {
  const BlikkenLijstPage({super.key});

  @override
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
          // Blikkenlijst tab content
          blikkenLijstState.when(
            data: (data) => ListView.builder(
              itemCount: data.docs.length,
              itemBuilder: (context, index) =>
                  BlikkenLijstItem(document: data.docs[index]),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Error: $error')),
          ),
          // Stuurblikkenlijst tab content
          blikkenLijstState.when(
            data: (data) => ListView.builder(
              itemCount: data.docs.length,
              itemBuilder: (context, index) =>
                  BlikkenLijstItem(document: data.docs[index]),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Error: $error')),
          ),
        ],
      ),
    );
  }
}
