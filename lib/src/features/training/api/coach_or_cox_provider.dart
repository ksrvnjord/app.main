import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/django_user.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/dio_provider.dart';

final coachCoxRepositoryProvider = Provider((ref) => CoachCoxRepository());

class CoachCoxRepository {
  final _db = FirebaseFirestore.instance;

  Future<void> updateStatus({
    required String userId,
    required bool isCoach,
    required bool isRegistered,
    required List<String> preferences,
  }) async {
    final docRef = _db.collection('people').doc(userId);

    final Map<String, dynamic> updatedFields = {};
    if (isCoach) {
      updatedFields['isRegisteredCoach'] = isRegistered;
      updatedFields['coachPreferences'] = preferences;
    } else {
      updatedFields['isRegisteredCox'] = isRegistered;
      updatedFields['coxPreferences'] = preferences;
    }

    await docRef.update(updatedFields);
  }

  /// Fetch users by role & preference
  Future<List<Map<String, dynamic>>> fetchByPreference({
    required String role,
    required String preference,
  }) async {
    final query = _db.collection('people');

    Query<Map<String, dynamic>> filteredQuery;

    if (role == 'coach') {
      filteredQuery = query
          .where('isRegisteredCoach', isEqualTo: true)
          .where('coachPreferences', arrayContains: preference);
    } else {
      filteredQuery = query
          .where('isRegisteredCox', isEqualTo: true)
          .where('coxPreferences', arrayContains: preference);
    }

    final snapshot = await filteredQuery.get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final identifier = data['identifier'] ?? doc.id;
      return {'id': doc.id, 'identifier': identifier};
    }).toList();
  }
}

/// Family provider for fetching users by preference
final usersByPreferenceProvider =
    FutureProvider.family<List<Map<String, dynamic>>, CoachOrCoachSearchParams>(
  (ref, params) {
    final repository = ref.read(coachCoxRepositoryProvider);
    return repository.fetchByPreference(
      role: params.role,
      preference: params.preference,
    );
  },
);

class CoachOrCoachSearchParams {
  const CoachOrCoachSearchParams(
      {required this.role, required this.preference});
  final String role;
  final String preference;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoachOrCoachSearchParams &&
          runtimeType == other.runtimeType &&
          role == other.role &&
          preference == other.preference;

  @override
  int get hashCode => role.hashCode ^ preference.hashCode;
}

class CoachOrCoachDjangoSearchParams {
  CoachOrCoachDjangoSearchParams(this.ids);
  final List<String> ids;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoachOrCoachDjangoSearchParams &&
          const ListEquality().equals(ids, other.ids);

  @override
  int get hashCode => const ListEquality().hash(ids);
}

final coachOrCoxDjangoUsersProvider =
    FutureProvider.family<List<DjangoUser>, CoachOrCoachDjangoSearchParams>(
        (ref, identifierList) async {
  if (identifierList.ids.isEmpty) return [];

  final dio = ref.read(dioProvider);

  final res = await dio.get("/api/v2/users/", queryParameters: {
    "restrict_to_ids": identifierList.ids,
  });

  final List<dynamic> data = res.data['items'] ?? [];
  return data.map((json) => DjangoUser.fromJson(json)).toList();
});
