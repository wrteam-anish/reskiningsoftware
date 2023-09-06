import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:reskinner_new/Data/data.dart';
import 'package:reskinner_new/Data/dataTypes.dart';
import 'package:reskinner_new/UIGenerator/ui.dart';
import 'package:reskinner_new/Utils/lables.dart';

class FileUi extends UI {
  @override
  Widget render() {
    return FilePickerWidget(
      fieldData: fieldData,
    );
  }
}

class FilePickerWidget extends StatefulWidget {
  final Map fieldData;
  const FilePickerWidget({super.key, required this.fieldData});

  @override
  State<FilePickerWidget> createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget> {
  File? pickedFile;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        FilePickerResult? result = await FilePicker.platform
            .pickFiles(type: FileType.any, allowMultiple: false);
        if (result != null) {
          pickedFile = File(result.files.first.path!);
          Storage.data.addAll(
              {widget.fieldData['fieldPattern']: TypeFile(pickedFile!)});
        }

        setState(() {});
      },
      child: Tooltip(
        message: "Tap to pick",
        child: Row(
          children: [
            const Icon(
              Icons.file_upload,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(pickedFile == null
                ? Lable.pickFile
                : pickedFile!.path.split("/").last)
          ],
        ),
      ),
    );
  }
}
