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
                  caseSensitive: false,
                  // text: 'this highlights all THE terms',

                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,

                  //PUBLIC-DOMAIN
                  // text:
                  //     'We shall not flag nor fail. We shall go on to the end. We shall fight in France and on the seas and oceans; we shall fight with growing confidence and growing strength in the air. We shall defend our island whatever the cost may be; we shall fight on beaches, landing grounds, in fields, in streets and on the hills. We shall never surrender…carry on the struggle, until, in God\'s good time, the New World, with all it power and might, steps forth to the rescue and the liberation of the Old',

                  text: 'This highlights all the th\'s',
                  textStyle: TextStyle(
                    // non-highlight style
                    color: Colors.grey,
                  ),
                  // term: 'light',
                  // terms: ['i', ' ', 'TH', ''],
                  terms: ['Rush Rules!', ' ', 'TH', '']
                  // terms: ['in', 'and']
                  ))),
    );
  }
}
