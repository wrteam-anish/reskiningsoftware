import 'package:flutter/material.dart';

class CustomDialoges {
  static showPickerDialoge(

      // map parameters title, value
      {required List<Map<dynamic, dynamic>> itemList,
      dynamic selectedValue}) {
    dynamic selected = selectedValue;
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: itemList.map((item) {
            return RadioListTile<dynamic>(
              controlAffinity: ListTileControlAffinity.trailing,
              value: item['value'],
              groupValue: selected,
              onChanged: (value) {
                selected = value;
                setState(() {});

                Navigator.pop(context, item);
              },
              title: Text(item['title'].toString()),
            );
          }).toList(),
        ),
      );
    });
  }
}
