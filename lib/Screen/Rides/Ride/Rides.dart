import 'dart:async';

import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Constants/cPermission.dart';
import 'package:abeuni_carona/Entity/eEvent.dart';
import 'package:abeuni_carona/Entity/eEventBase.dart';
import 'package:abeuni_carona/Entity/eRide.dart';
import 'package:abeuni_carona/Entity/eVehicle.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:abeuni_carona/Constants/cDate.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Rides extends StatefulWidget {
  List<String> permissions = [];
  Rides(this.permissions);

  @override
  _RidesState createState() => _RidesState();
}

class _RidesState extends State<Rides> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  double? radiusBorder = 16;
  final _controllerBaseEvents = StreamController<QuerySnapshot>.broadcast();

  String? _idLoggedUser;
  List<String> permissions = [];

  Stream<QuerySnapshot>? _addListenerRides() {
    final baseEvents = db
        .collection(DbData.TABLE_RIDE)
        .orderBy(DbData.COLUMN_REGISTRATION_DATE, descending: true)
        .snapshots();

    baseEvents.listen((data) {
      _controllerBaseEvents.add(data);
    });
  }

  @override
  void initState() {
    _addListenerRides();
    _getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    permissions = widget.permissions;
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
                                                    FutureBuilder(
                                                        future: getBaseEventNameFromEvent(
                                                            ride[DbData
                                                                .COLUMN_COD_EVENT]),
                                                        builder: (_, snapshot) {
                                                          if (snapshot
                                                              .hasError) {
                                                            return Text(
                                                                "Erro ao carregar dados",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .grey));
                                                          } else if (!snapshot
                                                              .hasData) {
                                                            return Text(
                                                                "Evento Base Exclu??do");
                                                          } else {
                                                            return Text(
                                                              snapshot.data
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 18),
                                                            );
                                                          }
                                                        }),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: FutureBuilder(
                                                        future: findEventByID(
                                                            ride[DbData
                                                                .COLUMN_COD_EVENT]),
                                                        builder: (_, snapshot) {
                                                          if (snapshot
                                                              .hasError) {
                                                            return Text(
                                                                "Erro ao carregar dados",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .grey));
                                                          } else if (!snapshot
                                                              .hasData) {
                                                            return Text(
                                                                "Evento Base Exclu??do");
                                                          } else {
                                                            eEvent event =
                                                                snapshot.data
                                                                    as eEvent;
                                                            return Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child:
                                                                            RichText(
                                                                      text:
                                                                          TextSpan(
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              14.0,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                        children: <
                                                                            TextSpan>[
                                                                          TextSpan(
                                                                              text: 'Localiza????o: '),
                                                                          TextSpan(
                                                                              text: event.location,
                                                                              style: TextStyle(color: APP_SUB_TEXT)),
                                                                        ],
                                                                      ),
                                                                    ))
                                                                  ],
                                                                )
                                                              ],
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text("Data/Hor??rio: "),
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
                                                    FutureBuilder(
                                                      future: getUserName(ride[
                                                          DbData
                                                              .COLUMN_DRIVER_ID]),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (!snapshot.hasData) {
                                                          return Text(
                                                            ride[DbData
                                                                .COLUMN_DRIVER_NAME],
                                                            style: TextStyle(
                                                                color:
                                                                    APP_SUB_TEXT),
                                                          );
                                                        } else if (snapshot
                                                            .hasError) {
                                                          return Text(
                                                              snapshot.error
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold));
                                                        } else {
                                                          return Text(
                                                              snapshot.data
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey));
                                                        }
                                                      },
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
                                                          int totalSeats = ride[
                                                              DbData
                                                                  .COLUMN_QTT_SEATS];
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
                                                              ride[DbData
                                                                  .COLUMN_QTT_LUGGAGES];
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
                                                                  'Situa????o: ',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          TextSpan(
                                                              text: Utils
                                                                  .getSituation(
                                                                      ride[DbData
                                                                          .COLUMN_SITUATION]),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      APP_SUB_TEXT)),
                                                        ],
                                                      ),
                                                    ))
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text("Registrado: " +
                                                        Utils.getFormattedStringFromTimestamp(
                                                            ride[DbData
                                                                .COLUMN_REGISTRATION_DATE],
                                                            cDate
                                                                .FORMAT_SLASH_DD_MM_YYYY)!)
                                                  ],
                                                ),
                                                Divider(),
                                              ],
                                            ),
                                          ),
                                          onTap: () async {
                                            if (edit &&
                                                (ride[DbData.COLUMN_SITUATION] ==
                                                        1 ||
                                                    ride[DbData
                                                            .COLUMN_SITUATION] ==
                                                        3)) {
                                              await Navigator.pushNamed(
                                                  context, cRoutes.PARTAKER,
                                                  arguments: ride);
                                            } else if (!edit &&
                                                (ride[DbData.COLUMN_SITUATION] ==
                                                        1 ||
                                                    ride[DbData
                                                            .COLUMN_SITUATION] ==
                                                        3)) {
                                              await Navigator.pushNamed(
                                                  context, cRoutes.SCHEDULING,
                                                  arguments: ride);
                                            }

                                            _addListenerRides();
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
                                            return null;
                                          }
                                        },
                                        key: Key(ride.id),
                                        background: edit
                                            ? (ride[DbData.COLUMN_SITUATION] ==
                                                        1 ||
                                                    ride[DbData
                                                            .COLUMN_SITUATION] ==
                                                        3)
                                                ? Container(
                                                    color: APP_EDIT_DISMISS,
                                                    child: Icon(Icons.edit),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    padding: EdgeInsets.only(
                                                        left: 15),
                                                    margin: EdgeInsets.only(
                                                        bottom: 20),
                                                  )
                                                : Container()
                                            : (ride[DbData.COLUMN_SITUATION] ==
                                                        1 ||
                                                    ride[DbData
                                                            .COLUMN_SITUATION] ==
                                                        3)
                                                ? Container(
                                                    color: Colors.blueAccent,
                                                    child: Icon(Icons.timer),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    padding: EdgeInsets.only(
                                                        left: 15),
                                                    margin: EdgeInsets.only(
                                                        bottom: 20),
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
                                        "N??o h?? caronas dispon??veis",
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
      floatingActionButton: Utils.checkPermission(cPermission.REGISTER_RIDE, permissions) ? FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, cRoutes.REGISTER_RIDE1);
        },
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
        child: Icon(
          Icons.add,
          color: APP_WHITE_FONT,
        ),
      ) : Container(),
    );
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

  Future<String?> getBaseEventName(codBaseEvent) async {
    DocumentSnapshot result =
        await db.collection(DbData.TABLE_BASE_EVENT).doc(codBaseEvent).get();

    final data = result.data() as Map;

    return data[DbData.COLUMN_NAME];
  }

  Future<String?> getBaseEventNameFromEvent(codEvent) async {
    DocumentSnapshot result =
        await db.collection(DbData.TABLE_EVENT).doc(codEvent).get();

    eEvent event = eEvent.doc(result);

    DocumentSnapshot result2 = await db
        .collection(DbData.TABLE_BASE_EVENT)
        .doc(event.codBaseEvent)
        .get();

    return result2[DbData.COLUMN_NAME];
  }

  Future<String> getUserName(String driverId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final result = await db.collection(DbData.TABLE_USER).doc(driverId).get();
    return result[DbData.COLUMN_USERNAME] +
        " [ " +
        result[DbData.COLUMN_NICKNAME] +
        " ]";
  }

  findEventByID(codEvent) async {
    DocumentSnapshot result =
        await db.collection(DbData.TABLE_EVENT).doc(codEvent).get();

    eEvent event = eEvent.doc(result);

    return event;
  }
}
