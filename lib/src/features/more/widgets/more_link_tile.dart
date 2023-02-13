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
      title: Text(label),
      trailing: // icon that shows external link
          const Icon(Icons.open_in_new, color: Colors.lightBlue),
      onTap: () => launchUrl(Uri.parse(url)),
    );
  }
}
