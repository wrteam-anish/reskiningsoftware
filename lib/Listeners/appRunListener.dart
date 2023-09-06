import 'package:flutter/cupertino.dart';

enum AppRunStatus {
  initial,
  starting,
  started,
  terminating,
  failed,
}

class AppRunListener {
  static final ValueNotifier<AppRunStatus> _appRunStatus =
      ValueNotifier<AppRunStatus>(AppRunStatus.initial);

  static get() {
    return _appRunStatus;
  }

  static void setStatus(AppRunStatus status) {
    _appRunStatus.value = status;
    _appRunStatus.notifyListeners();
  }

  void setInitial() {
    _appRunStatus.value = AppRunStatus.initial;
    _appRunStatus.notifyListeners();
  }
}
