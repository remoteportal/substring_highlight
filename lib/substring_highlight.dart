library substring_highlight;

import 'package:flutter/material.dart';

class SubstringHighlight extends StatelessWidget {
  final String text;
  final String term;
  final TextStyle textStyle;
  final TextStyle textStyleHighlight;

  SubstringHighlight({
    @required this.text,
    @required this.term,
    this.textStyle = const TextStyle(
      color: Colors.black,
    ),
    this.textStyleHighlight = const TextStyle(
      color: Colors.red,
    ),
  });

  @override
  Widget build(BuildContext context) {
    if (term.isEmpty) {
      return Text(text, style: textStyle);
    } else {
      String termLC = term.toLowerCase();

      List<InlineSpan> children = [];
      List<String> spanList = text.toLowerCase().split(termLC);
      int i = 0;
      spanList.forEach((v) {
        if (v.isNotEmpty) {
          children.add(TextSpan(
              text: text.substring(i, i + v.length), style: textStyle));
          i += v.length;
        }
        if (i < text.length) {
          children.add(TextSpan(
              text: text.substring(i, i + term.length),
              style: textStyleHighlight));
          i += term.length;
        }
      });
      return RichText(text: TextSpan(children: children));
    }
  }
}
