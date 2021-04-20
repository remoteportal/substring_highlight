library substring_highlight;

import 'package:flutter/material.dart';

/// Widget that renders a string with sub-string highlighting.
class SubstringHighlight extends StatelessWidget {
  SubstringHighlight({
    required this.text,
    required this.term,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.textStyle = const TextStyle(
      color: Colors.black,
    ),
    this.textStyleHighlight = const TextStyle(
      color: Colors.red,
    ),
  });

  /// The String searched by {SubstringHighlight.term}.
  final String text;

  /// The sub-string that is highlighted inside {SubstringHighlight.text}.
  final String term;

  /// The {TextStyle} of the {SubstringHighlight.text} that isn't highlighted.
  final TextStyle textStyle;

  /// The {TextStyle} of the {SubstringHighlight.term}s found.
  final TextStyle textStyleHighlight;

  /// How visual overflow should be handled.
  final TextOverflow overflow;

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  /// If the text exceeds the given number of lines, it will be truncated according
  /// to [overflow].
  ///
  /// If this is 1, text will not wrap. Otherwise, text will be wrapped at the
  /// edge of the box.
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    if (term.isEmpty) {
      return Text(text,
          maxLines: maxLines, overflow: overflow, style: textStyle);
    } else {
      String termLC = term.toLowerCase();

      List<InlineSpan> children = [];
      List<String> spanList = text.toLowerCase().split(termLC);
      int i = 0;
      for (var v in spanList) {
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
      }

      return RichText(
          maxLines: maxLines,
          overflow: overflow,
          text: TextSpan(children: children, style: textStyle),
          textScaleFactor: MediaQuery.of(context).textScaleFactor);
    }
  }
}
