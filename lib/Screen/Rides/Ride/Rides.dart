import 'dart:async';

import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Entity/eEventBase.dart';
import 'package:abeuni_carona/Entity/eRide.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Rides extends StatefulWidget {
  @override
  _RidesState createState() => _RidesState();
}

class _RidesState extends State<Rides> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  double? radiusBorder = 16;
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
    _addListenerBorrowedVehicles();
    _getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Caronas"),
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(cStyles.PADDING_DEFAULT_SCREEN),
              child: Column(
                children: [
                  StreamBuilder(
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

                                      bool edit =
                                          ride[DbData.COLUMN_DRIVER_ID] !=
                                                  null &&
                                              ride[DbData.COLUMN_DRIVER_ID] !=
                                                  "" &&
                                              ride[DbData.COLUMN_DRIVER_ID] ==
                                                  _idLoggedUser;

                                      return Dismissible(
                                        child: GestureDetector(
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
                                                    Expanded(
                                                        child: RichText(
                                                      text: TextSpan(
                                                        style: const TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black,
                                                        ),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  'Localização: '),
                                                          TextSpan(
                                                              text: ride[DbData
                                                                      .COLUMN_EVENT]
                                                                  [DbData
                                                                      .COLUMN_LOCATION],
                                                              style: TextStyle(
                                                                  color:
                                                                      APP_SUB_TEXT)),
                                                        ],
                                                      ),
                                                    )),
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
                                                            color:
                                                                APP_SUB_TEXT),
                                                      )
                                                    : Text(
                                                        "Sem Dados de Retorno Informados",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                APP_SUB_TEXT),
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
                                                    Text("Vagas: "),
                                                    FutureBuilder(
                                                        future:
                                                            findAllSchedulingSeatsByRide(
                                                                ride.id),
                                                        builder: (_, snapshot) {
                                                          int totalSeats = int.parse(
                                                              Utils.getSafeNumber(ride[
                                                                  DbData
                                                                      .COLUMN_VEHICLE][DbData
                                                                  .COLUMN_SEATS]));

                                                          if (snapshot
                                                              .hasError) {
                                                            return Text(
                                                                "Carregando...",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .redAccent));
                                                          } else if (!snapshot
                                                              .hasData) {
                                                            return Text(
                                                                "Carregando...",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .redAccent));
                                                          } else {
                                                            int reservedSeats =
                                                                int.parse(snapshot
                                                                    .data
                                                                    .toString());
                                                            int currentSeats =
                                                                totalSeats -
                                                                    reservedSeats;
                                                            if (currentSeats ==
                                                                0) {
                                                              return Text(
                                                                "LOTADO",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .redAccent),
                                                              );
                                                            }
                                                            return Text(
                                                                (currentSeats
                                                                        .toString())
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey));
                                                          }
                                                        })
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text("Bagagens: "),
                                                    FutureBuilder(
                                                        future:
                                                            findAllSchedulingLuggagesByRide(
                                                                ride.id),
                                                        builder: (_, snapshot) {
                                                          int totalLuggages =
                                                              int.parse(Utils
                                                                  .getSafeNumber(ride[
                                                                      DbData
                                                                          .COLUMN_VEHICLE][DbData
                                                                      .COLUMN_LUGGAGE_SPACES]));

                                                          if (snapshot
                                                              .hasError) {
                                                            return Text(
                                                                "Carregando...",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .redAccent));
                                                          } else if (!snapshot
                                                              .hasData) {
                                                            return Text(
                                                                "Carregando...",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .redAccent));
                                                          } else {
                                                            int reservedLuggages =
                                                                int.parse(snapshot
                                                                    .data
                                                                    .toString());
                                                            int currentLuggages =
                                                                totalLuggages -
                                                                    reservedLuggages;
                                                            if (currentLuggages ==
                                                                0) {
                                                              return Text(
                                                                "LOTADO",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .redAccent),
                                                              );
                                                            }
                                                            return Text(
                                                                (currentLuggages
                                                                        .toString())
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey));
                                                          }
                                                        })
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text("Registrado há : " +
                                                        Utils.getDateTimeUntilNow(
                                                            ride[DbData
                                                                .COLUMN_REGISTRATION_DATE]))
                                                  ],
                                                ),
                                                Divider(),
                                              ],
                                            ),
                                          ),
                                          onTap: () async {
                                            if (edit) {
                                              await Navigator.pushNamed(
                                                  context, cRoutes.PARTAKER,
                                                  arguments: ride);
                                            } else {
                                              await Navigator.pushNamed(
                                                  context, cRoutes.SCHEDULING,
                                                  arguments: ride);
                                            }

                                            _addListenerBorrowedVehicles();
                                          },
                                        ),
                                        confirmDismiss: (d) async {
                                          eRide r = eRide();
                                          r.docToRide(ride);
                                          if (d ==
                                              DismissDirection.startToEnd) {
                                            eRide rid = eRide();
                                            rid.docToRide(ride);
                                            if (edit) {
                                              await Navigator.pushNamed(context,
                                                  cRoutes.REGISTER_RIDE5,
                                                  arguments: {
                                                    'ride': rid,
                                                    'edit': true
                                                  });
                                            } else {
                                              await Navigator.pushNamed(
                                                  context, cRoutes.SCHEDULING,
                                                  arguments: ride);
                                            }
                                            return false;
                                          } else {
                                            return edit
                                                ? await showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
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
                                                                delete(ride.id);
                                                                Navigator.of(
                                                                        context)
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
                                                                      .pop(
                                                                          false),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                child: Text(
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .cancelar,
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        APP_MAIN_TEXT,
                                                                  ),
                                                                ),
                                                              )),
                                                        ],
                                                      );
                                                    },
                                                  )
                                                : null;
                                          }
                                        },
                                        key: Key(ride.id),
                                        background: edit
                                            ? Container(
                                                color: APP_EDIT_DISMISS,
                                                child: Icon(Icons.edit),
                                                alignment: Alignment.centerLeft,
                                                padding:
                                                    EdgeInsets.only(left: 15),
                                                margin:
                                                    EdgeInsets.only(bottom: 20),
                                              )
                                            : Container(
                                                color: Colors.blueAccent,
                                                child: Icon(Icons.timer),
                                                alignment: Alignment.centerLeft,
                                                padding:
                                                    EdgeInsets.only(left: 15),
                                                margin:
                                                    EdgeInsets.only(bottom: 20),
                                              ),
                                        secondaryBackground: edit
                                            ? Container(
                                                color: APP_REMOVE_DISMISS,
                                                child: Icon(Icons.delete),
                                                alignment:
                                                    Alignment.centerRight,
                                                padding:
                                                    EdgeInsets.only(right: 15),
                                                margin:
                                                    EdgeInsets.only(bottom: 20),
                                              )
                                            : Container(),
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
                      })
                ],
              ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, cRoutes.REGISTER_RIDE1);
        },
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
        child: Icon(
          Icons.add,
          color: APP_WHITE_FONT,
        ),
      ),
    );
  }

  void delete(String id) {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      db.collection(DbData.TABLE_RIDE).doc(id).delete();

      Utils.showToast(
          AppLocalizations.of(context)!.deletado, APP_SUCCESS_BACKGROUND);
    } catch (e) {
      Utils.showToast("Falha ao deletar carona!", APP_ERROR_BACKGROUND);
    }
  }

  void _getUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;

    if (usuarioLogado != null) {
      _idLoggedUser = usuarioLogado.uid;
    }
  }

  Future<int> findAllSchedulingSeatsByRide(String rideId) async {
    QuerySnapshot<Map<String, dynamic>> result = await db
        .collection(DbData.TABLE_SCHEDULING)
        .where(DbData.COLUMN_RIDE_ID, isEqualTo: rideId)
        .get();

    final allData = result.docs.map((doc) => doc.data()).toList();
    int totalReservedSeats = 0;
    for (var schedule in allData) {
      totalReservedSeats += int.parse(
          Utils.getSafeNumber(schedule[DbData.COLUMN_RESERVED_SEATS]));
    }

    return totalReservedSeats;
  }

  Future<int> findAllSchedulingLuggagesByRide(String? rideId) async {
    QuerySnapshot<Map<String, dynamic>> result = await db
        .collection(DbData.TABLE_SCHEDULING)
        .where(DbData.COLUMN_RIDE_ID, isEqualTo: rideId)
        .get();

    final allData = result.docs.map((doc) => doc.data()).toList();
    int totalReservedLuggages = 0;
    for (var schedule in allData) {
      totalReservedLuggages += int.parse(
          Utils.getSafeNumber(schedule[DbData.COLUMN_RESERVED_LUGGAGES]));
    }

    return totalReservedLuggages;
  }
}
