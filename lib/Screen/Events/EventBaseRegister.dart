import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:abeuni_carona/Entity/eEventBase.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventBaseRegister extends StatefulWidget {

  DocumentSnapshot? eventBase;
  EventBaseRegister(this.eventBase);

  @override
  _EventBaseRegisterState createState() => _EventBaseRegisterState();
}

class _EventBaseRegisterState extends State<EventBaseRegister> {

  String? _registrationDate = "";
  String? _id = "";
  bool? _active = true;
  TextEditingController _eventNameController = TextEditingController();
  TextEditingController _obsEventController = TextEditingController();
  DocumentSnapshot? eventBase;
  bool _loeaded = false;

  @override
  Widget build(BuildContext context) {
    eventBase = widget.eventBase;

    String title = AppLocalizations.of(context)!.cadastroDeEventoBase;
    String buttonText = AppLocalizations.of(context)!.registrarEventoBase;


    if(eventBase != null && !_loeaded){
      _eventNameController.text = eventBase![DbData.COLUMN_NAME];
      _obsEventController.text = eventBase![DbData.COLUMN_OBS];
      _id = eventBase!.id;
      _active = eventBase![DbData.COLUMN_ACTIVE] != null && eventBase![DbData.COLUMN_ACTIVE] != false?  true : false;
      _registrationDate = eventBase![DbData.COLUMN_REGISTRATION_DATE];

      _loeaded = true;
    }
    if(eventBase != null){
      title = AppLocalizations.of(context)!.alteracaoDeEventoBase;
      buttonText = AppLocalizations.of(context)!.atualizar;
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(cStyles.PADDING_DEFAULT_SCREEN),
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: TextField(
                      controller: _eventNameController,
                      keyboardType: TextInputType.text,
                      decoration: textFieldDefaultDecoration(AppLocalizations.of(context)!.nomeDoEvento)
                  ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                    controller: _obsEventController,
                    keyboardType: TextInputType.text,
                    maxLines: 5,
                    decoration: textFieldDefaultDecoration(AppLocalizations.of(context)!.descricaoDoEvento)
                ),
              ),
              Row(
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Checkbox(
                            checkColor: APP_CHECK_COLOR,
                            value: _active,
                            onChanged: (bool? value) {
                              setState(() {
                                _active = !_active!;
                              });
                            },
                          ),
                          RichText(
                            text: TextSpan(
                                text: AppLocalizations.of(context)!.ativo,
                                style: TextStyle(
                                  color: _active! ? APP_MAIN_TEXT : APP_SUB_TEXT
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    setState(() {
                                      _active = !_active!;
                                    });
                                  }
                            ),
                          )
                        ],
                      )
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                      backgroundColor: APP_BAR_BACKGROUND_COLOR,
                      padding: EdgeInsets.fromLTRB(28, 16, 28, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)
                      )
                  ),
                  child: Text(
                    buttonText,
                    style: (
                        TextStyle(
                            color: APP_HINT_TEXT_FIELD, fontSize: 20
                        )
                    ),
                  ),
                  onPressed: (){
                    save();
                  },
                ),
              )
          ]
        )
      )
      )
    );
  }

  void save() {
    eEventBase base = eEventBase(_id,
                                _eventNameController.text,
                                _obsEventController.text,
                                _active!,
                                _registrationDate!);

    if(eventBase != null){

      update(base);

      Navigator.pop(context);
      Utils.showToast(AppLocalizations.of(context)!.eventoBaseAtualizaco, APP_SUCCESS_BACKGROUND);
    } else {
      base.registerDate = DateTime.now().toString();
      insert(base);

      Navigator.pop(context);
      Utils.showToast(AppLocalizations.of(context)!.eventoBaseCadastrado, APP_ERROR_BACKGROUND);
    }

  }

  void insert(eEventBase base) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection(DbData.TABLE_BASE_EVENT)
        .add(
          base.toMap()
        );
  }

  void update(eEventBase base) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection(DbData.TABLE_BASE_EVENT)
        .doc(_id)
        .update(base.toMap());
  }
}
