import 'dart:developer';

import 'package:flutter/src/widgets/framework.dart';
import 'package:reskinner_new/UIGenerator/ui.dart';

import '../FormFields/imageFormField.dart';

class ImageUi extends UI {
  @override
  Widget render() {
    dynamic initialFile;
    if (fieldData['initVal'] != null) {
      initialFile = (fieldData['initVal']);
    }
    log("INITIAL FILE IS $fieldData");

    return ImageWidgetFormField(
      field: fieldData,
      initialFile: initialFile,
      validator: (value) {
        if (fieldData.containsKey("required")) {
          var required = initialFile['required'];
          if (required == true) {
            if (value == null) {
              return "Please Upload file";
            }
          } else {
            return null;
          }
        }
        if (initialFile != null && initialFile.isNotEmpty) {
          return null;
        }

        return null;
      },
    );
  }
}
