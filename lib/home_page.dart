import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  File file;
  var filename = '';
  var output = 0;
  var waste_type = '';
  var wasteTypes = [
    'Plastic',
    'Food',
    'Vegetable',
    'Plant',
    'Automobile',
    'Electronics'
  ];

  Widget loader() {
    return Center(
      child: Container(
          // decoration: BoxDecoration(border: Border.all()),
          // width: 40 ,
          child: CircularProgressIndicator(
        backgroundColor: Colors.black87,
        strokeWidth: 1,
      )),
    );
  }

  Widget image_report() {
    return Row(
      children: [
        Expanded(
          child: Container(
              margin: EdgeInsets.all(20),
              child: Text('Waste Type - $waste_type',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Circular Std Black',
                      fontSize: 15))),
        )
      ],
    );
  }

  Widget output_window() {
    return Container(
        margin: EdgeInsets.all(25.0),
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(40.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 25.0, // soften the shadow
              spreadRadius: 5.0, //extend the shadow
              offset: Offset(
                5.0, // Move to right 10  horizontally
                5.0, // Move to bottom 10 Vertically
              ),
            )
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                      margin: EdgeInsets.all(20),
                      child: Text('Report',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Circular Std Black',
                              fontSize: 20))),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                      margin: EdgeInsets.all(20),
                      child: output == 1 ? loader() : image_report()),
                )
              ],
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    waste_type = '';
                    output = 0;
                    filename = '';
                  });
                },
                child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.blueAccent),
                    child: Text(
                      'Close',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Circular Std Black',
                          fontSize: 20,
                          color: Colors.white),
                    )))
          ],
        ));
  }

  void analyzeImage() {
    var data;
    setState(() {
      output = 1;
    });
    final String api_link =
        'https://mwr06nama1.execute-api.us-east-1.amazonaws.com/dev/waste-analyzer';
    String base64Image = base64Encode(file.readAsBytesSync());
    http
        .post(api_link,
            body: jsonEncode(
                <String, String>{"name": filename, "image": base64Image}))
        .then((res) {
      data = List.from(Map.from(json.decode(res.body))['body']['Labels']);
      var loop = true;
      print(data.runtimeType);
      for (var x in data) {
        print(x['Name']);
        if (wasteTypes.contains(x['Name']) && loop) {
          setState(() {
            waste_type = x['Name'];
            output = 2;
            filename = '';
          });
          loop = false;
        }
      }
      if (loop) {
        setState(() {
          waste_type = 'Unable to detect';
          output = 2;
          filename = '';
        });
      }
      // // print(data['body']);
      // setState(() {
      //   output = 2;
      //   filename = '';
      // });
    }).catchError((err) {
      print(err);
    });
  }

  void _choose() async {
    // file = await ImagePicker.pickImage(source: ImageSource.camera);
    file = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        filename = file.path.split("/").last;
      });
    }
  }

  Widget uploader_icon() {
    return GestureDetector(
        onTap: () {
          _choose();
        },
        child: Icon(Icons.cloud_upload, size: 60));
  }

  Widget uplaod_button() {
    return GestureDetector(
        onTap: () {
          print('Analyze button tapped');
          analyzeImage();
        },
        child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(horizontal: 50),
            decoration: BoxDecoration(color: Colors.blueAccent),
            child: Text(
              'Analyze',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Circular Std Black',
                  fontSize: 20,
                  color: Colors.white),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: AppBar(
              title: Text('Home',
                  style: TextStyle(
                    fontFamily: 'Circular Std Black',
                    color: Colors.black87,
                  )),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            preferredSize: Size.fromHeight(50.0)),
        body: ListView(children: [
          Container(
              margin: EdgeInsets.all(25.0),
              // height: 220,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(40.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 25.0, // soften the shadow
                    spreadRadius: 5.0, //extend the shadow
                    offset: Offset(
                      5.0, // Move to right 10  horizontally
                      5.0, // Move to bottom 10 Vertically
                    ),
                  )
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.all(20),
                            child: Text('About Us',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Circular Std Black',
                                    fontSize: 20))),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.all(20),
                            child: Text(
                                'Waste Analyzer helps you to know about the waste by analyzing it\'s image.\nIt tell\'s you the type of waste it is and where you can dispose it',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontFamily: 'Circular Std Black',
                                    fontSize: 15))),
                      )
                    ],
                  )
                ],
              )),
          Container(
              margin: EdgeInsets.all(25.0),
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(40.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 25.0, // soften the shadow
                    spreadRadius: 5.0, //extend the shadow
                    offset: Offset(
                      5.0, // Move to right 10  horizontally
                      5.0, // Move to bottom 10 Vertically
                    ),
                  )
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.all(20),
                            child: Text('Select Image',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Circular Std Black',
                                    fontSize: 20))),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.all(20),
                            child: filename == ''
                                ? uploader_icon()
                                : uplaod_button()),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.all(20),
                            child: Text(filename,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Circular Std Black',
                                    fontSize: 15))),
                      )
                    ],
                  )
                ],
              )),
          output == 0 ? Container() : output_window()
        ]));
  }
}
