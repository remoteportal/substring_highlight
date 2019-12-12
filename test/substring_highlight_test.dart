import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:substring_highlight/substring_highlight.dart';

// https://flutter.dev/docs/cookbook/testing/widget/introduction#3-create-a-testwidgets-test

void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows you to build and interact
  // with widgets in the test environment.
  testWidgets('test the thing!', (WidgetTester tester) async {
    await tester.pumpWidget(Directionality(child: SubstringHighlight(text: 'Peter', term: 't'), textDirection: TextDirection.ltr));
  });
}