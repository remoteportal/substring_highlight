library substring_highlight;

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Widget that renders a string with sub-string highlighting.
class SubstringHighlight extends StatelessWidget {
  /// The String searched by {SubstringHighlight.term}.
  final String text;

  /// The sub-string that is highlighted inside {SubstringHighlight.text}.
  final List<String> terms;

  /// The {TextStyle} of the {SubstringHighlight.text} that isn't highlighted.
  final TextStyle textStyle;

  /// The {TextStyle} of the {SubstringHighlight.term}s found.
  final TextStyle textStyleHighlight;

  SubstringHighlight({
    @required this.text,
    @required this.terms,
    this.textStyle = const TextStyle(
      color: Colors.black,
    ),
    this.textStyleHighlight = const TextStyle(
      color: Colors.red,
    ),
  }) : assert(terms.isNotEmpty); // ensure terms list is not empty

  @override
  Widget build(BuildContext context) {
    final defaultText = Text(
      text,
      style: textStyle,
    );
    // create a map of the postions of the
    // text to be highlighted.
    final indexes = Map<int, List<int>>();
    for (int i = 0; i < terms.length; i++) {
      // skips iteration when term is an empty string
      if (terms[i].isEmpty) {
        continue;
      }
      int idx = text.indexOf(terms[i]);
      while (idx >= 0) {
        if (indexes[i] != null) {
          indexes[i].add(idx);
        } else {
          indexes[i] = [idx];
        }
        idx = text.indexOf(terms[i], idx + 1);
      }
    }
    // error check for empty map
    if (indexes.isEmpty) return defaultText;
    // create sorted list of highlight text positions
    List<int> listOfValues = [];
    indexes.values.forEach((tuple) {
      listOfValues += tuple.toList();
    });
    listOfValues.sort();
    // loop through input string assign text style to highlight text
    // and "regular" text
    List<InlineSpan> children = [];
    for (int i = 0; i < text.length; i++) {
      if (listOfValues.contains(i)) {
        final key = indexes.keys.firstWhere((key) => indexes[key].contains(i));
        children.add(
          TextSpan(
            text: text.substring(i, i + terms[key].length),
            style: textStyleHighlight,
          ),
        );
        // remove index of term after it is
        // added to children list
        listOfValues.remove(i);
        i += terms[key].length - 1;
      } else {
        final subString = text.substring(
            i, (listOfValues.isEmpty) ? null : listOfValues.reduce(min));
        children.add(
          TextSpan(
            text: subString,
            style: textStyle,
          ),
        );
        i += subString.length - 1;
      }
    }
    return RichText(text: TextSpan(children: children));
  }
}
