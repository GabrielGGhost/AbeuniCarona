import 'dart:async';

import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Entity/eEvent.dart';
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

  final _streamMyRides = StreamController<QuerySnapshot>.broadcast();

  String? _idLoggedUser;

  Future<Stream<QuerySnapshot<Object?>>?> _addListenerBorrowedVehicles() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;

    final MyRides = db
        .collection(DbData.TABLE_RIDE)
        .where(DbData.COLUMN_DRIVER_ID, isEqualTo: usuarioLogado!.uid)
        .snapshots();

    MyRides.listen((data) {
      _streamMyRides.add(data);
    });
  }

  @override
  void initState() {
    _addListenerBorrowedVehicles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: GestureDetector(
          child: StreamBuilder(
              stream: _streamMyRides.stream,
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
                    QuerySnapshot query = snapshot.data as QuerySnapshot;

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
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: query.docs.length,
                            itemBuilder: (_, index) {
                              List<DocumentSnapshot> rides =
                                  query.docs.toList();

                              DocumentSnapshot ride = rides[index];
                              bool edit =
                                  ride[DbData.COLUMN_DRIVER_ID] != null &&
                                      ride[DbData.COLUMN_DRIVER_ID] != "" &&
                                      ride[DbData.COLUMN_DRIVER_ID] ==
                                          _idLoggedUser;

                              return GestureDetector(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          FutureBuilder(
                                              future: getBaseEventNameFromEvent(
                                                  ride[
                                                      DbData.COLUMN_COD_EVENT]),
                                              builder: (_, snapshot) {
                                                if (snapshot.hasError) {
                                                  return Text(
                                                      "Erro ao carregar dados",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.grey));
                                                } else if (!snapshot.hasData) {
                                                  return Text(
                                                      "Evento Base Excluído");
                                                } else {
                                                  return Text(
                                                    snapshot.data.toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                              future: findEventByID(ride[
                                                  DbData.COLUMN_COD_EVENT]),
                                              builder: (_, snapshot) {
                                                if (snapshot.hasError) {
                                                  return Text(
                                                      "Erro ao carregar dados",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.grey));
                                                } else if (!snapshot.hasData) {
                                                  return Text(
                                                      "Evento Base Excluído");
                                                } else {
                                                  eEvent event =
                                                      snapshot.data as eEvent;
                                                  return Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                              child: RichText(
                                                            text: TextSpan(
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 14.0,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                    text:
                                                                        'Localização: '),
                                                                TextSpan(
                                                                    text: event
                                                                        .location,
                                                                    style: TextStyle(
                                                                        color:
                                                                            APP_SUB_TEXT)),
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
                                          Text("Data/Horário: "),
                                          Text(
                                            ride[DbData.COLUMN_DEPARTURE_DATE] +
                                                " - " +
                                                ride[DbData
                                                    .COLUMN_DEPARTURE_TIME],
                                            style:
                                                TextStyle(color: APP_SUB_TEXT),
                                          )
                                        ],
                                      ),
                                      ride[DbData.COLUMN_RETURN_DATE] != null &&
                                              ride[DbData.COLUMN_RETURN_DATE] !=
                                                  ""
                                          ? Text(
                                              ride[DbData.COLUMN_RETURN_DATE] +
                                                  " - " +
                                                  ride[DbData
                                                      .COLUMN_RETURN_TIME],
                                              style: TextStyle(
                                                  color: APP_SUB_TEXT),
                                            )
                                          : Text(
                                              "Sem Dados de Retorno Informados",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: APP_SUB_TEXT),
                                            ),
                                      Row(
                                        children: [
                                          Text("Motorista: "),
                                          FutureBuilder(
                                            future: getUserName(
                                                ride[DbData.COLUMN_DRIVER_ID]),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return Text(
                                                  ride[DbData
                                                      .COLUMN_DRIVER_NAME],
                                                  style: TextStyle(
                                                      color: APP_SUB_TEXT),
                                                );
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    snapshot.error.toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold));
                                              } else {
                                                return Text(
                                                    snapshot.data.toString(),
                                                    style: TextStyle(
                                                        color: Colors.grey));
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
                                                    DbData.COLUMN_QTT_SEATS];
                                                if (snapshot.hasError) {
                                                  return Text("Carregando...",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors
                                                              .redAccent));
                                                } else if (!snapshot.hasData) {
                                                  return Text("Carregando...",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors
                                                              .redAccent));
                                                } else {
                                                  int reservedSeats = int.parse(
                                                      snapshot.data.toString());
                                                  int currentSeats =
                                                      totalSeats -
                                                          reservedSeats;
                                                  if (currentSeats == 0) {
                                                    return Text(
                                                      "LOTADO",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.redAccent),
                                                    );
                                                  }
                                                  return Text(
                                                      (currentSeats.toString())
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.grey));
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
                                                int totalLuggages = ride[
                                                    DbData.COLUMN_QTT_LUGGAGES];
                                                if (snapshot.hasError) {
                                                  return Text("Carregando...",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors
                                                              .redAccent));
                                                } else if (!snapshot.hasData) {
                                                  return Text("Carregando...",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors
                                                              .redAccent));
                                                } else {
                                                  int reservedLuggages =
                                                      int.parse(snapshot.data
                                                          .toString());
                                                  int currentLuggages =
                                                      totalLuggages -
                                                          reservedLuggages;
                                                  if (currentLuggages == 0) {
                                                    return Text(
                                                      "LOTADO",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.redAccent),
                                                    );
                                                  }
                                                  return Text(
                                                      (currentLuggages
                                                              .toString())
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.grey));
                                                }
                                              })
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("Registrado há : " +
                                              Utils.getDateTimeUntilNow(ride[
                                                  DbData
                                                      .COLUMN_REGISTRATION_DATE]))
                                        ],
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                ),
                                onTap: () async {
                                  await Navigator.pushNamed(
                                      context, cRoutes.PARTAKER,
                                      arguments: ride);
                                },
                              );
                            });
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
          onTap: () {
            Navigator.pushNamed(context, cRoutes.PARTAKER);
          },
        ));
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
