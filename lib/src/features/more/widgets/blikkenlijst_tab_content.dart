import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/more/api/blikkenlijst_controller.dart';

class BlikkenLijstTabContent extends ConsumerStatefulWidget {
  const BlikkenLijstTabContent({super.key, required this.blikType});

  final String blikType;

  @override
  ConsumerState<BlikkenLijstTabContent> createState() =>
      _BlikkenLijstTabContentState();
}

class _BlikkenLijstTabContentState
    extends ConsumerState<BlikkenLijstTabContent> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!mounted) return; // Prevent updates after dispose

    final state = ref.read(blikkenLijstProvider(widget.blikType));
    final controller = ref.read(blikkenLijstProvider(widget.blikType).notifier);

    final almostAtEndOfList = _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500; // Increased threshold

    if (almostAtEndOfList &&
        !state.isLoading &&
        state.documents.length < (state.totalCount ?? double.infinity)) {
      controller.fetchPage(widget.blikType, state.currentPage + 1);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(blikkenLijstProvider(widget.blikType));

    if (state.documents.isEmpty && state.isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (state.documents.isEmpty && !state.isLoading) {
      return const Center(child: Text('Niemand gevonden'));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: RepaintBoundary(
          child: Column(
            children: [
              // Header row
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: const [
                    SizedBox(
                      width: 150,
                      child: Text('Naam',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      width: 100,
                      child: Text('Blikken',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      width: 100,
                      child: Text('Premies',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      width: 100,
                      child: Text('Periode',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              // Data rows
              ...List.generate(
                state.documents.length,
                (index) {
                  final doc = state.documents.elementAt(index);
                  final data = doc.data() as Map<String, dynamic>? ?? {};

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 150,
                          child: Text(data['name'] ?? ''),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text('${data['blikken'] ?? 0}'),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text('${data['premies'] ?? 0}'),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(data['period'] ?? ''),
                        ),
                      ],
                    ),
                  );
                },
              ),
              // Loading indicator at the bottom
              if (state.isLoading)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator.adaptive(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
