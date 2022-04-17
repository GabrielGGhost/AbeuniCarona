import 'dart:async';

import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';

class MyRides extends StatefulWidget {
  const MyRides({Key? key}) : super(key: key);

  @override
  _MyRidesState createState() => _MyRidesState();
}

class _MyRidesState extends State<MyRides> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  final _controllerBaseEvents = StreamController<QuerySnapshot>.broadcast();

  String? _idLoggedUser;

  Stream<QuerySnapshot>? _addListenerBorrowedVehicles() {
    final baseEvents = db.collection(DbData.TABLE_RIDE).snapshots();

    baseEvents.listen((data) {
      _controllerBaseEvents.add(data);
    });
  }

  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder(
          stream: _controllerBaseEvents.stream,
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
                          List<DocumentSnapshot> rides =
                          query.docs.toList();

                          DocumentSnapshot ride = rides[index];

                          bool edit = ride[DbData.COLUMN_DRIVER_ID] != null &&
                              ride[DbData.COLUMN_DRIVER_ID] != "" &&
                              ride[DbData.COLUMN_DRIVER_ID] == _idLoggedUser;

                          return Dismissible(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        ride[
                                        DbData
                                            .COLUMN_EVENT][DbData
                                            .COLUMN_EVENT_DESC_BASE_EVENT],
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Local de Partida: "),
                                      Text(
                                        ride[DbData
                                            .COLUMN_DEPARTURE_ADDRESS],
                                        style: TextStyle(
                                            color: APP_SUB_TEXT),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Data/Horário: "),
                                      Text(
                                        ride[DbData
                                            .COLUMN_DEPARTURE_DATE] +
                                            " - " +
                                            ride[DbData
                                                .COLUMN_DEPARTURE_TIME],
                                        style: TextStyle(
                                            color: APP_SUB_TEXT),
                                      )
                                    ],
                                  ),
                                  ride[DbData.COLUMN_RETURN_DATE] !=
                                      null &&
                                      ride[DbData
                                          .COLUMN_RETURN_DATE] !=
                                          ""
                                      ? Text(
                                    ride[DbData
                                        .COLUMN_RETURN_DATE] +
                                        " - " +
                                        ride[DbData
                                            .COLUMN_RETURN_TIME],
                                    style: TextStyle(
                                        color: APP_SUB_TEXT),
                                  )
                                      : Text(
                                    "Sem Dados de Retorno Informados",
                                    style: TextStyle(
                                        fontWeight:
                                        FontWeight.bold,
                                        color: APP_SUB_TEXT),
                                  ),
                                  Row(
                                    children: [
                                      Text("Motorista: "),
                                      Text(
                                        ride[DbData
                                            .COLUMN_DRIVER_NAME],
                                        style: TextStyle(
                                            color: APP_SUB_TEXT),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Registrado há : " + Utils.getDateTimeUntilNow(ride[DbData.COLUMN_REGISTRATION_DATE]))
                                    ],
                                  ),
                                  Divider(),
                                ],
                              ),
                            ),
                            confirmDismiss: (d) async {
                              if (d ==
                                  DismissDirection.startToEnd) {
                                Navigator.pushNamed(context,
                                    cRoutes.EVENT_BASE_REGISTER,
                                    arguments: ride);
                                return false;
                              } else {
                                return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                          AppLocalizations.of(
                                              context)!
                                              .confirmarExclusao),
                                      content: Text(
                                          "Tem certeza que deseja excluir esta carona?"),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                              //delete(ride.id);
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
                            key: Key(ride.id),
                            background: edit ? Container(
                              color: APP_EDIT_DISMISS,
                              child: Icon(Icons.edit),
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 15),
                              margin: EdgeInsets.only(bottom: 20),
                            ) : Container(
                              color: Colors.blueAccent,
                              child: Icon(Icons.edit),
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 15),
                              margin: EdgeInsets.only(bottom: 20),
                            ),
                            secondaryBackground: Container(
                              color: APP_REMOVE_DISMISS,
                              child: Icon(Icons.delete),
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
                            "Não há caronas disponíveis",
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
          }),
    );
  }

  void _getUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;

    if (usuarioLogado != null) {
      _idLoggedUser = usuarioLogado.uid;
    }
  }
}
