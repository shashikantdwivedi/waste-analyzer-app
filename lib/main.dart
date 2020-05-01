import 'package:flutter/material.dart';
import 'home_page.dart';
import 'entry_page.dart';

class WasteAnalyzer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // theme: ThemeData(fontFamily: 'Circular Std Black'),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => EntryPage(),
          '/home': (context) => HomePage(),
        },
        title: 'Waste Analyzer',
        home: null);
  }
}

void main() => runApp(WasteAnalyzer());
