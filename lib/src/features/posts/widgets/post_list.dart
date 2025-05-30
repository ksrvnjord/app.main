import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/posts_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/selected_topic_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/post_card.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_text_widget.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class PostList extends ConsumerWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTopic = ref.watch(selectedTopicProvider);

    final postsVal = ref.watch(postsProvider(selectedTopic));

    return postsVal.when(
      data: (posts) {
        const sponsorImageHeight = 80.0;

        return posts.docs.isEmpty
            ? const Center(child: Text('No posts'))
            : ListView(
                padding: const EdgeInsets.only(bottom: 80),
                children: [
                  [
                    Text(
                      "Advertentie",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          launchUrl(Uri.parse("https://bohemianbirds.com/")),
                      child: Image.asset(
                        'assets/images/sponsors/bohemian_birds_no_bg_${Theme.of(context).brightness.name == "dark" ? "white" : "black"}.png',
                        height: sponsorImageHeight,
                      ),
                    ),
                  ].toColumn(),
                  const Divider(),
                  for (final post in posts.docs) PostCard(snapshot: post),
                ],
              );
      },
      error: (error, _) =>
          Center(child: ErrorTextWidget(errorMessage: error.toString())),
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
