import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Partaker extends StatefulWidget {
  const Partaker({Key? key}) : super(key: key);

  @override
  _partakerState createState() => _partakerState();
}

class _partakerState extends State<Partaker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Participantes"),
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
      ),
      body: SingleChildScrollView(
        child: Column(

        ),
      ),
    );

  }
}
