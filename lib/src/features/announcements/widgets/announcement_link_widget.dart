import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/announcement_provider.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/model/announcement.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AnnouncementLinkWidget extends ConsumerWidget {
  const AnnouncementLinkWidget({
    super.key,
    required this.announcement,
    required this.isAdmin,
  });

  final Announcement announcement;
  final bool isAdmin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final announcementNotifier = ref.read(announcementProvider.notifier);

    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () async {
                if (await launchUrlString(announcement.link ?? '')) {
                } else {
                  throw 'Could not launch link ${announcement.link}';
                }
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Link: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            textTheme.titleLarge?.color ?? colorScheme.primary,
                        fontSize: 16.0, // Increase text size
                      ),
                    ),
                    TextSpan(
                      text: announcement.link,
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontSize: 16.0, // Increase text size
                      ),
                    ),
                  ],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: () async {
                final newLink = await showDialog<String>(
                  context: context,
                  builder: (context) {
                    final TextEditingController controller =
                        TextEditingController(text: announcement.link);
                    return AlertDialog(
                      title: const Text('Link aanpassen'),
                      content: TextField(
                        controller: controller,
                        decoration: const InputDecoration(labelText: 'Link'),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Terug'),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.of(context).pop(controller.text),
                          child: const Text('Opslaan'),
                        ),
                      ],
                    );
                  },
                );

                if (newLink != announcement.link) {
                  announcementNotifier.updateAnnouncementLink(
                      announcement.id, newLink ?? "");
                }
              },
            ),
        ],
      ),
    );
  }
}
