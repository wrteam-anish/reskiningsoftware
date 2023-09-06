import 'package:flutter/services.dart';

class MaxDotInpuFormatter extends TextInputFormatter {
  final int maxDot;

  MaxDotInpuFormatter(this.maxDot);
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    const dot = '.';
    final dotCount = oldValue.text.split(dot).length - 1;

    if (dotCount >= maxDot) {
      // User is trying to add a dot when three dots are already present
      if (newValue.text.endsWith(".")) {
        return oldValue;
      } else {
        return newValue;
      }
    }

    return newValue;
  }
}
