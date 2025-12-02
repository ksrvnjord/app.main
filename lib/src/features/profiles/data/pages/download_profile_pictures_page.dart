import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/data/api/profille_downloader.dart';
import 'package:styled_widget/styled_widget.dart';

class DownloadProfilePicturesPage extends ConsumerStatefulWidget {
  const DownloadProfilePicturesPage({super.key});

  @override
  DownloadProfilePicturesPageState createState() =>
      DownloadProfilePicturesPageState();
}

class DownloadProfilePicturesPageState
    extends ConsumerState<DownloadProfilePicturesPage> {
  bool _isLoading = false;
  int _progressCounter = 0;
  int? _total;

  void _handleDownloadState(bool isLoading, int downloaded, int total) {
    setState(() {
      _isLoading = isLoading;
      _progressCounter = downloaded;
      _total = total;
    });
  }

  void _startDownload() async {
    await downloadAllProfilePictures(onStateChanged: _handleDownloadState);
  }

  @override
  Widget build(BuildContext context) {
    return [
      Center(
        child: IconButton(
            onPressed: () {
              if (kIsWeb) {
                _startDownload();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Deze functie is alleen beschikbaar op de webversie van de app.',
                    ),
                  ),
                );
              }
            },
            icon: Icon(Icons.download)),
      ),
      if (_isLoading) // Show a loading indicator when the user is exporting the CSV.
        Positioned.fill(
          child: Container(
            // ignore: no-magic-number
            color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator.adaptive(),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Text(
                    "Bezig met exporteren van ($_progressCounter/$_total) profielfoto's",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontFamily: 'Courier'),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
    ].toStack();
  }
}
