import 'package:flutter/foundation.dart';

class Errors {
  static ValueNotifier<List<Map>> _errors = ValueNotifier([]);
  static get listen => _errors;
  static void error(String text) {
    _errors.value.add({
      "time": DateTime.now(),
      "error": text,
    });
    _errors.notifyListeners();
  }

  static clear() {
    _errors.value = [];
    _errors.notifyListeners();
  }
}
