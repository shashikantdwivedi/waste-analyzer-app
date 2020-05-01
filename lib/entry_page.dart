import 'package:flutter/material.dart';
import 'dart:async';
import 'home_page.dart';

class EntryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EntryPage();
}

class _EntryPage extends State<EntryPage> {
  void handleTimeout() {
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (BuildContext context) => HomePage()));
  }

  startTimeout() async {
    var duration = const Duration(seconds: 4);
    return new Timer(duration, handleTimeout);
  }

  @override
  void initState() {
    startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(25.0),
      decoration: BoxDecoration(color: Colors.white),
      child: Stack(
        children: [
          Positioned(
              width: 430,
              bottom: -40,
              left: 0,
              child: Image.asset('assets/images/entry_bg.png')),
          Positioned(
              top: 150,
              width: MediaQuery.of(context).size.width,
              child: Container(
                // decoration: BoxDecoration(border: Border.all()),
                child: Text(
                  'Waste Analyzer',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Circular Std Black',
                      color: Colors.black87,
                      // fontFamily: 'Circular Std Black',
                      decoration: TextDecoration.none),
                ),
              )),
          Positioned(
            top: MediaQuery.of(context).size.width - 100,
            width: MediaQuery.of(context).size.width,
            child: Center(child: Container(
              // decoration: BoxDecoration(border: Border.all()),
              // width: 40 ,
                child: CircularProgressIndicator(
              backgroundColor: Colors.black87,
              strokeWidth: 1,
            )),),
          )
        ],
      ),
    );
  }
}
