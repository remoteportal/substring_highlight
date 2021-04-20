import 'package:flutter/material.dart';
import 'package:substring_highlight/substring_highlight.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: Scaffold(
          body: Center(
              child: SubstringHighlight(
                  text: 'this highlights all the th\'s',
                  textStyle: TextStyle(
                    // non-highlight style
                    color: Colors.grey,
                  ),
                  term: 'th'))),
    );
  }
}
