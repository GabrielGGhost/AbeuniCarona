import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'package:abeuni_carona/Entity/eEvent.dart';
import 'package:abeuni_carona/Entity/eEventBase.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Events extends StatefulWidget {
  const Events({Key? key}) : super(key: key);

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {

  List<eEvent> _events = eEvent.getEvents();
  List<eEventBase> _eventsBase = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.eventos),
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
      ),
      body: _events != null && _events.length > 0 ?
      SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(cStyles.PADDING_DEFAULT_SCREEN),
              child: Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: _events.length,
                      itemBuilder: (_, index){
                        eEvent? event = _events[index];
                        eEventBase base = _eventsBase[int.parse(event.codBaseEvent)];
                        return  Dismissible(
                          child:  Padding(
                            padding: EdgeInsets.only(bottom: 15),
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
                          ),
                          confirmDismiss: (d) async {
                            if(d == DismissDirection.startToEnd) {
                              Navigator.pushNamed(
                                  context,
                                  cRoutes.EVENT_REGISTER,
                                  arguments: event
                              );
                              return false;
                            } else {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Confirmar exclusão"),
                                    content: Text("Tem certeza que deseja cancelar este carro?"),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () => Navigator.of(context).pop(true),
                                          child: Text("Tenho certeza")
                                      ),
                                      TextButton(
                                          onPressed: () => Navigator.of(context).pop(false),
                                          child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              "Cancelar",
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          )
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          key: Key(event.codEvent),
                          background: Container(
                            color: Colors.green,
                            child: Icon(Icons.edit),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 15),
                            margin: EdgeInsets.only(bottom: 20),
                          ),
                          secondaryBackground: Container(
                            color: Colors.redAccent,
                            child: Icon(Icons.delete),
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 15),
                            margin: EdgeInsets.only(bottom: 20),
                          ),
                        );
                      }
                  )
                ],
              )
          )
      )
          : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Não há eventos base cadastrados\nClique no + para registrar um",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          )
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child:FloatingActionButton(
                          onPressed: (){
                          },
                          backgroundColor: Colors.blueAccent,
                          child: Icon(
                            Icons.filter_alt_sharp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      FloatingActionButton(
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
                    ],
                  ),
                ],
              )
          )

        ],
      )
    );
  }
}
