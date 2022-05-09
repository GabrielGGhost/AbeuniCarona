import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:abeuni_carona/Entity/eEventBase.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:abeuni_carona/Constants/cDate.dart';

class EventBaseRegister extends StatefulWidget {

  DocumentSnapshot? eventBase;
  EventBaseRegister(this.eventBase);

  @override
  _EventBaseRegisterState createState() => _EventBaseRegisterState();
}

class _EventBaseRegisterState extends State<EventBaseRegister> {

  String? _idLoggedUser;
  String? _id = "";
  bool? _active = true;
  TextEditingController _eventNameController = TextEditingController();
  TextEditingController _obsEventController = TextEditingController();
  DocumentSnapshot? eventBase;
  bool _loeaded = false;
  String? _registration = "";

  FocusNode? _nameEventFocus;

  @override
  void initState() {
    _registration = Utils.getDateTimeNow(cDate.FORMAT_SLASH_DD_MM_YYYY_KK_MM);
    _nameEventFocus = FocusNode();
    _getUserData();
    super.initState();
  }

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

      _loeaded = true;
      Timestamp date = eventBase![DbData.COLUMN_REGISTRATION_DATE];
      _registration = Utils.getStringDateFromTimestamp(date, cDate.FORMAT_SLASH_DD_MM_YYYY_KK_MM);
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
                      focusNode: _nameEventFocus,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: textFieldDefaultDecoration(AppLocalizations.of(context)!.nomeDoEvento + "*")
                  ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                    controller: _obsEventController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 5,
                    decoration: textFieldDefaultDecoration(AppLocalizations.of(context)!.descricaoDoEvento)
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(
                            context)!
                            .registro,
                        style: TextStyle(
                            fontWeight:
                            FontWeight.bold),
                      ),
                      Text(": "),
                      Text(
                        _registration!,
                        style: TextStyle(
                            color: APP_SUB_TEXT),
                      )
                    ],
                  )
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
                            color: APP_WHITE_FONT, fontSize: 20
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
                                _active!);

    if(eventBase != null){

      if(checkFields()) return;

      update(base);

      Navigator.pop(context);
      Utils.showToast(AppLocalizations.of(context)!.eventoBaseAtualizaco, APP_SUCCESS_BACKGROUND);
    } else {

      if(checkFields()) return;

      base.registerDate = Timestamp.now();
      insert(base);

      Navigator.pop(context);
      Utils.showToast(AppLocalizations.of(context)!.eventoBaseCadastrado, APP_SUCCESS_BACKGROUND);
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

  bool checkFields() {

    if(_eventNameController.text == ""){
      Utils.showDialogBox(AppLocalizations.of(context)!.oEventoPrecisaDeUmNome, context);
      _nameEventFocus!.requestFocus();
      return true;
    }

    return false;
  }

  void _getUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;

    if(usuarioLogado != null){
      _idLoggedUser = usuarioLogado.uid;
    }
  }
}
