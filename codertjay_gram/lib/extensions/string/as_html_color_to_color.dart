import 'package:codertjay_gram/extensions/string/remove_all.dart';
import 'package:flutter/material.dart';

// convert 0x???? or #????? to color

extension AsHtmlColorToColor on String {
  Color htmlColorToColor() => Color(
        int.parse(
          removeAll(["0x", "#"]).padLeft(8, "ff"),
          radix: 16,
        ),
      );
}
