// ignore_for_file: prefer-single-declaration-per-file

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/events/api/event_service.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CreateEventPage extends ConsumerStatefulWidget {
  const CreateEventPage({super.key});

  @override
  CreateEventPageState createState() => CreateEventPageState();
}

class CreateEventPageState extends ConsumerState<CreateEventPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _startHourController = TextEditingController();
  final TextEditingController _startMinuteController = TextEditingController();
  final TextEditingController _endHourController = TextEditingController();
  final TextEditingController _endMinuteController = TextEditingController();

  String title = '';
  String description = '';
  DateTime? startDateTime;
  DateTime? endDateTime;
  String eventType = 'overig';
  bool isCreating = false;

  final eventTypes = ['borrel', 'wedstrijd', 'competitie', 'overig'];

  final typeColorMapping = {
    'borrel': const Color(0xFF008200),
    'wedstrijd': const Color(0xFF1565C0),
    'competitie': const Color(0xFFC62828),
    'overig': const Color(0xFFB8860B),
  };

  @override
  void dispose() {
    _startHourController.dispose();
    _startMinuteController.dispose();
    _endHourController.dispose();
    _endMinuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final currentUserVal = ref.watch(currentUserNotifierProvider);

    // Check if user is admin
    if (currentUserVal == null || !currentUserVal.isAdmin) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => context.goNamed("Events"),
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: const Text('Nieuw Evenement'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Geen toegang',
                style: textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Alleen beheerders kunnen evenementen aanmaken',
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // User is admin, show form
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => context.goNamed("Events"),
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: const Text('Nieuw Evenement'),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Event Type Dropdown
              DropdownButtonFormField<String>(
                value: eventType,
                items: eventTypes
                    .map((type) => DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => eventType = value ?? 'overig');
                },
                decoration: const InputDecoration(
                  labelText: 'Type Evenement',
                  hintText: 'Selecteer een type',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null ? 'Selecteer alsjeblieft een type' : null,
              ),
              const SizedBox(height: 16),

              // Title Field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Titel',
                  hintText: 'bijv. Hollandia roeiwedstrijden',
                  border: OutlineInputBorder(),
                ),
                maxLength: 100,
                onSaved: (value) => title = value ?? '',
                validator: (value) => value == null || value.isEmpty
                    ? 'Titel is verplicht'
                    : null,
              ),
              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Beschrijving',
                  hintText: 'Voeg details toe over het evenement',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                maxLength: 500,
                onSaved: (value) => description = value ?? '',
              ),
              const SizedBox(height: 16),

              // Start Date
              Text('Start Datum', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectStartDate,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        startDateTime == null
                            ? 'Selecteer start datum'
                            : '${startDateTime!.day}/${startDateTime!.month}/${startDateTime!.year}',
                      ),
                      const Icon(LucideIcons.calendar),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Start Time (Hours and Minutes)
              Text('Start Tijd', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _startHourController,
                      decoration: const InputDecoration(
                        labelText: 'Uren',
                        hintText: '17',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _startMinuteController,
                      decoration: const InputDecoration(
                        labelText: 'Minuten',
                        hintText: '26',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // End Date
              Text('Eind Datum', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectEndDate,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        endDateTime == null
                            ? 'Selecteer eind datum'
                            : '${endDateTime!.day}/${endDateTime!.month}/${endDateTime!.year}',
                      ),
                      const Icon(LucideIcons.calendar),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // End Time (Hours and Minutes)
              Text('Eind Tijd', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _endHourController,
                      decoration: const InputDecoration(
                        labelText: 'Uren',
                        hintText: '17',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _endMinuteController,
                      decoration: const InputDecoration(
                        labelText: 'Minuten',
                        hintText: '26',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
        floatingActionButton: isCreating
            ? FloatingActionButton(
                onPressed: null,
                child: const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : FloatingActionButton.extended(
                onPressed: _submitForm,
                icon: const Icon(LucideIcons.send),
                label: const Text('Evenement Maken'),
              ),
      ),
    );
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: startDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date == null) return;

    setState(() {
      startDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        startDateTime?.hour ?? 0,
        startDateTime?.minute ?? 0,
      );
    });
  }

  Future<void> _selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: endDateTime ?? DateTime.now().add(const Duration(hours: 2)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date == null) return;

    setState(() {
      endDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        endDateTime?.hour ?? 0,
        endDateTime?.minute ?? 0,
      );
    });
  }

  Future<void> _submitForm() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) return;

    // Parse hours and minutes from text fields
    final startHour = int.tryParse(_startHourController.text) ?? 0;
    final startMinute = int.tryParse(_startMinuteController.text) ?? 0;
    final endHour = int.tryParse(_endHourController.text) ?? 0;
    final endMinute = int.tryParse(_endMinuteController.text) ?? 0;

    if (startDateTime == null || endDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecteer start en eind datum')),
      );
      return;
    }

    // Create final DateTime with selected times
    final finalStartDateTime = DateTime(
      startDateTime!.year,
      startDateTime!.month,
      startDateTime!.day,
      startHour,
      startMinute,
    );

    final finalEndDateTime = DateTime(
      endDateTime!.year,
      endDateTime!.month,
      endDateTime!.day,
      endHour,
      endMinute,
    );

    if (finalEndDateTime.isBefore(finalStartDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Eind tijd moet na start tijd zijn')),
      );
      return;
    }

    formState.save();
    setState(() => isCreating = true);

    try {
      await EventService.create(
        title: title,
        description: description,
        startTime: Timestamp.fromDate(finalStartDateTime),
        endTime: Timestamp.fromDate(finalEndDateTime),
        color: typeColorMapping[eventType] ?? const Color(0xFFB8860B),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evenement aangemaakt!')),
        );
        context.goNamed('Events');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fout bij maken evenement: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isCreating = false);
      }
    }
  }
}
