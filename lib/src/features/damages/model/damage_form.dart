
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// ignore: prefer-static-class
final damageFormProvider = ChangeNotifierProvider((ref) => DamageForm());

// @immutable // TODO: make this class immutable.
class DamageForm extends ChangeNotifier {
  String? _type;
  String? _name;
  XFile? _image;
  String? _description;
  String? _cause;
  bool _critical = false;

  String? get type => _type;
  String? get name => _name;
  String? get cause => _cause;
  XFile? get image => _image;
  String? get description => _description;
  bool get critical => _critical;
  bool get complete =>
      _type != null &&
      _name != null &&
      _description != null &&
      _description != '';

  set type(String? e) {
    if (e != _type) {
      _type = e;
      _name = null;
      notifyListeners();
    }
  }

  set name(String? e) {
    if (e != _name) {
      _name = e;
      notifyListeners();
    }
  }

  set image(XFile? e) {
    if (e != _image) {
      _image = e;
      notifyListeners();
    }
  }

  set description(String? e) {
    if (e != _description) {
      _description = e;
      notifyListeners();
    }
  }

  set cause(String? e) {
    if (e != _cause) {
      _cause = e;
      notifyListeners();
    }
  }

  set critical(bool? e) {
    if (e != _critical) {
      _critical = e ?? false;
      notifyListeners();
    }
  }

  // ignore: sort_constructors_first
  DamageForm({
    String? type,
    String? name,
    String? cause,
    XFile? image,
    String? description,
    bool critical = false,
  }) {
    _type = type;
    _name = name;
    _cause = cause;
    _image = image;
    _description = description;
    _critical = critical;
  }
}
