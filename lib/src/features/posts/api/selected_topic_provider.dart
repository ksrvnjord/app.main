import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/post_topics_provider.dart';

// Default topic is "Wandelgangen"
final selectedTopicProvider = StateProvider<String>((ref) {
  return ref.watch(postTopicsProvider).firstWhere((e) => e == "Wandelgangen");
});
