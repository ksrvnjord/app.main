import 'dart:html' as html;
import 'dart:typed_data';

// ignore: prefer-static-class
void downloadImageForWeb(Uint8List imageBytes, int currentPage) {
  final blob = html.Blob([imageBytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..target = 'blank'
    ..download = 'foto_$currentPage.jpg';
  anchor.click();
  html.Url.revokeObjectUrl(url);
}
