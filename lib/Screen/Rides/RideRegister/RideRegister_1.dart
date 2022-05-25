import 'dart:async';

import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:abeuni_carona/Entity/eEvent.dart';
import 'package:abeuni_carona/Entity/eEventBase.dart';
import 'package:abeuni_carona/Entity/eRide.dart';
import 'package:abeuni_carona/Screen/Events/Events/EventRegister.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:abeuni_carona/Constants/cDate.dart';

class RideRegister_1 extends StatefulWidget {
  eRide? ride;
  bool edit;

  RideRegister_1(this.ride, this.edit);

  @override
  _RideRegister_1State createState() => _RideRegister_1State();
}

FirebaseFirestore db = FirebaseFirestore.instance;

class _RideRegister_1State extends State<RideRegister_1> {
  final _controllerActiveEvents = StreamController<QuerySnapshot>.broadcast();
  List<eEventBase> baseEventsList = [];

  final baseEvents = db.collection(DbData.TABLE_BASE_EVENT).get();

  Future<Stream<QuerySnapshot<Object?>>?> _addListenerActiveEvents() async {
    final activeEvents = db
        .collection(DbData.TABLE_EVENT)
        .where(DbData.COLUMN_ACTIVE, isEqualTo: true)
        .snapshots();

    activeEvents.listen((data) {
      _controllerActiveEvents.add(data);
    });
  }

  eRide? editRide;
  bool edit = false;

  @override
  void initState() {
    _addListenerActiveEvents();
    super.initState();
    //_getUserLoggedData();
  }

  @override
  Widget build(BuildContext context) {
    editRide = widget.ride;
    edit = widget.edit;

    return Scaffold(
        appBar: AppBar(
          title: Text("Cadastro de evento"),
          backgroundColor: APP_BAR_BACKGROUND_COLOR,
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(cStyles.PADDING_DEFAULT_SCREEN),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Escolha o evento que será realizado",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection(DbData.TABLE_EVENT)
                                .where(DbData.COLUMN_DONE, isEqualTo: true)
                                .snapshots(),
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
                                  }
                                  if (query.docs.length > 0) {
                                    return ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: query.docs.length,
                                        itemBuilder: (context, index) {
                                          List<DocumentSnapshot> events =
                                              query.docs.toList();

                                          DocumentSnapshot event =
                                              events[index];

                                          return GestureDetector(
                                            child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 15,
                                                    horizontal: 10),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        FutureBuilder(
                                                            future: getBaseEventName(
                                                                event[DbData
                                                                    .COLUMN_COD_BASE_EVENT]),
                                                            builder:
                                                                (_, snapshot) {
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
                                                                              .bold,
                                                                      fontSize:
                                                                          18),
                                                                );
                                                              }
                                                            }),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 5),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                              child: Text.rich(TextSpan(
                                                                  text:
                                                                      "Local: ",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  children: [
                                                                TextSpan(
                                                                  text: event[DbData
                                                                      .COLUMN_LOCATION],
                                                                  style: TextStyle(
                                                                      color:
                                                                          APP_SUB_TEXT,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                )
                                                              ])))
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Spacer(),
                                                        Text(
                                                          Utils.getStringDateFromTimestamp(
                                                              event[DbData
                                                                  .COLUMN_START_DATE],
                                                              cDate
                                                                  .FORMAT_SLASH_DD_MM_YYYY)!,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 11),
                                                        ),
                                                        Text(" - "),
                                                        Text(
                                                          Utils.getStringDateFromTimestamp(
                                                              event[DbData
                                                                  .COLUMN_END_DATE],
                                                              cDate
                                                                  .FORMAT_SLASH_DD_MM_YYYY)!,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 11),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider()
                                                  ],
                                                )),
                                            onTap: () {
                                              nextStep(event);
                                            },
                                          );
                                        });
                                  } else {
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Não Há eventos ativos cadastrados para realizar uma carona.",
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
                            }))
                  ],
                ))));
  }

  void nextStep(DocumentSnapshot event) {
    eRide ride = eRide();

    if (edit) {
      editRide!.codEvent = event.id;
      Navigator.pop(context, editRide);
    } else {
      ride.codEvent = event.id;
      Navigator.pushNamed(context, cRoutes.REGISTER_RIDE2, arguments: ride);
    }
  }

  Future<String?> getBaseEventName(codBaseEvent) async {
    DocumentSnapshot result =
        await db.collection(DbData.TABLE_BASE_EVENT).doc(codBaseEvent).get();

    final data = result.data() as Map;

    return data[DbData.COLUMN_NAME];
  }
}
