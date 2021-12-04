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
  DocumentSnapshot? event;
  EventRegister(this.event);

  @override
  _EventRegisterState createState() => _EventRegisterState();
}

class _EventRegisterState extends State<EventRegister> {
  double? radiusBorder = 16;
  var maskFormatter = new MaskTextInputFormatter(mask: '##/##/####');
  FirebaseFirestore db = FirebaseFirestore.instance;

  final eventsBase = StreamController<QuerySnapshot>.broadcast();
  DocumentSnapshot? event;

  String? _codBaseEvent;

  TextEditingController _locationControler = TextEditingController();
  TextEditingController _eventStartDate = TextEditingController();
  TextEditingController _eventEndDate = TextEditingController();
  TextEditingController _obsEvent = TextEditingController();

  FocusNode? _signFocus;
  FocusNode? _colorFocus;
  FocusNode? _modelFocus;

  @override
  void initState() {
    _addListenerEventsBase();
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
    event = widget.event;

    if (event != null) {
      _locationControler.text = event![DbData.COLUMN_LOCATION];
      _eventStartDate.text = event![DbData.COLUMN_START_DATE];
      _eventEndDate.text = event![DbData.COLUMN_END_DATE];
      _obsEvent.text = event![DbData.COLUMN_OBS];
      _codBaseEvent = event![DbData.COLUMN_COD_BASE_EVENT];
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
                      if (!snapshot.hasData){
                        return Center(
                          child: Text(AppLocalizations.of(context)!
                              .erroAoCarregarEventosBase),
                        );
                      }
                      return Container(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          children: <Widget>[
                            Text(AppLocalizations.of(context)!.base + ":  "),
                            DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: _codBaseEvent,
                                isDense: true,
                                onChanged: (value) {
                                  setState(() {
                                    _codBaseEvent = value as String;
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
                      AppLocalizations.of(context)!.localizacao +
                          AppLocalizations.of(context)!.obr)),
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
                        AppLocalizations.of(context)!.inicio +
                            AppLocalizations.of(context)!.obr),
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
                          AppLocalizations.of(context)!.fim +
                              AppLocalizations.of(context)!.obr)),
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
                  save();
                },
              ),
            ),
          ],
        ),
      )),
    );
  }

  void save() {
    eEvent e = new eEvent(null, _codBaseEvent, _locationControler.text,
        _eventStartDate.text, _eventEndDate.text, _obsEvent.text, null);

    if (event != null) {
      try {
        e.codEvent = event!.id;
        e.registrationDate = event![DbData.COLUMN_REGISTRATION_DATE];
        update(e);

        Navigator.pop(context);
        Utils.showToast(AppLocalizations.of(context)!.veiculoAtualizado,
            APP_SUCCESS_BACKGROUND);
      } catch (e) {
        Utils.showToast(AppLocalizations.of(context)!.erroAoAtualizar,
            APP_ERROR_BACKGROUND);
      }
    } else {
      if (checkFields()) {
        try {
          e.registrationDate = DateTime.now().toString();
          insert(e);
          Navigator.pop(context);
          Utils.showToast(
              "Evento cadastrado com sucesso", APP_SUCCESS_BACKGROUND);
        } catch (e) {
          Utils.showToast(AppLocalizations.of(context)!.erroAoInserir,
              APP_ERROR_BACKGROUND);
        }
      }
    }
  }

  bool checkFields() {
    if (!Utils.hasValue(_codBaseEvent)) {
      Utils.showDialogBox("É necessário escolher um evento base!", context);
      return false;
    }

    if (!Utils.hasValue(_locationControler.text)) {
      Utils.showDialogBox(
          "É necessário informar o local do evento!", context);
      return false;
    }

    if (!Utils.hasValue(_eventStartDate.text)) {
      Utils.showDialogBox(
          "É necessário informar a data de início do evento!", context);
      return false;
    }

    if (!Utils.hasValue(_eventEndDate.text)) {
      Utils.showDialogBox(
          "É necessário informar a data final do evento!", context);
      return false;
    }

    return true;
  }

  void insert(eEvent e) {
    db.collection(DbData.TABLE_EVENT)
        .add(e.toMap());
  }

  void update(eEvent e) {


  }
}
