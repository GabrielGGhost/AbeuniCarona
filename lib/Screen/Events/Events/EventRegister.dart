import 'dart:async';
import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Entity/eEvent.dart';
import 'package:abeuni_carona/Entity/eEventBase.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
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

  String? _descBaseEvent;
  String? _descBaseEventAtual;

  TextEditingController _locationControler = TextEditingController();
  TextEditingController _eventStartDate = TextEditingController();
  TextEditingController _eventEndDate = TextEditingController();
  TextEditingController _obsEvent = TextEditingController();

  FocusNode? _signFocus;
  FocusNode? _colorFocus;
  FocusNode? _modelFocus;

  bool loaded = false;
  bool _done = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    event = widget.event;

    if (event != null && loaded == false) {
      _locationControler.text = event![DbData.COLUMN_LOCATION];
      _eventStartDate.text = event![DbData.COLUMN_START_DATE];
      _eventEndDate.text = event![DbData.COLUMN_END_DATE];
      _obsEvent.text = event![DbData.COLUMN_OBS];
      _descBaseEventAtual = event![DbData.COLUMN_EVENT_DESC_BASE_EVENT];

      _done = event![DbData.COLUMN_DONE] != null && event![DbData.COLUMN_DONE] != false ? true : false;

      loaded = true;
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
                      if (!snapshot.hasData) {
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
                                value: _descBaseEvent != null
                                    ? _descBaseEvent
                                    : _descBaseEventAtual,
                                isDense: true,
                                onChanged: (value) {
                                  setState(() {
                                    _descBaseEvent = value as String;
                                  });
                                },
                                hint: Text(AppLocalizations.of(context)!
                                    .escolhaEventoBase),
                                items: snapshot.data!.docs
                                    .map((DocumentSnapshot document) {
                                  return DropdownMenuItem<String>(
                                    value: document[DbData.COLUMN_NAME],
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
            Visibility(
              child: Padding(
                padding: EdgeInsets.all(0),
                child: Row(
                  children: [
                    Checkbox(
                      checkColor: APP_CHECK_COLOR,
                      value: _done,
                      onChanged: (bool? value) {
                        setState(() {
                          _done = !_done;
                        });
                        saveStatus();
                      },
                    ),
                    RichText(
                      text: TextSpan(
                          text: AppLocalizations.of(context)!.ativo,
                          style: TextStyle(
                              color: _done ? APP_MAIN_TEXT : APP_SUB_TEXT
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              setState(() {
                                _done = !_done;
                              });
                              saveStatus();
                            }
                      ),
                    )
                  ],
                ),
              ),
              visible: event != null,
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
    _descBaseEvent =
        _descBaseEventAtual != null && _descBaseEventAtual!.length > 0
            ? _descBaseEventAtual
            : _descBaseEvent;

    eEvent e = new eEvent(null, _descBaseEvent, _locationControler.text,
        _eventStartDate.text, _eventEndDate.text, _obsEvent.text, null, _done);

    if (event != null) {
      try {
        e.codEvent = event!.id;
        e.done = _done;
        e.registrationDate = event![DbData.COLUMN_REGISTRATION_DATE];
        update(e);

        Navigator.pop(context);
        Utils.showToast("Evento Atualizado", APP_SUCCESS_BACKGROUND);
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
    if (!Utils.hasValue(_descBaseEvent)) {
      Utils.showDialogBox("É necessário escolher um evento base!", context);
      return false;
    }

    if (!Utils.hasValue(_locationControler.text)) {
      Utils.showDialogBox("É necessário informar o local do evento!", context);
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
    db.collection(DbData.TABLE_EVENT).add(e.toMap());
  }

  void update(eEvent e) {
    db.collection(DbData.TABLE_EVENT).doc(e.codEvent).update(e.toMap());
  }

  void updateStatus(String codEvent, bool done) {
    db.collection(DbData.TABLE_EVENT).doc(codEvent).update({
      "done" : done
    });
  }

  void saveStatus() {
    if (event != null) {
      try {
        updateStatus(event!.id, _done);

        Utils.showToast("Status Atualizado", APP_SUCCESS_BACKGROUND);
      } catch (e) {
        Utils.showToast(AppLocalizations.of(context)!.erroAoAtualizar,
            APP_ERROR_BACKGROUND);
      }
    }
  }
}
