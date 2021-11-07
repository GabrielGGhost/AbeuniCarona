import 'dart:async';

import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Entity/eEventBase.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventBase extends StatefulWidget {
  @override
  _EventBaseState createState() => _EventBaseState();
}

class _EventBaseState extends State<EventBase> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  double? radiusBorder = 16;
  final _controllerBaseEvents = StreamController<QuerySnapshot>.broadcast();

  Stream<QuerySnapshot>? _addListenerBorrowedVehicles() {
    final baseEvents = db.collection(DbData.TABLE_BASE_EVENT).snapshots();

    baseEvents.listen((data) {
      _controllerBaseEvents.add(data);
    });
  }

  @override
  void initState() {
    _addListenerBorrowedVehicles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eventos base"),
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
                                      List<DocumentSnapshot> baseEvents =
                                          query.docs.toList();

                                      DocumentSnapshot event =
                                          baseEvents[index];
                                      int size = query.docs.length;

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
                                                          event[DbData
                                                              .COLUMN_NAME],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          event[DbData
                                                              .COLUMN_OBS],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        ),
                                        confirmDismiss: (d) async {
                                          if (d ==
                                              DismissDirection.startToEnd) {
                                            Navigator.pushNamed(context,
                                                cRoutes.EVENT_BASE_REGISTER,
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
                                                      "Tem certeza que deseja cancelar este evento?"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                        onPressed: () {
                                                          delete(event.id);
                                                          Navigator.of(context)
                                                              .pop(true);
                                                        },
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
                                          "Não há eventos base cadastrados\nClique no + para registrar um",
                                          style: TextStyle(
                                            color: Colors.grey,
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
          Navigator.pushNamed(context, cRoutes.EVENT_BASE_REGISTER);
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void delete(String id) {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      db.collection(DbData.TABLE_BASE_EVENT).doc(id).delete();

      Utils.showToast("Deletado", Colors.green);
    } catch (e) {
      Utils.showToast("Falha ao deletar base de evento", Colors.redAccent);
    }
  }
}
