import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_user_button_widget.dart';
import 'package:ksrvnjord_main_app/src/features/training/api/coach_or_cox_provider.dart';
import 'package:go_router/go_router.dart';

class CoachOrCoxSearchPage extends ConsumerWidget {
  const CoachOrCoxSearchPage({super.key, required this.role});

  final String role;

  List<String> get options =>
      role == 'coach' ? ['Boordroeien', 'Scullen'] : ['C4', 'Gladde 4', '8'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: options.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${role[0].toUpperCase()}${role.substring(1)} zoeken'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: TabBar(
                isScrollable: true,
                labelStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                unselectedLabelStyle: const TextStyle(fontSize: 16),
                tabs: options.map((opt) => Tab(text: opt)).toList(),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: options.map((preference) {
            // Step 1: Firestore fetch of identifiers
            final asyncUsers = ref.watch(
              usersByPreferenceProvider(
                CoachOrCoachSearchParams(role: role, preference: preference),
              ),
            );

            return asyncUsers.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) =>
                  Center(child: Text('Fout bij laden Firestore: $err')),
              data: (users) {
                if (users.isEmpty) {
                  return Center(
                      child: Text(
                          'Geen geregistreerde $role gevonden voor "$preference".'));
                }

                final identifiersForDjango =
                    users.map((u) => u['identifier'] as String).toList();
                final djangoAsync = ref.watch(
                  coachOrCoxDjangoUsersProvider(
                      CoachOrCoachDjangoSearchParams(identifiersForDjango)),
                );

                return djangoAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, _) =>
                      Center(child: Text('Fout bij laden DjangoUsers: $err')),
                  data: (djangoUsers) {
                    if (djangoUsers.isEmpty) {
                      return const Center(
                          child: Text('Geen gebruikers gevonden.'));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: djangoUsers.length,
                      itemBuilder: (context, index) {
                        final djangoUser = djangoUsers[index];
                        return AlmanakUserButtonWidget(
                          User(django: djangoUser),
                          onTap: () {
                            // Navigate to profile page
                            context.pushNamed(
                              "Lid",
                              pathParameters: {
                                "id": djangoUser.identifier.toString(),
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
