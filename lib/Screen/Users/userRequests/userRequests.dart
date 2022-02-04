import 'dart:async';

import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Entity/eEventBase.dart';
import 'package:abeuni_carona/Entity/eUser.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:abeuni_carona/Constants/cImages.dart';
import 'package:abeuni_carona/Constants/cDate.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class userRequests extends StatefulWidget {
  @override
  _userRequestsState createState() => _userRequestsState();
}

class _userRequestsState extends State<userRequests> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  double? radiusBorder = 16;
  final _controllerUserRequests = StreamController<QuerySnapshot>.broadcast();

  String? _idLoggedUser;
  Stream<QuerySnapshot>? _addListenerBorrowedVehicles() {
    final baseEvents = db
        .collection(DbData.TABLE_USER)
        .where(DbData.COLUMN_ROLE, isEqualTo: "0")
        .where(DbData.COLUMN_APPROVED, isEqualTo: "0")
        .snapshots();

    baseEvents.listen((data) {
      _controllerUserRequests.add(data);
    });
  }

  @override
  void initState() {
    _addListenerBorrowedVehicles();
    _getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  StreamBuilder(
                      stream: _controllerUserRequests.stream,
                      builder: (_, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return Center(
                              child: Column(
                                children: [CircularProgressIndicator()],
                              ),
                            );
                          case ConnectionState.active:
                          case ConnectionState.done:
                            QuerySnapshot query =
                                snapshot.data as QuerySnapshot;

                            if (snapshot.hasError) {
                              return Center(
                                child: Column(
                                  children: [
                                    Text(AppLocalizations.of(context)!
                                        .erroAoCarregarDados)
                                  ],
                                ),
                              );
                            } else {
                              if (query.docs.length > 0) {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount: query.docs.length,
                                    itemBuilder: (_, index) {
                                      List<DocumentSnapshot> baseEvents =
                                          query.docs.toList();

                                      DocumentSnapshot event =
                                          baseEvents[index];

                                      return Dismissible(
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 15),
                                          child: Card(
                                            child: GestureDetector(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 15,
                                                    horizontal: 10),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            "Há " + getDateTimeUntilNow(event[DbData.COLUMN_REGISTRATION_DATE]) + " atrás",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 12),
                                                          ),
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 10),
                                                              child: CircleAvatar(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .grey,
                                                                  maxRadius: 35,
                                                                  backgroundImage:
                                                                      NetworkImage(
                                                                          event[
                                                                              DbData.COLUMN_PICTURE_PATH]))),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 10),
                                                            child: Text(
                                                              event[DbData
                                                                  .COLUMN_USERNAME],
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 10),
                                                            child: Text(
                                                              "Ver detalhes",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 12),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.pushNamed(context,
                                                    cRoutes.USER_REQUEST_DETAIL,
                                                    arguments: event);
                                              },
                                            ),
                                          ),
                                        ),
                                        confirmDismiss: (d) async {
                                          if (d ==
                                              DismissDirection.startToEnd) {
                                            return await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Confirmar"),
                                                  content: Text(
                                                      "Tem certeza que deseja aprovar esta requisição sem ver os detalhes?"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                        onPressed: () {
                                                          approve(event);
                                                          Navigator.of(context)
                                                              .pop(true);
                                                        },
                                                        child: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .tenhoCerteza)),
                                                    TextButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(false),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          child: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .cancelar,
                                                            style: TextStyle(
                                                              color:
                                                                  APP_MAIN_TEXT,
                                                            ),
                                                          ),
                                                        )),
                                                  ],
                                                );
                                              },
                                            );
                                          } else {
                                            return await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Confirmar"),
                                                  content: Text(
                                                      "Tem certeza que deseja reprovar esta requisição?"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                        onPressed: () {
                                                          reprove(event);
                                                          Navigator.of(context)
                                                              .pop(true);
                                                        },
                                                        child: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .tenhoCerteza)),
                                                    TextButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(false),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          child: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .cancelar,
                                                            style: TextStyle(
                                                              color:
                                                                  APP_MAIN_TEXT,
                                                            ),
                                                          ),
                                                        )),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                        key: Key(event.id),
                                        background: Container(
                                          color: APP_EDIT_DISMISS,
                                          child: Icon(Icons.check),
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.only(left: 15),
                                          margin: EdgeInsets.only(bottom: 20),
                                        ),
                                        secondaryBackground: Container(
                                          color: APP_REMOVE_DISMISS,
                                          child: Icon(Icons.close),
                                          alignment: Alignment.centerRight,
                                          padding: EdgeInsets.only(right: 15),
                                          margin: EdgeInsets.only(bottom: 20),
                                        ),
                                      );
                                    });
                              } else {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Não há requisições de cadastro para serem aprovadas",
                                        style: TextStyle(
                                          color: APP_SUB_TEXT,
                                          fontSize: 20,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                        }
                      })
                ],
              ))),
    );
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

  void _getUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;

    if (usuarioLogado != null) {
      _idLoggedUser = usuarioLogado.uid;
    }
  }

  void deleteUserPictureRequest(DocumentSnapshot<Object?> event) {
    Reference storeRef =
        FirebaseStorage.instance.refFromURL(event[DbData.COLUMN_PICTURE_PATH]);
    storeRef.delete();
  }

  String getDateTimeUntilNow(dateTime) {
    return Utils.getDateTimeUntilNow(dateTime);
  }
}
