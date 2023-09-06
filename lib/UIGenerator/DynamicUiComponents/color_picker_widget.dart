import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:reskinner_new/Data/data.dart';

import '../../Data/dataTypes.dart';

class ColorPickWidget extends StatefulWidget {
  final Map field;

  const ColorPickWidget({super.key, required this.field});

  @override
  State<ColorPickWidget> createState() => _ColorPickWidgetState();
}

class _ColorPickWidgetState extends State<ColorPickWidget> {
  bool setInitVal = false;
  List<Color> history = [];
  Color? pickedColor;
  @override
  Widget build(BuildContext context) {
    if (widget.field.containsKey("initVal") && setInitVal == false) {
      pickedColor = Color(int.parse(widget.field['initVal']));
      // Storage.data[widget.field['fieldPattern']] = widget.field['initVal'];
      setInitVal = true;
    }

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          // anchorPoint: const Offset(0, 0),
          builder: (context) {
            return FittedBox(
              fit: BoxFit.none,
              child: Material(
                color: const Color.fromARGB(255, 237, 237, 237),
                child: SizedBox(
                  child: ColorPicker(
                    hexInputBar: true,
                    colorHistory: history,
                    pickerColor: pickedColor ?? Colors.white,
                    onColorChanged: (value) {
                      pickedColor = value;
                      history.add(value);
                      Storage.data.addAll({
                        widget.field['fieldPattern']: ColorType(value
                            .toString()
                            .replaceAll("Color(", "")
                            .replaceAll(")", ""))
                      });
                      setState(() {});
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Tooltip(
              message: "Tap to choose color",
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: pickedColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300)),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(widget.field['fieldName'])
          ],
        ),
      ),
    );
  }
}
