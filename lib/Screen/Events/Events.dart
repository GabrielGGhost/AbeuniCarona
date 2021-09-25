import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:flutter/material.dart';

class Events extends StatefulWidget {
  const Events({Key? key}) : super(key: key);

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eventos"),
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
      ),
      body: SingleChildScrollView(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context,
                      cRoutes.EVENT_REGISTER
                  );
                },
                child: Icon(Icons.add),
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
          )

        ],
      )
    );
  }
}
