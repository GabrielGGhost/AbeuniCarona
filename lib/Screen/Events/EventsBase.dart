import 'package:flutter/material.dart';

class EventsBase extends StatefulWidget {
  const EventsBase({Key? key}) : super(key: key);

  @override
  _EventsBaseState createState() => _EventsBaseState();
}

class _EventsBaseState extends State<EventsBase> {

  double? radiusBorder = 16;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Placa",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(radiusBorder!)
                      )
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Cor",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(radiusBorder!)
                      )
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.fromLTRB(28, 16, 28, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)
                      )
                  ),
                  child: Text(
                    "Registrar esse carro",
                    style: (
                        TextStyle(
                            color: Colors.white, fontSize: 20
                        )
                    ),
                  ),
                  onPressed: (){
                  },
                ),
              )
            ],
          ),
        )
    );
  }
}
