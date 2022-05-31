import 'dart:async';

import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Entity/eUser.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:abeuni_carona/Constants/cDate.dart';

class usersList extends StatefulWidget {
  @override
  _usersListState createState() => _usersListState();
}

class _usersListState extends State<usersList> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  double? radiusBorder = 16;
  final _controllerUsersList = StreamController<QuerySnapshot>.broadcast();

  String? _idLoggedUser;
  Stream<QuerySnapshot>? _addListenerUsersList() {
    final usersList = db
        .collection(DbData.TABLE_USER)
        .where(DbData.COLUMN_APPROVED, isEqualTo: "1", )
        .snapshots();

    usersList.listen((data) {
      _controllerUsersList.add(data);
    });
  }

  @override
  void initState() {
    _addListenerUsersList();
    _getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de cadastros"),
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(cStyles.PADDING_DEFAULT_SCREEN),
              child: Column(
                children: [
                  StreamBuilder(
                      stream: _controllerUsersList.stream,
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

                                      return GestureDetector(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5,
                                                  horizontal: 10),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "Há " + getDateTimeUntilNow(Utils.getStringDateFromTimestamp(event[DbData.COLUMN_REGISTRATION_DATE], cDate.FORMAT_SLASH_DD_MM_YYYY_KK_MM)!) + " atrás",
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
                                                        ),
                                                        Divider()
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  cRoutes.USER_PERFIL,
                                                  arguments: event);
                                            },
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
                                        "Ainda não há usuários cadastrados!",
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
