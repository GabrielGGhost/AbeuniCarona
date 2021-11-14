import 'dart:async';

import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Entity/eEvent.dart';
import 'package:abeuni_carona/Entity/eEventBase.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventRegister extends StatefulWidget {
  eEvent? event;
  EventRegister(this.event);

  @override
  _EventRegisterState createState() => _EventRegisterState();
}

class _EventRegisterState extends State<EventRegister> {
  double? radiusBorder = 16;
  var maskFormatter = new MaskTextInputFormatter(mask: '##/##/####');
  FirebaseFirestore db = FirebaseFirestore.instance;

  List<DropdownMenuItem<eEventBase>>? _dropdownMenuItems;
  final eventsBase = StreamController<QuerySnapshot>.broadcast();

  eEventBase? _selectedEventBase;
  String? codBaseEvent;

  TextEditingController _locationControler = TextEditingController();
  TextEditingController _eventStartDate = TextEditingController();
  TextEditingController _eventEndDate = TextEditingController();
  TextEditingController _registerStartDate = TextEditingController();
  TextEditingController _registerEndDate = TextEditingController();
  TextEditingController _obsEvent = TextEditingController();

  @override
  void initState() {
    _addListenerEventsBase();
    //_dropdownMenuItems = buildDropdownMenuItems(_eventsBase);
    super.initState();
  }

  Stream<QuerySnapshot>? _addListenerEventsBase() {
    final stream = db.collection(DbData.TABLE_BASE_EVENT).snapshots();

    stream.listen((data) {
      eventsBase.add(data);
    });
  }

  List<DropdownMenuItem<eEventBase>>? buildDropdownMenuItems(List events) {
    List<DropdownMenuItem<eEventBase>>? items = [];
    for (eEventBase event in events) {
      items.add(
        DropdownMenuItem(
          value: event,
          child: Text(event.eventName),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    eEvent? event = widget.event;

    if (event != null) {
      _locationControler.text = event.location;
      _eventStartDate.text = event.dateEventStart;
      _eventEndDate.text = event.dateEventEnd;
      _registerStartDate.text = event.dateRegisterStart;
      _registerEndDate.text = event.dateRegisterEnd;
      _obsEvent.text = event.obsEvent;
      //_selectedEventBase = _eventsBase[int.parse(event.codBaseEvent)];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.cadastroDeEvento),
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(cStyles.PADDING_DEFAULT_SCREEN),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(top: 0),
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection(DbData.TABLE_BASE_EVENT)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Center(
                          child: Text(AppLocalizations.of(context)!
                              .erroAoCarregarEventosBase),
                        );

                      return Container(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          children: <Widget>[
                            Text(AppLocalizations.of(context)!.base + ":  "),
                            DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: codBaseEvent,
                                isDense: true,
                                onChanged: (value) {
                                  setState(() {
                                    codBaseEvent = value as String;
                                  });
                                },
                                hint: Text(AppLocalizations.of(context)!
                                    .escolhaEventoBase),
                                items: snapshot.data!.docs
                                    .map((DocumentSnapshot document) {
                                  return DropdownMenuItem<String>(
                                    value: document.id,
                                    child: Text(document[DbData.COLUMN_NAME]),
                                  );
                                }).toList(),
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, cRoutes.EVENT_BASE_REGISTER);
                              },
                            )
                          ],
                        ),
                      );
                    })),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: TextField(
                  controller: _locationControler,
                  keyboardType: TextInputType.text,
                  decoration: textFieldDefaultDecoration(
                      AppLocalizations.of(context)!.localizacao)),
            ),
            Padding(
                padding: EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.dataDoEvento,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .essaEaDataQueOEventoSeraRealizado,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                )),
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(top: 5, right: 10),
                  child: TextField(
                    controller: _eventStartDate,
                    inputFormatters: [maskFormatter],
                    keyboardType: TextInputType.number,
                    decoration: textFieldDefaultDecoration(
                        AppLocalizations.of(context)!.inicio),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(top: 5, left: 10),
                  child: TextField(
                      controller: _eventEndDate,
                      inputFormatters: [maskFormatter],
                      keyboardType: TextInputType.number,
                      decoration: textFieldDefaultDecoration(
                          AppLocalizations.of(context)!.fim)),
                )),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: TextField(
                        controller: _obsEvent,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        decoration: textFieldDefaultDecoration(
                            AppLocalizations.of(context)!.observacoes)),
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
                        borderRadius: BorderRadius.circular(30))),
                child: Text(
                  AppLocalizations.of(context)!.registrarEvento,
                  style: (TextStyle(color: Colors.white, fontSize: 20)),
                ),
                onPressed: () {
                  Utils.showToast(
                      AppLocalizations.of(context)!.sucessoAoRegistrarEvento,
                      Colors.green);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      )),
    );
  }

  void _eventChanged(eEventBase? value) {
    setState(() {
      _selectedEventBase = value;
    });
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>>
      findAllEventsBase() async {
    List<eEventBase> loadedList = [];
    List<eEventBase> itemList = [];

    Stream<QuerySnapshot<Map<String, dynamic>>> baseEvents =
        await FirebaseFirestore.instance
            .collection(DbData.TABLE_BASE_EVENT)
            .snapshots();

    return baseEvents;
  }
}
