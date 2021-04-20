import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:substring_highlight/substring_highlight.dart';

void main() {
  testWidgets('test the thing!', (WidgetTester tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(size: Size(200, 300)),
        child: Directionality(
          child: SubstringHighlight(text: 'Peter', term: 't'),
          textDirection: TextDirection.ltr,
        ),
      ),
    );
  });

  testWidgets('consistent text size', (WidgetTester tester) async {
    final TextStyle ts = TextStyle(fontSize: 30, color: Color(0xff000000));
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(
          size: Size(200, 300),
          textScaleFactor: 2.0,
        ),
        child: Column(
          children: <Widget>[
            Directionality(
              child: SubstringHighlight(
                text: 'Peter',
                term: 't',
                textStyle: ts,
              ),
              textDirection: TextDirection.ltr,
            ),
            Directionality(
              child: SubstringHighlight(
                text: 'Peter',
                term: '',
                textStyle: ts,
              ),
              textDirection: TextDirection.ltr,
            ),
          ],
        ),
      ),
    );
    await expectLater(
      find.byType(MediaQuery),
      matchesGoldenFile('goldens/text-size.png'),
    );
  });
}
