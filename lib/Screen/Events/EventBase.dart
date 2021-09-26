import 'package:abeuni_carona/Entity/eEventBase.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';

class EventBase extends StatefulWidget {
  @override
  _EventBaseState createState() => _EventBaseState();
}

class _EventBaseState extends State<EventBase> {

  double? radiusBorder = 16;
  List<eEventBase> _eventBase = eEventBase.getEventsBase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eventos base"),
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
      ),
      body: _eventBase != null && _eventBase.length > 0 ?
          SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(cStyles.PADDING_DEFAULT_SCREEN),
              child: Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: _eventBase.length,
                      itemBuilder: (_, index){
                        eEventBase? event = _eventBase[index];
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
                                            event.eventName,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            event.obsEvent,
                                            style: TextStyle(
                                                color: Colors.grey
                                            ),
                                          )
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
                                  cRoutes.EVENT_BASE_REGISTER,
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
                          key: Key(event.id),
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
