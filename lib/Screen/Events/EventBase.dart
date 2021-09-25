import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';

class EventBase extends StatefulWidget {
  const EventBase({Key? key}) : super(key: key);

  @override
  _EventBaseState createState() => _EventBaseState();
}

class _EventBaseState extends State<EventBase> {

  double? radiusBorder = 16;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eventos base"),
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(cStyles.PADDING_DEFAULT_SCREEN),
              child: Column(
              )
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(
              context,
              cRoutes.EVENT_BASE_REGISTER
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
