import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreLinkTile extends StatelessWidget {
  const MoreLinkTile({
    super.key,
    required this.label,
    required this.url,
  });

  final String label;
  final String url;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: const Icon(Icons.open_in_new),
      visualDensity: VisualDensity.standard,
      onTap: () => launchUrl(Uri.parse(url)),
    );
  }
}
