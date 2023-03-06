import 'dart:io';

import 'package:flutter/foundation.dart';

class DamageForm with ChangeNotifier {
  String? _type;
  String? _name;
  File? _image;
  String? _description;
  bool _critical = false;

  DamageForm({
    String? type,
    String? name,
    File? image,
    String? description,
    bool critical = false,
  }) {
    this.type = type;
    this.name = name;
    this.image = image;
    this.description = description;
    this.critical = critical;
  }

  String? get type => _type;
  String? get name => _name;
  File? get image => _image;
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

  set image(File? e) {
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

  set critical(bool? e) {
    if (e != _critical) {
      _critical = e ?? false;
      notifyListeners();
    }
  }
}
