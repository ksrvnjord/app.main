import 'package:flutter/foundation.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_filler.dart';
import 'package:share_plus/share_plus.dart';

class FirestoreFormFillerNotifier extends ChangeNotifier {
  FirestoreFormFillerNotifier(this._filler);
  final FirestoreFormFiller _filler;

  // Accessors & Mutators
  FirestoreFormFiller get value => _filler;

  int get id => _filler.id;

  String get title => _filler.title;
  set title(String val) {
    if (_filler.title != val) {
      _filler.title = val;
      notifyListeners();
    }
  }

  String get body => _filler.body;
  set body(String val) {
    if (_filler.body != val) {
      _filler.body = val;
      notifyListeners();
    }
  }

  bool get hasImage => _filler.hasImage;
  XFile? get image => _filler.image;

  void updateImage(XFile? file) {
    _filler.image = file;
    _filler.hasImage = file != null;
    notifyListeners();
  }

  /// Serialization passthrough
  Map<String, dynamic> toJson() => _filler.toJson();

  static FirestoreFormFillerNotifier fromJson(Map<String, dynamic> json) {
    final filler = FirestoreFormFiller.fromJson(json);
    return FirestoreFormFillerNotifier(filler);
  }
}
