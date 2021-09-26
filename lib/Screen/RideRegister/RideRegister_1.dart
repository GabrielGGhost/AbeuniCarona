import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:abeuni_carona/Entity/eEvent.dart';
import 'package:abeuni_carona/Entity/eEventBase.dart';
import 'package:abeuni_carona/Screen/Events/EventRegister.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';

class RideRegister_1 extends StatefulWidget {
  const RideRegister_1({Key? key}) : super(key: key);

  @override
  _RideRegister_1State createState() => _RideRegister_1State();
}

class _RideRegister_1State extends State<RideRegister_1> {

  List<eEvent> _events = eEvent.getEvents();
  List<eEventBase> _eventsBase = eEventBase.getEventsBase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de evento"),
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
      ),
      body: true ? SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(cStyles.PADDING_DEFAULT_SCREEN),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Escolha o evento que será realizado",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),
                  ),
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: _events.length,
                      itemBuilder: (_, index){
                        eEvent? event = _events[index];
                        eEventBase base = _eventsBase[int.parse(event.codBaseEvent)];
                        return  Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(
                                  context,
                                );
                              },
                              onLongPress: (){
                                Utils.showToast("Longepress");
                              },
                              child: Card(
                                child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              base.eventName,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Local: ",
                                                style: TextStyle(
                                                    fontSize: 12
                                                ),
                                              ),
                                              Text(" - "),
                                              Text(
                                                event.location,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 11
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Spacer(),
                                            Text(
                                              event.dateEventStart,
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 11
                                              ),
                                            ),
                                            Text(" - "),
                                            Text(
                                              event.dateEventEnd,
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 11
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                ),
                              ),
                            )
                        );
                      }
                  )
              )
            ],
          )
        )
      ) : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Não há eventos disponíveis ainda\nEspero o administrador iniciar um",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          )
      ),
    );
  }
}
