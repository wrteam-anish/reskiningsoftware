import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_validator/multi_validator.dart';
import 'package:reskinner_new/Data/dataTypes.dart';
import 'package:reskinner_new/Theme/theme.dart';
import 'package:reskinner_new/UIGenerator/ui.dart';

import '../../Data/data.dart';
import '../../Utils/Formaters/maxDot.dart';
import '../../Utils/Formaters/validators.dart';

class TextUi extends UI {
  @override
  Widget render() {
    TextEditingController _controller =
        TextEditingController(text: fieldData['initVal']);

    TextInputType keyboardType = TextInputType.text;
    List<TextInputFormatter> inputFormatters = [];
    if (fieldData.containsKey("keyboard")) {
      if (fieldData['keyboard'] == "number") {
        keyboardType = TextInputType.phone;
      }
    }

    if (fieldData.containsKey("maxDot")) {
      inputFormatters.add(MaxDotInpuFormatter(fieldData['maxDot']));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(fieldData['fieldName']),
              const Spacer(),
              if (fieldData['info'] != null)
                Tooltip(
                  message: fieldData['info'],
                  child: const Icon(
                    Icons.info_outline,
                    color: Colors.grey,
                    size: 16,
                  ),
                )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            validator: (value) {
              if (fieldData.containsKey("validator")) {
                if (fieldData['validator'].isEmpty) {
                  return null;
                }

                Set validator = fieldData['validator'] as Set;

                ///Able to use multiple validators

                List validators = [];

                validators = Validators.getValidator(validator);

                MultiValidator multiValidator =
                    MultiValidator(List.from(validators));

                return multiValidator.validate(value);
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
                hintText: fieldData['hint'],
                filled: true,
                fillColor: AppTheme.primaryColor,
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppTheme.teretoryColor)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppTheme.teretoryColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(width: 2, color: AppTheme.teretoryColor)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade400))),
            controller: _controller,
            onChanged: (value) {
              Storage.data.addAll({
                fieldData['fieldPattern']: TextType(value),
              });
              fieldData['initVal'] = value;
            },
          ),
        ],
      ),
    );
  }
}
