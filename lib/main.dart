import 'package:flutter/material.dart';

//import 'imagepickerlast.dart';
import 'package:multiplevideo/pickfile/imagepicker.dart';
import 'package:multiplevideo/skeletonview.dart';
//import 'package:multiplevideo/filepicker.dart';
//import 'package:multiplevideo/imagepicker.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FilePickerDemo()// Skeletonview() // //MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
