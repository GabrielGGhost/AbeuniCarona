import 'dart:async';

import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Constants/cDate.dart';
import 'package:abeuni_carona/Entity/eRide.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  final _streamHistories = StreamController<QuerySnapshot>.broadcast();

  Stream<QuerySnapshot>? _addListenerHistories() {
    final baseEvents = db
        .collection(DbData.TABLE_SCHEDULING_HISTORY)
        .orderBy(DbData.COLUMN_REGISTRATION_DATE, descending: true)
        .snapshots();

    baseEvents.listen((data) {
      _streamHistories.add(data);
    });
  }

  @override
  void initState() {
    _addListenerHistories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Histórico de Viagens"),
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: _streamHistories.stream,
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
                        children: [Text("Erro ao carregar dados")],
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
                            List<DocumentSnapshot> hists = query.docs.toList();

                            DocumentSnapshot hist = hists[index];

                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 25),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Data do agendamento: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(Utils.getStringDateFromTimestamp(
                                          hist[DbData.COLUMN_REGISTRATION_DATE],
                                          cDate.FORMAT_SLASH_DD_MM_YYYY)!)
                                    ],
                                  ),
                                  Row(children: [
                                    Expanded(
                                        child:FutureBuilder(
                                            future: _findRideById(
                                                hist[DbData.COLUMN_RIDE_ID]),
                                            builder: (_, snapshot) {
                                              if (!snapshot.hasData) {
                                                return Text(
                                                    "Falha ao buscar carona",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color:
                                                        APP_ERROR_BACKGROUND));
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    snapshot.error.toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold));
                                              } else {
                                                eRide ride = snapshot.data as eRide;

                                                return Column(
                                                  children: [
                                                    Row(children: [
                                                      Text("Motorista: ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight.bold)),
                                                      FutureBuilder(
                                                        future: getUsername(
                                                            ride.driverId),
                                                        builder:
                                                            (context, snapshot) {
                                                          if (!snapshot.hasData) {
                                                            return Text(
                                                                "Falha ao buscar motorista",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold));
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
                                                    ]),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text.rich(TextSpan(
                                                              text: "Localização: ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                              children: [
                                                                TextSpan(
                                                                    text: ride.event
                                                                        .location,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .grey))
                                                              ])),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Evento: ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight.bold),
                                                        ),
                                                        FutureBuilder(
                                                            future: getBaseEventName(
                                                            ride.event.codBaseEvent),
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
                                                                    "Evento Excluído");
                                                              } else {
                                                                return Text(
                                                                  snapshot.data
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .bold,),
                                                                );
                                                              }
                                                            }),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Status: ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight.bold),
                                                        ),
                                                        Text(
                                                            "Em andamento",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight.bold,
                                                                color: Colors.grey))
                                                      ],
                                                    ),
                                                    Divider()
                                                  ],
                                                );
                                              }
                                            })
                                    )
                                    ,
                                    Divider()
                                  ]),
                                ],
                              ),
                            );
                          });
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Nenhuma carona foi relazida por este usuário.",
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
      ),
    );
  }

  Future<eRide> _findRideById(rideId) async {
    DocumentSnapshot<Map<String, dynamic>> result =
        await db.collection(DbData.TABLE_RIDE).doc(rideId).get();

    eRide ride = eRide();
    ride.docToRide(result);

    return ride;
  }

  Future<String> getUsername(String driverId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final result = await db.collection(DbData.TABLE_USER).doc(driverId).get();
    return result[DbData.COLUMN_USERNAME] +
        " [ " +
        result[DbData.COLUMN_NICKNAME] +
        " ] ";
  }

  Future<String?> getBaseEventName(codBaseEvent) async {
    DocumentSnapshot result =
    await db.collection(DbData.TABLE_BASE_EVENT).doc(codBaseEvent).get();

    final data = result.data() as Map;

    return data[DbData.COLUMN_NAME];
  }
}
