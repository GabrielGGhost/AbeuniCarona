import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:flutter/material.dart';

class Vechicles extends StatefulWidget {
  const Vechicles({Key? key}) : super(key: key);

  @override
  _VechiclesState createState() => _VechiclesState();
}

class _VechiclesState extends State<Vechicles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus Veículos"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Container()
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(
              context,
              cRoutes.VEHICLES_REGISTER
          );
        },

        backgroundColor: Colors.blueAccent,
        child: Icon(
            Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}