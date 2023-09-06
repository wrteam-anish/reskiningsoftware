import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:reskinner_new/UIGenerator/DynamicUiComponents/color.dart';
import 'package:reskinner_new/UIGenerator/DynamicUiComponents/file.dart';
import 'package:reskinner_new/UIGenerator/DynamicUiComponents/text.dart';

import '../settings.dart';
import 'DynamicUiComponents/Image.dart';

GlobalKey<FormState> formKey = GlobalKey();

class BuilderUI extends StatefulWidget {
  const BuilderUI({
    super.key,
  });

  @override
  State<BuilderUI> createState() => _BuilderUIState();
}

class _BuilderUIState extends State<BuilderUI> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: LayoutBuilder(builder: (context, constra) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: constra.maxWidth * 0.2),
          child: Form(
            key: formKey,
            child: SizedBox(
              height: constra.maxHeight,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...List.generate(Settings.fields.length, (index) {
                      ////This will check entry's run time type if it is Map then it will be non-group field so we will display indivisual.

                      Type runtimeType = Settings.fields[index].runtimeType;

                      ///This will ensure it is not group
                      if (Settings.fields[index] is Map) {
                        //Check type is it image or text
                        return generateSingleField(Settings.fields, index);
                      } else {
                        ///it that field is not Map then it will be List
                        ///it means it is group
                        var field = Settings.fields[index];

                        /// We will add first Map in List so we will know its type
                        /// Like this
                        /*{
                      "group": "row",
                      "name": "LauncherImages",
                    },
                    {
                      "fieldName": "App icon HDPI",
                      "fieldPattern": "icLauncerHDPI",
                      "fileName": "/mipmap-hdpi/ic_launcher.png",
                      "type": "image",
                    }, */

                        /// Now we will check it contains group key or not

                        if ((field[0] as Map).containsKey("group")) {
                          /// We will extract group ,name from first index
                          var group = Settings.fields[index][0]['group'];
                          var title = Settings.fields[index][0]['name'];
                          var border =
                              Settings.fields[index][0]['borderAround'];

                          ////
                          ////We will check for type of fields Text,imaege.

                          ///If it is column so we will display in Vertical style
                          if (group == "column") {
                            ///

                            return Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: border == true
                                          ? Colors.black
                                          : const Color.fromARGB(0, 0, 0, 0))),
                              child: Column(
                                children: [
                                  ///Title here
                                  Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  ...generateFields(Settings.fields[index]),
                                ],
                              ),
                            );
                          } else {
                            ///This is again for row
                            if (group == "row") {
                              return Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: border == true
                                            ? Colors.black
                                            : const Color.fromARGB(
                                                0, 0, 0, 0))),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade800),
                                      ),
                                      Wrap(
                                        direction: Axis.horizontal,
                                        children: [
                                          ...generateFields(
                                              Settings.fields[index]),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              if (group == "row_force") {
                                return Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: border == true
                                              ? Colors.black
                                              : const Color.fromARGB(
                                                  0, 0, 0, 0))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade800),
                                      ),
                                      Row(
                                        children: [
                                          ///Title here
                                          // ...generateFields(field),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                          }
                        }
                      }

                      return Container();
                    }),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  generateFields(List groups) {
    log("::$groups");
    return List.generate(groups.length, (i) {
      var type = groups[i]['type'];

      ///if it is first index we will return with sized box because first index is config.
      if (i == 0) {
        return const SizedBox.shrink();
      }

      ///Now return Widget according to type
      return generateSingleField(groups, i);
    });
  }

  generateSingleField(List group, index) {
    Map field = group[index];

    //Check type is it image or text
    var type = field['type'];

    //if text
    if (type == "text") {
      TextUi textUi = TextUi();
      textUi.fieldData = field;
      return textUi.render();
    } else if (type == "image") {
      ///if images
      ImageUi imageUi = ImageUi();
      imageUi.fieldData = field;
      return imageUi.render();
    } else if (type == "file") {
      FileUi fileUi = FileUi();
      fileUi.fieldData = field;
      return fileUi.render();
    }
    if (type == "color") {
      ColorUi colorUi = ColorUi();
      colorUi.fieldData = field;
      return colorUi.render();
    } else {
      return Container();
    }

    // else if (type == "bool") {
    //   return CheckBoxWidget(
    //     field: field,
    //   );
    // }

    // else if (type == "color") {
    //   return ColorPickWidget(
    //     field: field,
    //   );
    // }
  }
}
