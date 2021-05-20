library substring_highlight;

import 'package:flutter/material.dart';

final int int64MaxValue = double.maxFinite.toInt(); //HACK

/// Widget that renders a string with sub-string highlighting.
class SubstringHighlight extends StatelessWidget {
  SubstringHighlight({
    required this.text,
    this.term,
    this.terms,
    this.caseSensitive = false,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.textStyle = const TextStyle(
      color: Colors.black,
    ),
    this.textStyleHighlight = const TextStyle(
      color: Colors.red,
    ),
  }) : assert(term != null || terms != null);

  /// The String searched by {SubstringHighlight.term} and/or {SubstringHighlight.terms} array.
  final String text;

  /// The sub-string that is highlighted inside {SubstringHighlight.text}.  (Either term or terms must be passed.  If both are passed they are combined.)
  final String? term;

  /// The array of sub-strings that are highlighted inside {SubstringHighlight.text}.  (Either term or terms must be passed.  If both are passed they are combined.)
  final List<String>? terms;

  /// By default the search terms are case insensitive.  Pass false to force case sensitive matches.
  final bool caseSensitive;

  /// The {TextStyle} of the {SubstringHighlight.text} that isn't highlighted.
  final TextStyle textStyle;

  /// The {TextStyle} of the {SubstringHighlight.term}/{SubstringHighlight.ters} matched.
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
    final String textLC = caseSensitive ? text : text.toLowerCase();

    // if both term and terms array are passed then combine
    final List<String> termList = [term ?? '', ...(terms ?? [])];

    // must remove empty search terms because they cause infinite loops
    final List<String> termListLC = termList
        .where((s) => s.isNotEmpty)
        .map((s) => caseSensitive ? s : s.toLowerCase())
        .toList();

    List<InlineSpan> children = [];

    int start = 0;
    int idx = 0;
    while (idx < textLC.length) {
      addNonHighlight(int end) => children
          .add(TextSpan(text: text.substring(start, end), style: textStyle));

      // find index of term that's closest to current idx position
      int iNearest = -1;
      int idxNearest = int64MaxValue;
      for (int i = 0; i < termListLC.length; i++) {
        // print('idx=$idx i=$i $termsLC');
        int at;
        if ((at = textLC.indexOf(termListLC[i], idx)) >= 0) {
          // print('term #$i found at=$at (${termListLC[i]})');
          if (at < idxNearest) {
            iNearest = i;
            idxNearest = at;
          }
        }
      }

      if (iNearest >= 0) {
        // found one of the terms at or after idx
        // iNearest is the index of the closest term at or after idx that matches

        // print('iNearest=$iNearest @ $idxNearest');
        if (start < idxNearest) {
          // we found a match BUT FIRST output non-highlighted text that comes BEFORE this match
          addNonHighlight(idxNearest);
          start = idxNearest;
        }

        // output the match using desired highlighting
        int termLen = termListLC[iNearest].length;
        children.add(TextSpan(
            text: text.substring(start, idxNearest + termLen),
            style: textStyleHighlight));
        start = idx = idxNearest + termLen;
      } else {
        // if none match at all (ever!)
        // --or--
        // one or more matches but during this iteration there are NO MORE matches
        // in either case, add reminder of text as non-highlighted text
        addNonHighlight(textLC.length);
        break;
      }
    }

    return RichText(
        maxLines: maxLines,
        overflow: overflow,
        text: TextSpan(children: children, style: textStyle),
        textScaleFactor: MediaQuery.of(context).textScaleFactor);
  }
}
