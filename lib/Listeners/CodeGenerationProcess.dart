import 'package:flutter/cupertino.dart';

enum ConsoleProcessType {
  codeGeneration,
  appRun,
}

class TerminalProcess {
  static final ValueNotifier<Map> _process = ValueNotifier({
    "process": {
      "files": [],
      "outOf": {
        "current": 0.0,
        "total": 0.0,
      },
      "fileName": "",
    },
    "status": "INITIAL",
    "type": ConsoleProcessType.codeGeneration,
  });

  static ValueNotifier<Map> listen() {
    return _process;
  }

  static ValueNotifier<Map> get() {
    return _process;
  }

  static void reset() {
    _process.value = {
      "process": {
        "files": [],
        "outOf": {
          "current": 0.0,
          "total": 0.0,
        },
        "fileName": "",
      },
      "status": "INITIAL",
      "type": ConsoleProcessType.codeGeneration,
    };
  }

  static void resetButTypeSame() {
    Map value = _process.value;
    var type = value['type'];

    _process.value = {
      "process": {
        "files": [],
        "outOf": {
          "current": 0.0,
          "total": 0.0,
        },
        "fileName": "",
      },
      "status": "INITIAL",
      "type": type,
    };
  }

  static setProcessStatus(String status) {
    _process.value['status'] = status;
    _process.notifyListeners();
  }

  static setProcessType(ConsoleProcessType type) {
    _process.value['type'] = type;
    _process.notifyListeners();
  }

  static void addValue(Map value) {
    var file = value['file'];
    List files = _process.value['files'] ?? [];
    files.add(file);
    Map tempValue = value;
    tempValue['files'] = files;
    _process.value['process'] = tempValue;
    _process.notifyListeners();
  }
}
