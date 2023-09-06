import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart' as d;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:reskinner_new/Data/data.dart';
import 'package:reskinner_new/Data/dataTypes.dart';

class ImageWidgetFormField extends FormField<File> {
  ImageWidgetFormField(
      {super.key,
      FormFieldSetter<File>? onSaved,
      required Map field,
      FormFieldValidator<File>? validator,
      File? initialValue,
      dynamic initialFile,
      bool autovalidate = false})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<File> state) {
              return ImageStateWidget(
                field: field,
                formState: state,
                initialFile: initialFile,
              );
            });
}

class ImageStateWidget extends StatefulWidget {
  final Map field;
  final FormFieldState<File> formState;
  final dynamic initialFile;
  const ImageStateWidget({
    Key? key,
    required this.field,
    required this.formState,
    required this.initialFile,
  }) : super(key: key);

  @override
  State<ImageStateWidget> createState() => _ImageStateWidgetState();
}

class _ImageStateWidgetState extends State<ImageStateWidget> {
  File? selectedFile;

  bool isHovering = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // initialFile = widget.field['initVal'];
    getImage() {
      if (selectedFile != null) {
        return (Image.file(selectedFile!));
      }
      if (selectedFile == null && widget.initialFile != null) {
        if (widget.initialFile.isNotEmpty) {
          return Image.memory(widget.initialFile);
        } else {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.file_download_outlined,
                  size: 15,
                  color: Colors.grey,
                ),
                Text(
                  "Drop",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                )
              ],
            ),
          );
        }
      }

      if (selectedFile == null && widget.initialFile == null) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.file_download_outlined,
                size: 15,
                color: Colors.grey,
              ),
              Text(
                "Drop",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              )
            ],
          ),
        );
      }
    }

    // log(widget.field['initVal'].toString(), name: "SSfcfdf");
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              d.DropTarget(
                onDragEntered: (d.DropEventDetails details) {
                  if (isHovering == false) {
                    isHovering = true;

                    setState(() {});
                  }
                },
                onDragExited: (details) {
                  if (isHovering == true) {
                    isHovering = false;

                    setState(() {});
                  }
                },
                onDragDone: (details) {
                  var first = details.files.first;
                  selectedFile = File(first.path);
                  Storage.data.addAll({
                    widget.field['fieldPattern']: ImageType(File(first.path))
                  });
                  widget.formState.didChange(selectedFile);

                  setState(() {});
                },
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: widget.formState.hasError
                              ? Colors.red
                              : Colors.grey),
                      color: (isHovering
                          ? Colors.red.shade200
                          : Colors.transparent)),
                  child: getImage(),
                ),
              ),
              MaterialButton(
                onPressed: () async {
                  var filePickerResulx =
                      await FilePicker.platform.pickFiles(allowMultiple: false);
                  Storage.data.addAll({
                    widget.field['fieldPattern']:
                        ImageType(File(filePickerResulx!.files.first!.path!))
                  });
                  selectedFile = File(filePickerResulx?.files.first.path ?? "");
                  widget.formState.didChange(selectedFile);
                  setState(() {});
                },
                child: Text(widget.field['fieldName']),
              ),
              const SizedBox(
                width: 10,
              ),
              // if (filePickerResul != null)
              //   SizedBox(
              //       width: 50,
              //       height: 50,
              //       child: GestureDetector(
              //         onTap: () {},
              //         child: Image.file(
              //           File((filePickerResul!.paths.first)!),
              //           fit: BoxFit.cover,
              //         ),
              //       )),
              // if (filePickerResul == null && initialFile != null)
              //   SizedBox(
              //       width: 50,
              //       height: 50,
              //       child: GestureDetector(
              //         onTap: () {},
              //         child: Image.memory(
              //           (initialFile)!,
              //           fit: BoxFit.cover,
              //           errorBuilder: (context, error, stackTrace) {
              //             return Container();
              //           },
              //         ),
              //       ))
            ],
          ),
          if (widget.formState.hasError)
            Text(
              widget.formState.errorText.toString(),
              style: const TextStyle(fontSize: 12, color: Colors.red),
            )
        ],
      ),
    );
  }
}
