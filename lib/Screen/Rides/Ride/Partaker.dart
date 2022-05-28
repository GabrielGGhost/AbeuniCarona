import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Constants/cSituation.dart';
import 'package:abeuni_carona/Entity/eRide.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:abeuni_carona/Constants/cDate.dart';

class Partaker extends StatefulWidget {
  DocumentSnapshot ride;
  Partaker(this.ride);

  @override
  _partakerState createState() => _partakerState();
}

class _partakerState extends State<Partaker> {
  eRide? ride = eRide();

  @override
  Widget build(BuildContext context) {
    ride!.docToRide(widget.ride);
    String? lblButton = getLblButton();

    return Scaffold(
      appBar: AppBar(
        title: Text("Participantes"),
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: Text(
                          lblButton!,
                          style: (TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                        onPressed: () {
                          nextRideStep();
                        },
                      ),
                    ],
                  ),
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection(DbData.TABLE_SCHEDULING)
                        .where(DbData.COLUMN_RIDE_ID, isEqualTo: ride!.uid)
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
                            if (query.docs.length == 0) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Não há participantes para esta carona",
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

                            return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: query.docs.length,
                                itemBuilder: (_, index) {
                                  List<DocumentSnapshot> schedules = query.docs;

                                  DocumentSnapshot schedule = schedules[index];

                                  return Dismissible(
                                      key: Key(ride!.uid),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Participante: ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              FutureBuilder(
                                                future: getUserName(schedule[
                                                    DbData.COLUMN_PARTAKER_ID]),
                                                builder: (context, snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return Text(
                                                        "Falha ao buscar participante.",
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
                                                            color:
                                                                Colors.grey));
                                                  }
                                                },
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text("Vagas: ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(schedule[DbData
                                                  .COLUMN_RESERVED_SEATS]),
                                              Spacer(),
                                              Text("Bagagens: ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(schedule[DbData
                                                  .COLUMN_RESERVED_LUGGAGES]),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Registrado há: ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(Utils.getFormattedStringFromTimestamp(
                                                  schedule[DbData
                                                      .COLUMN_REGISTRATION_DATE],
                                                  cDate
                                                      .FORMAT_SLASH_DD_MM_YYYY)!)
                                            ],
                                          ),
                                          Divider()
                                        ],
                                      ),
                                      background: Container(),
                                      secondaryBackground: Container(
                                        color: APP_REMOVE_DISMISS,
                                        child: Icon(Icons.delete),
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.only(right: 15),
                                        margin: EdgeInsets.only(bottom: 20),
                                      ),
                                      confirmDismiss: (d) async {
                                        if (d == DismissDirection.startToEnd) {
                                          return false;
                                        } else {
                                          return await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(AppLocalizations.of(
                                                        context)!
                                                    .confirmarExclusao),
                                                content: Text(
                                                    "Tem certeza que deseja excluir este participante?"),
                                                actions: <Widget>[
                                                  TextButton(
                                                      onPressed: () {
                                                        delete(schedule.id);
                                                        Navigator.of(context)
                                                            .pop(true);
                                                      },
                                                      child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .tenhoCerteza)),
                                                  TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
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
                                      });
                                });
                          }
                      }
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ride!.situation == 1
                        ? ElevatedButton(
                      style: TextButton.styleFrom(
                          backgroundColor: APP_ERROR_BACKGROUND,
                          padding: EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: Text(
                        "Cancelar ",
                        style: (TextStyle(
                            color: Colors.white, fontSize: 20)),
                      ),
                      onPressed: () {
                        cancel();
                      },
                    )
                        : Container(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> getUserName(String partakerId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final result = await db.collection(DbData.TABLE_USER).doc(partakerId).get();
    return result[DbData.COLUMN_USERNAME];
  }

  void delete(String id) {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      db.collection(DbData.TABLE_SCHEDULING).doc(id).delete();

      Utils.showToast(
          AppLocalizations.of(context)!.deletado, APP_SUCCESS_BACKGROUND);
    } catch (e) {
      Utils.showToast("Falha ao deletar agendamento!", APP_ERROR_BACKGROUND);
    }
  }

  void nextRideStep() {
    ride!.situation++;
    updateRide(ride);
    String? message = getMessageFromSituation(ride!.situation);
    Utils.showToast(message!, APP_SUCCESS_BACKGROUND);
    Navigator.pop(context);
  }

  String? getLblButton() {
    int situation = ride!.situation;
    if (situation == 0) return cSituation.RIDE_CANCELLED_DESC;

    switch (situation) {
      case 1:
        return "Iniciar Carona";
      case 2:
        return "Finalizar chegada";
      case 3:
        return "Iniciar Retorno";
      case 4:
        return "Finalizar carona";
      case 5:
        return "Finalizado";
    }
  }

  void updateRide(eRide? ride) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection(DbData.TABLE_RIDE).doc(ride!.uid).update({DbData.COLUMN_SITUATION: ride.situation});
  }

  String? getMessageFromSituation(int situation) {
    int situation = ride!.situation;
    if (situation == 0) return cSituation.RIDE_CANCELLED_DESC;

    switch (situation) {
      case 2:
        return "Carona Iniciada";
      case 3:
        return "Chegado ao Destino";
      case 4:
        return "Retornando";
      case 5:
        return "Carona finalizada";
    }
  }

  void cancel() {

    ride!.situation = cSituation.RIDE_CANCELLED;
    cancelRide(ride);
    Utils.showToast("Carona cancelada", APP_SUCCESS_BACKGROUND);
    Navigator.pop(context);
  }

  void cancelRide(eRide? ride) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection(DbData.TABLE_RIDE).doc(ride!.uid).update({DbData.COLUMN_SITUATION: ride.situation});
  }


}
