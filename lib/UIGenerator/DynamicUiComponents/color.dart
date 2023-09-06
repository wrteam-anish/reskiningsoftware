import 'package:flutter/src/widgets/framework.dart';
import 'package:reskinner_new/UIGenerator/ui.dart';

import 'color_picker_widget.dart';

class ColorUi extends UI {
  @override
  Widget render() {
    return ColorPickWidget(
      field: fieldData,
    );
  }
}
