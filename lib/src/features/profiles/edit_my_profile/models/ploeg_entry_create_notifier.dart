import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/choice/providers/ploeg_type_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/choice/providers/ploeg_year_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/firebase_user.dart';

final ploegEntryCreateNotifierProvider =
    StateNotifierProvider<PloegEntryCreateNotifier, PloegEntryCreateForm>(
  (ref) {
    final currentUser = ref.watch(currentFirebaseUserProvider);
    final ploegType = ref.watch(ploegTypeProvider);
    final selectedYear = ref.watch(ploegYearProvider);

    return PloegEntryCreateNotifier(
      firstName: currentUser?.firstName ?? '',
      lastName: currentUser?.lastName ?? '',
      identifier: currentUser?.uid ?? '',
      ploegType: ploegType,
      year: selectedYear,
    );
  },
);

class PloegEntryCreateNotifier extends StateNotifier<PloegEntryCreateForm> {
  PloegEntryCreateNotifier({
    required String firstName,
    required String lastName,
    required String identifier,
    required PloegType ploegType,
    required int year,
  }) : super(PloegEntryCreateForm(
          firstName: firstName,
          lastName: lastName,
          identifier: identifier,
          ploegType: ploegType,
          role: PloegRole.roeier,
          year: year,
        ));

  void setPloegType(PloegType ploegType) {
    state = state.copyWith(ploegType: ploegType);
  }

  void setYear(int? year) {
    state = state.copyWith(year: year);
  }

  void setPloegName(String name) {
    state = state.copyWith(name: name);
  }

  void setRole(PloegRole role) {
    state = state.copyWith(role: role);
  }

  Future<void> createPloegEntry() {
    return FirebaseFirestore.instance
        .collection('people')
        .doc(state.identifier)
        .collection('groups')
        .withConverter<PloegEntryCreateForm>(
          fromFirestore: (snapshot, _) =>
              PloegEntryCreateForm.fromJson(snapshot.data()!),
          toFirestore: (ploegEntry, _) => ploegEntry.toJson(),
        )
        .add(state);
  }
}

class PloegEntryCreateForm {
  final PloegType ploegType;
  final int year;
  final String? name;
  final PloegRole role;
  final String firstName;
  final String lastName;
  final String identifier;

  PloegEntryCreateForm({
    required this.ploegType,
    required this.year,
    this.name,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.identifier,
  });

  PloegEntryCreateForm copyWith({
    PloegType? ploegType,
    int? year,
    String? name,
    PloegRole? role,
  }) {
    return PloegEntryCreateForm(
      firstName: firstName,
      identifier: identifier,
      lastName: lastName,
      ploegType: ploegType ?? this.ploegType,
      year: year ?? this.year,
      name: name ?? this.name,
      role: role ?? this.role,
    );
  }

  factory PloegEntryCreateForm.fromJson(Map<String, dynamic> json) {
    return PloegEntryCreateForm(
      firstName: json['firstName'],
      lastName: json['lastName'],
      identifier: json['identifier'],
      ploegType: PloegType.values.byName(json['ploegType']),
      year: json['year'],
      name: json['name'],
      role: PloegRole.values.byName(json['role']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'identifier': identifier,
      'ploegType': ploegType.name,
      'year': year,
      'name': name,
      'role': role.name,
      'type': 'ploeg',
    };
  }
}
