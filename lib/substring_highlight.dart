library substring_highlight;

import 'package:flutter/material.dart';

final int __int64MaxValue = double.maxFinite.toInt();

/// Widget that renders a string with sub-string highlighting.
class SubstringHighlight extends StatelessWidget {
  SubstringHighlight(
      {this.caseSensitive = false,
      this.maxLines,
      this.overflow = TextOverflow.clip,
      this.softWrap = true,
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
      this.wordDelimiters = ' .,;?!<>[]~`@#\$%^&*()+-=|\/_',
      this.words =
          false // default is to match substrings (hence the package name!)

      })
      : assert(term != null || terms != null);

  /// By default the search terms are case insensitive.  Pass false to force case sensitive matches.
  final bool caseSensitive;

  /// How visual overflow should be handled.
  final TextOverflow overflow;

  /// Whether the text should break at soft line breaks.
  ///
  /// If false, the glyphs in the text will be positioned as if there was unlimited horizontal space.
  final bool softWrap;

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

  /// String of characters that define word delimiters if {words} flag is true.
  final String wordDelimiters;

  /// If true then match complete words only (instead of characters or substrings within words).  This feature is in ALPHA... use 'words' AT YOUR OWN RISK!!!
  final bool words;

  @override
  Widget build(BuildContext context) {
    final String textLC = caseSensitive ? text : text.toLowerCase();

    // corner case: if both term and terms array are passed then combine
    final List<String> termList = [term ?? '', ...(terms ?? [])];

    // remove empty search terms ('') because they cause infinite loops
    final List<String> termListLC = termList
        .where((s) => s.isNotEmpty)
        .map((s) => caseSensitive ? s : s.toLowerCase())
        .toList();

    List<InlineSpan> children = [];

    int start = 0;
    int idx = 0; // walks text (string that is searched)
    while (idx < textLC.length) {
      // print('=== idx=$idx');
      nonHighlightAdd(int end) => children
          .add(TextSpan(text: text.substring(start, end), style: textStyle));

      // find index of term that's closest to current idx position
      int iNearest = -1;
      int idxNearest = __int64MaxValue;
      for (int i = 0; i < termListLC.length; i++) {
        // print('*** i=$i');
        int at;
        if ((at = textLC.indexOf(termListLC[i], idx)) >= 0) //MAGIC//CORE
        {
          // print('idx=$idx i=$i at=$at => FOUND: ${termListLC[i]}');

          if (words) {
            if (at > 0 &&
                !wordDelimiters.contains(
                    textLC[at - 1])) // is preceding character a delimiter?
            {
              // print('disqualify preceding: idx=$idx i=$i');
              continue; // preceding character isn't delimiter so disqualify
            }

            int followingIdx = at + termListLC[i].length;
            if (followingIdx < textLC.length &&
                !wordDelimiters.contains(textLC[
                    followingIdx])) // is character following the search term a delimiter?
            {
              // print('disqualify following: idx=$idx i=$i');
              continue; // following character isn't delimiter so disqualify
            }
          }

          // print('term #$i found at=$at (${termListLC[i]})');
          if (at < idxNearest) {
            // print('PEG');
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
        if (words) {
          idx++;
          nonHighlightAdd(idx);
          start = idx;
        } else {
          // if none match at all (ever!)
          // --or--
          // one or more matches but during this iteration there are NO MORE matches
          // in either case, add reminder of text as non-highlighted text
          nonHighlightAdd(textLC.length);
          break;
        }
      }
    }

    return RichText(
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
        text: TextSpan(children: children, style: textStyle),
        textAlign: textAlign,
        textScaleFactor: MediaQuery.of(context).textScaleFactor);
  }
}
