import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/more/api/get_blikkenlijst.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/blikkenlijst_item.dart';

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
          // Blikkenlijst tab content
          blikkenLijstState.when(
            data: (docs) {
              if (docs.isEmpty) {
                return const Center(child: Text('Niemand gevonden'));
              } else {
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    if (index >= docs.length - 1) {
                      ref
                          .read(blikkenLijstProvider.notifier)
                          .fetchMoreBlikkenLijst(
                              _tabController.index == 0 ? 'regulier' : 'stuur');
                    }
                    return BlikkenLijstItem(document: docs[index]);
                  },
                );
              }
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Error: $error')),
          ),
          // Stuurblikkenlijst tab content
          blikkenLijstState.when(
            data: (data) {
              if (data.isEmpty) {
                return const Center(child: Text('Niemand gevonden'));
              } else {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    if (index >= data.length - 15) {
                      ref
                          .read(blikkenLijstProvider.notifier)
                          .fetchMoreBlikkenLijst(
                              _tabController.index == 0 ? 'regulier' : 'stuur');
                    }
                    return BlikkenLijstItem(document: data[index]);
                  },
                );
              }
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Error: $error')),
          ),
        ],
      ),
    );
  }
}
