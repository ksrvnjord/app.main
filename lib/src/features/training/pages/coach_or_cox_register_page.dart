import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/training/api/coach_or_cox_provider.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/coach_or_cox_multiselect.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/coach_or_cox_save_button.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/coach_or_cox_single_question.dart';

class CoachOrCoxRegisterPage extends ConsumerStatefulWidget {
  const CoachOrCoxRegisterPage({
    super.key,
    required this.role,
  });

  final String role; // "coach" or "cox"

  @override
  ConsumerState<CoachOrCoxRegisterPage> createState() =>
      _CoachOrCoxRegisterPageState();
}

class _CoachOrCoxRegisterPageState
    extends ConsumerState<CoachOrCoxRegisterPage> {
  bool _initialized = false;
  bool _isRegistered = false;
  bool _isSaving = false;
  List<String> _preferences = [];

  List<String> get _allOptions => widget.role == 'coach'
      ? ['Boordroeien', 'Scullen']
      : ['C4', 'Gladde 4', '8'];

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Registratie ${widget.role}'),
      ),
      body: userAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        error: (err, _) => Center(child: Text('Fout bij laden: $err')),
        data: (user) {
          if (!_initialized) {
            _isRegistered = widget.role == 'coach'
                ? user.isRegisteredCoach
                : user.isRegisteredCox;

            _preferences = widget.role == 'coach'
                ? List.from(user.coachPreferences)
                : List.from(user.coxPreferences);

            _initialized = true;
          }

          // Determine if fields allow saving
          final isRegistering = _isRegistered;
          final canSave = (!isRegistering) ||
              (isRegistering &&
                  user.contact.phoneVisible &&
                  _preferences.isNotEmpty);

          String? warning;
          if (isRegistering) {
            if (!user.contact.phoneVisible) {
              warning =
                  'Je kunt geen coach of cox worden zolang je telefoonnummer niet zichtbaar is.';
            } else if (_preferences.isEmpty) {
              warning =
                  'Selecteer ten minste één voorkeur om zichtbaar te worden.';
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Registration toggle card
                CoachOrCoxSingleQuestion(
                  value: _isRegistered,
                  onChanged: (v) => setState(() => _isRegistered = v),
                  role: widget.role,
                ),

                // Preferences card
                CoachOrCoxMultiselect(
                  options: _allOptions,
                  selected: _preferences,
                  onChanged: (newPrefs) =>
                      setState(() => _preferences = newPrefs),
                  enabled: _isRegistered,
                  userPermissions:
                      user.firestorePermissions, // pass user permissions here
                ),

                const SizedBox(height: 16),

                // Save button
                CoachOrCoxSaveButton(
                  isSaving: _isSaving,
                  enabled: canSave,
                  onPressed: () => _saveChanges(user.identifierString),
                ),

                const SizedBox(
                  height: 16,
                ),

                if (warning != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.35)),
                      ),
                      child: Text(
                        warning,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red[700],
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _saveChanges(String userId) async {
    final repo = ref.read(coachCoxRepositoryProvider);

    setState(() => _isSaving = true);

    try {
      await repo.updateStatus(
        userId: userId,
        isCoach: widget.role == 'coach',
        isRegistered: _isRegistered,
        preferences: _preferences,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wijzigingen succesvol opgeslagen!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opslaan mislukt: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
