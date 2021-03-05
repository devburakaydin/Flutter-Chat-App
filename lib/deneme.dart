import 'package:flutter/material.dart';

class Deneme extends StatefulWidget {
  @override
  _DenemeState createState() => _DenemeState();
}

class _DenemeState extends State<Deneme> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClipPath(
        //clipper: MyCustomClipper(),
        child: Container(
          color: Colors.yellow,
          width: double.infinity,
          height: 300.0,
        ),
      ),
    );
  }
}
