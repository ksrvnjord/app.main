class Slot {
  final int id = 0;
  final DateTime from;
  final Duration length;

  const Slot({required this.from, required this.length});
}

class Boot {
  final int id = 0;
  final String name;
  final String label;
  final List<Slot> slots;

  const Boot({required this.name, required this.label, required this.slots});
}

Future<List<Boot>?> reservedSlots(
  List<String> filters,
) async {
  List<Boot> boats = [
    const Boot(name: 'Zephyr', label: 'vieren', slots: []),
    const Boot(name: 'Prins Hendrik', label: 'vieren', slots: []),
    const Boot(name: 'Cor Hulskes', label: 'vieren', slots: []),
    Boot(name: 'Cas', label: 'tweeen', slots: [
      Slot(
        from: DateTime.now().add(const Duration(hours: 1)),
        length: const Duration(hours: 3),
      ),
    ]),
    const Boot(name: 'Mat', label: 'landtraining', slots: []),
  ];

  return boats.where((e) => filters.contains(e.label)).toList();
}
