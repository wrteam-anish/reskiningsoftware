import 'dart:io';

import 'package:reskinner_new/Data/data.dart';
import 'package:reskinner_new/Data/dataTypes.dart';

class FileByteReplace {
  replace(List uiFields, String fileName) {
    dynamic replacedFileBytes;
    dynamic hasData;
    for (var field in uiFields) {
      bool isGroup = (field is List);

      if (isGroup) {
        //recursive
        replacedFileBytes = replace(field, fileName);
      } else {
        bool hasTargetFileName = (field as Map).containsKey("fileName");

        if (hasTargetFileName) {
          bool isCurrentFileNameContainesTargetFileName =
              fileName.contains(field['fileName']);

          if (isCurrentFileNameContainesTargetFileName) {
            bool hasStorageThisFieldData =
                Storage.data.containsKey(field['fieldPattern']);
            if (hasStorageThisFieldData) {
              DataType? fieldData = Storage.data[field['fieldPattern']];

              if (fieldData is ImageType || fieldData is TypeFile) {
                File file = fieldData!.content;

                replacedFileBytes = file.readAsBytesSync();
                hasData = replacedFileBytes;
              }
            }
          }
        }
      }
    }
    return hasData ?? replacedFileBytes;
  }
}
