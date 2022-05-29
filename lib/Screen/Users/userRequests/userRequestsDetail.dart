import 'dart:async';

import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Entity/eEventBase.dart';
import 'package:abeuni_carona/Entity/eUser.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:abeuni_carona/Constants/cDate.dart';

class userRequestDetail extends StatefulWidget {
  DocumentSnapshot event;
  userRequestDetail(this.event);

  @override
  _userRequestDetailState createState() => _userRequestDetailState();
}

class _userRequestDetailState extends State<userRequestDetail> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  double? radiusBorder = 16;
  String? _idLoggedUser;

  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot event = widget.event;
    return Scaffold(
      appBar: AppBar(
        title: Text("Requisições de cadastro"),
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(cStyles.PADDING_DEFAULT_SCREEN),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                          backgroundColor: Colors.grey,
                          maxRadius: 70,
                          backgroundImage:
                              NetworkImage(event[DbData.COLUMN_PICTURE_PATH]))
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Card(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: Text(
                                      "Dados Cadastrais",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 12),
                                        child: RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: "Nome: ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: event[
                                                    DbData.COLUMN_USERNAME],
                                                style: TextStyle(
                                                    color: Colors.grey))
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 12),
                                        child: RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: "Apelido: ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: event[
                                                    DbData.COLUMN_NICKNAME],
                                                style: TextStyle(
                                                    color: Colors.grey))
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 12),
                                        child: RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: "Dt Nascimento: ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: event[
                                                    DbData.COLUMN_BIRTH_DATE],
                                                style: TextStyle(
                                                    color: Colors.grey))
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 12),
                                        child: RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: "Telefone: ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: event[
                                                    DbData.COLUMN_PHONE_NUMBER],
                                                style: TextStyle(
                                                    color: Colors.grey))
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 12),
                                        child: RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: "CPF: ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: event[DbData.COLUMN_CPF],
                                                style: TextStyle(
                                                    color: Colors.grey))
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 12),
                                        child: RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: "E-mail: ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text:
                                                    event[DbData.COLUMN_EMAIL],
                                                style: TextStyle(
                                                    color: Colors.grey))
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 12),
                                        child: RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: "Departamento: ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: event[
                                                    DbData.COLUMN_DEPARTMENT],
                                                style: TextStyle(
                                                    color: Colors.grey))
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 12),
                                        child: RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: "Dt Registro: ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: Utils.getStringDateFromTimestamp(event[DbData
                                                    .COLUMN_REGISTRATION_DATE], cDate.FORMAT_SLASH_DD_MM_YYYY_KK_MM) ,
                                                style: TextStyle(
                                                    color: Colors.grey))
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding:
                                        EdgeInsets.fromLTRB(28, 16, 28, 16),
                                    shape: CircleBorder()),
                                child: Icon(Icons.check),
                                onPressed: () {
                                  approveUser(event);
                                },
                              ),
                              ElevatedButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    padding:
                                        EdgeInsets.fromLTRB(28, 16, 28, 16),
                                    shape: CircleBorder()),
                                child: Icon(Icons.close),
                                onPressed: () {
                                  reproveUser(event);
                                },
                              )
                            ],
                          )),
                    ],
                  )
                ],
              ))),
    );
  }

  void _getUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;

    if (usuarioLogado != null) {
      _idLoggedUser = usuarioLogado.uid;
    }
  }

  void approve(DocumentSnapshot event) async {
    try {
      eUser newUser = eUser.full(
          event[DbData.COLUMN_USERNAME],
          event[DbData.COLUMN_EMAIL],
          event[DbData.COLUMN_PHONE_NUMBER],
          event[DbData.COLUMN_BIRTH_DATE],
          event[DbData.COLUMN_CPF],
          event[DbData.COLUMN_NICKNAME],
          event[DbData.COLUMN_DEPARTMENT],
          event[DbData.COLUMN_PICTURE_PATH],
          event[DbData.COLUMN_REGISTRATION_DATE],
          "0",
          "1",
          _idLoggedUser,
          Utils.getDateTimeNow(cDate.FORMAT_SLASH_DD_MM_YYYY_KK_MM));

      FirebaseFirestore db = FirebaseFirestore.instance;
      db
          .collection(DbData.TABLE_USER)
          .doc(event.id)
          .set(newUser.toMap())
          .then((value) {
        Utils.showToast("Aprovado com sucesso", APP_SUCCESS_BACKGROUND);
      }).catchError((error) {
        Utils.showAuthError(error.code, context);
      });
    } catch (e) {
      print(e);
      Utils.showToast("Falha ao aprovar usuário.", APP_ERROR_BACKGROUND);
    }
  }

  void reprove(DocumentSnapshot event) async {
    try {
      eUser newUser = eUser.full(
          event[DbData.COLUMN_USERNAME],
          event[DbData.COLUMN_EMAIL],
          event[DbData.COLUMN_PHONE_NUMBER],
          event[DbData.COLUMN_BIRTH_DATE],
          event[DbData.COLUMN_CPF],
          event[DbData.COLUMN_NICKNAME],
          event[DbData.COLUMN_DEPARTMENT],
          event[DbData.COLUMN_PICTURE_PATH],
          event[DbData.COLUMN_REGISTRATION_DATE],
          "0",
          "2",
          _idLoggedUser,
          Utils.getDateTimeNow(cDate.FORMAT_SLASH_DD_MM_YYYY_KK_MM));

      FirebaseFirestore db = FirebaseFirestore.instance;
      db
          .collection(DbData.TABLE_USER)
          .doc(event.id)
          .set(newUser.toMap())
          .then((value) {
        Utils.showToast("Reprovado com sucesso", APP_SUCCESS_BACKGROUND);
      }).catchError((error) {
        Utils.showAuthError(error.code, context);
      });
    } catch (e) {
      print(e);
      Utils.showToast("Falha ao reprovar usuário.", APP_ERROR_BACKGROUND);
    }
  }

  void reproveUser(DocumentSnapshot event) {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirmar"),
            content: Text("Tem certeza que deseja reprovar esta requisição?"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    reprove(event);
                    Navigator.of(context).pop(true);
                    Navigator.of(context).pop(true);
                  },
                  child: Text(AppLocalizations.of(context)!.tenhoCerteza)),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      AppLocalizations.of(context)!.cancelar,
                      style: TextStyle(
                        color: APP_MAIN_TEXT,
                      ),
                    ),
                  )),
            ],
          );
        });
  }

  approveUser(DocumentSnapshot<Object?> event) {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirmar"),
            content: Text("Tem certeza que deseja aprovar esta requisição?"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    approve(event);
                    Navigator.of(context).pop(true);
                    Navigator.of(context).pop(true);
                  },
                  child: Text(AppLocalizations.of(context)!.tenhoCerteza)),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      AppLocalizations.of(context)!.cancelar,
                      style: TextStyle(
                        color: APP_MAIN_TEXT,
                      ),
                    ),
                  )),
            ],
          );
        });
  }
}
