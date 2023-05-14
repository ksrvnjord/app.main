import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/firebase_user.dart';

final ploegEntryCreateNotifierProvider =
    StateNotifierProvider<PloegEntryCreateNotifier, PloegEntryCreateForm>(
  (ref) {
    final u = ref.watch(currentFirebaseUserProvider);

    return PloegEntryCreateNotifier(
      firstName: u!.firstName,
      lastName: u.lastName,
      identifier: u.uid,
    );
  },
);

class PloegEntryCreateNotifier extends StateNotifier<PloegEntryCreateForm> {
  PloegEntryCreateNotifier({
    required String firstName,
    required String lastName,
    required String identifier,
  }) : super(PloegEntryCreateForm(
          firstName: firstName,
          lastName: lastName,
          identifier: identifier,
        ));

  void setPloegType(PloegType? ploegType) {
    state = state.copyWith(ploegType: ploegType);
  }

  void setYear(int? year) {
    state = state.copyWith(year: year);
  }

  void setName(String? name) {
    state = state.copyWith(name: name);
  }

  void setFirstName(String? firstName) {
    state = state.copyWith(firstName: firstName);
  }

  void setLastName(String? lastName) {
    state = state.copyWith(lastName: lastName);
  }

  void setIdentifier(String? identifier) {
    state = state.copyWith(identifier: identifier);
  }
}

class PloegEntryCreateForm {
  final PloegType? ploegType;
  final int? year;
  final String? name;
  final String firstName;
  final String lastName;
  final String identifier;

  PloegEntryCreateForm({
    this.ploegType,
    this.year,
    this.name,
    required this.firstName,
    required this.lastName,
    required this.identifier,
  });

  PloegEntryCreateForm copyWith({
    PloegType? ploegType,
    int? year,
    String? name,
    String? firstName,
    String? lastName,
    String? identifier,
  }) {
    return PloegEntryCreateForm(
      ploegType: ploegType ?? this.ploegType,
      year: year ?? this.year,
      name: name ?? this.name,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      identifier: identifier ?? this.identifier,
    );
  }
}
