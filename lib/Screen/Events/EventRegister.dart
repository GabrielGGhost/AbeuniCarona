import 'package:abeuni_carona/Entity/EventBase.dart';
import 'package:flutter/material.dart';

class EventRegister extends StatefulWidget {
  const EventRegister({Key? key}) : super(key: key);

  @override
  _EventRegisterState createState() => _EventRegisterState();
}

class _EventRegisterState extends State<EventRegister> {

  double? radiusBorder = 16;

  List<DropdownMenuItem<EventBase>>? _dropdownMenuItems;
  List<EventBase> _eventsBase = EventBase.getEventsBase();
  EventBase? _selectedEventBase;



  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_eventsBase);
    super.initState();
  }

  List<DropdownMenuItem<EventBase>>? buildDropdownMenuItems(List events) {
    List<DropdownMenuItem<EventBase>>? items = [];
    for (EventBase event in events) {
      items.add(
        DropdownMenuItem(
          value: event,
          child: Text(event.eventName!),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de eventos"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: Row(
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: _selectedEventBase,
                          items: _dropdownMenuItems,
                          onChanged: _eventChanged,
                          hint: Text("Selecione um evento"),
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        highlightColor: Colors.blueAccent,

                        icon: Icon(Icons.add),
                        onPressed: () {  },
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Localização",
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
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                                "Data do evento",
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ), Row(
                          children: [
                            Text(
                                "Esta é a data que o evento será realizado",
                              style: TextStyle(
                                color: Colors.grey
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                ),
                Row(
                      children: [
                        Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 5, right: 10),
                              child: TextField(
                                keyboardType: TextInputType.datetime,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                                    hintText: "Ínicio",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(radiusBorder!)
                                    )
                                ),
                              ),
                            )
                        ),
                        Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 5, left: 10),
                              child: TextField(
                                keyboardType: TextInputType.datetime,

                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                                    hintText: "Fim",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(radiusBorder!)
                                    )
                                ),
                              ),
                            )
                        ),
                  ],
                ),
                Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Data disponível para carona",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ), Row(
                          children: [
                            Expanded(
                                child:                             Text(
                                  "Esta é a data que a realização de caronas estará disponível",
                                  style: TextStyle(
                                      color: Colors.grey
                                  ),
                                ),
                            )
                          ],
                        ),
                      ],
                    )
                ),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 5, right: 10),
                          child: TextField(
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                                hintText: "Ínicio",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(radiusBorder!)
                                )
                            ),
                          ),
                        )
                    ),
                    Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 5, left: 10),
                          child: TextField(
                            keyboardType: TextInputType.datetime,

                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                                hintText: "Fim",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(radiusBorder!)
                                )
                            ),
                          ),
                        )
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top:20),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          maxLines: 5,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                              hintText: "Observações",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(radiusBorder!)
                              )
                          ),
                        ),
                      ),
                    ),
                  ],
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
                      "Registrar evento",
                      style: (
                          TextStyle(
                              color: Colors.white, fontSize: 20
                          )
                      ),
                    ),
                    onPressed: (){

                    },
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }

  void _eventChanged(EventBase? value) {
    setState(() {
      _selectedEventBase = value;
    });
  }
}
