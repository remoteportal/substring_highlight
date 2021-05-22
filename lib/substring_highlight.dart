library substring_highlight;

import 'package:flutter/material.dart';

final int __int64MaxValue = double.maxFinite.toInt();

/// Widget that renders a string with sub-string highlighting.
class SubstringHighlight extends StatelessWidget {
  SubstringHighlight({
    this.caseSensitive = false,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.term,
    this.terms,
    required this.text,
    this.textAlign = TextAlign.left,
    this.textStyle = const TextStyle(
      color: Colors.black,
    ),
    this.textStyleHighlight = const TextStyle(
      color: Colors.red,
    ),
  }) : assert(term != null || terms != null);

  /// By default the search terms are case insensitive.  Pass false to force case sensitive matches.
  final bool caseSensitive;

  /// How visual overflow should be handled.
  final TextOverflow overflow;

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  /// If the text exceeds the given number of lines, it will be truncated according
  /// to [overflow].
  ///
  /// If this is 1, text will not wrap. Otherwise, text will be wrapped at the
  /// edge of the box.
  final int? maxLines;

  /// The sub-string that is highlighted inside {SubstringHighlight.text}.  (Either term or terms must be passed.  If both are passed they are combined.)
  final String? term;

  /// The array of sub-strings that are highlighted inside {SubstringHighlight.text}.  (Either term or terms must be passed.  If both are passed they are combined.)
  final List<String>? terms;

  /// The String searched by {SubstringHighlight.term} and/or {SubstringHighlight.terms} array.
  final String text;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// The {TextStyle} of the {SubstringHighlight.text} that isn't highlighted.
  final TextStyle textStyle;

  /// The {TextStyle} of the {SubstringHighlight.term}/{SubstringHighlight.ters} matched.
  final TextStyle textStyleHighlight;

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
      nonHighlightAdd(int end) => children
          .add(TextSpan(text: text.substring(start, end), style: textStyle));

      // find index of term that's closest to current idx position
      int iNearest = -1;
      int idxNearest = __int64MaxValue;
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
          nonHighlightAdd(idxNearest);
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
        nonHighlightAdd(textLC.length);
        break;
      }
    }

    return RichText(
        maxLines: maxLines,
        overflow: overflow,
        text: TextSpan(children: children, style: textStyle),
        textAlign: textAlign,
        textScaleFactor: MediaQuery.of(context).textScaleFactor);
  }
}
