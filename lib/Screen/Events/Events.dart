import 'dart:async';

import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'package:abeuni_carona/Entity/eEvent.dart';
import 'package:abeuni_carona/Entity/eEventBase.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Events extends StatefulWidget {
  const Events({Key? key}) : super(key: key);

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  final _controllerBaseEvents = StreamController<QuerySnapshot>.broadcast();

  Stream<QuerySnapshot>? _addListenerBorrowedVehicles() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final events = db.collection(DbData.TABLE_EVENT).snapshots();

    events.listen((data) {
      _controllerBaseEvents.add(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.eventos),
          backgroundColor: APP_BAR_BACKGROUND_COLOR,
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(cStyles.PADDING_DEFAULT_SCREEN),
                child: Column(
                  children: [
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection(DbData.TABLE_EVENT)
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
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: query.docs.length,
                                    itemBuilder: (context, index) {
                                      List<DocumentSnapshot> events =
                                          query.docs.toList();

                                      DocumentSnapshot event = events[index];

                                      String codBaseEvent = event[DbData.COLUMN_COD_BASE_EVENT];

                                      return FutureBuilder<Map>(
                                          future: _findEventByPk(codBaseEvent),
                                          builder: (_, snap){


                                            return Dismissible(
                                              child: Padding(
                                                padding: EdgeInsets.only(bottom: 15),
                                                child: Card(
                                                  child: Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: 15,
                                                          horizontal: 10),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                snap.data![DbData.COLUMN_NAME],
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                    fontSize: 18),
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                top: 5),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "Local: ",
                                                                  style: TextStyle(
                                                                      fontSize: 12),
                                                                ),
                                                                Text(" - "),
                                                                Text(
                                                                  event[DbData
                                                                      .COLUMN_LOCATION],
                                                                  style: TextStyle(
                                                                      color:
                                                                      Colors.grey,
                                                                      fontSize: 11),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Spacer(),
                                                              Text(
                                                                event[DbData
                                                                    .COLUMN_START_DATE],
                                                                style: TextStyle(
                                                                    color:
                                                                    Colors.grey,
                                                                    fontSize: 11),
                                                              ),
                                                              Text(" - "),
                                                              Text(
                                                                event[DbData
                                                                    .COLUMN_END_DATE],
                                                                style: TextStyle(
                                                                    color:
                                                                    Colors.grey,
                                                                    fontSize: 11),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      )),
                                                ),
                                              ),
                                              confirmDismiss: (d) async {
                                                if (d ==
                                                    DismissDirection.startToEnd) {
                                                  Navigator.pushNamed(
                                                      context, cRoutes.EVENT_REGISTER,
                                                      arguments: event);
                                                  return false;
                                                } else {
                                                  return await showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            "Confirmar exclusão"),
                                                        content: Text(
                                                            "Tem certeza que deseja cancelar este carro?"),
                                                        actions: <Widget>[
                                                          TextButton(
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                      context)
                                                                      .pop(true),
                                                              child: Text(
                                                                  "Tenho certeza")),
                                                          TextButton(
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                      context)
                                                                      .pop(false),
                                                              child: Padding(
                                                                padding:
                                                                EdgeInsets.all(5),
                                                                child: Text(
                                                                  "Cancelar",
                                                                  style: TextStyle(
                                                                    color:
                                                                    Colors.black,
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
                                                color: Colors.green,
                                                child: Icon(Icons.edit),
                                                alignment: Alignment.centerLeft,
                                                padding: EdgeInsets.only(left: 15),
                                                margin: EdgeInsets.only(bottom: 20),
                                              ),
                                              secondaryBackground: Container(
                                                color: Colors.redAccent,
                                                child: Icon(Icons.delete),
                                                alignment: Alignment.centerRight,
                                                padding: EdgeInsets.only(right: 15),
                                                margin: EdgeInsets.only(bottom: 20),
                                              ),
                                            );
                                          }
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
                                        AppLocalizations.of(context)!
                                            .naoHaEventosBaseCadastradosCliqueNoMaisParaRegistrarUm,
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
                        }),
                  ],
                ))),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: FloatingActionButton(
                            onPressed: () {},
                            backgroundColor: Colors.blueAccent,
                            child: Icon(
                              Icons.filter_alt_sharp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, cRoutes.EVENT_REGISTER);
                          },
                          child: Icon(Icons.add),
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ))
          ],
        ));
  }

  Future<Map> _findEventByPk(String? codBaseEvent) async {

    return await FirebaseFirestore.instance.collection(DbData.TABLE_BASE_EVENT) as Future<Map>;

  }
}
