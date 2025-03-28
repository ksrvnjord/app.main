import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: avoid-importing-entrypoint-exports
import 'package:ksrvnjord_main_app/assets/asset_data.dart';
import 'package:ksrvnjord_main_app/src/features/shared/providers/asset_string_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyPage extends ConsumerWidget {
  const PrivacyPolicyPage({super.key});

  // ignore: avoid-dynamic
  void _handleTapUrlInMarkdown(_, String? url, __) {
    if (url == null) {
      return;
    }
    // Check if an URL is actually given.
    if (url.isNotEmpty) {
      // Convert url to URI.
      final uri = Uri.parse(url);
      // Launch url in separate browser.
      // ignore: avoid-ignoring-return-values, avoid-async-call-in-sync-function
      launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final privacyPolicyVal =
        ref.watch(assetStringProvider(AssetData.privacyPolicy));

    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Beleid')),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          privacyPolicyVal.when(
            data: (data) => MarkdownBody(
              data: data,
              onTapLink: _handleTapUrlInMarkdown,
              shrinkWrap: false,
              fitContent: false,
            ),
            error: (error, stackTrace) =>
                Center(child: ErrorTextWidget(errorMessage: error.toString())),
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
          ),
        ],
      ),
    );
  }
}
