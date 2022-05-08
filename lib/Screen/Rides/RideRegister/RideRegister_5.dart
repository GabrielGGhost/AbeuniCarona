import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'package:abeuni_carona/Constants/cSituation.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:abeuni_carona/Entity/eRide.dart';
import 'package:abeuni_carona/Entity/eSchedulingHistory.dart';
import 'package:abeuni_carona/Entity/eUser.dart';
import 'package:abeuni_carona/Screen/Rides/Ride/Rides.dart';
import 'package:abeuni_carona/Screen/Rides/RideRegister/RideRegister_2.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'RideRegister_4.dart';

class RideRegister_5 extends StatefulWidget {
  eRide ride;
  bool edit;
  RideRegister_5(this.ride, this.edit);

  @override
  _RideRegister_5State createState() => _RideRegister_5State();
}

class _RideRegister_5State extends State<RideRegister_5> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  String? _idLoggedUser;
  eUser? user = eUser.empty();
  eRide ride = eRide();
  bool edit = false;
  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ride = widget.ride;
    edit = widget.edit;
    return Scaffold(
      appBar: AppBar(
        title: Text("Resumo da Carona"),
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(cStyles.PADDING_DEFAULT_SCREEN),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "Confira os dados informadas, para corrigir alguma, clique no card para ser redirecionado à tela!",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Column(
                  children: [
                    Card(
                      child: Column(
                        children: [
                          Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Evento",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        )
                                      ]),
                                  Row(children: [
                                    Text("Tipo: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                    Text(ride.event.descBaseEvent,
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 15)),
                                  ]),
                                  Row(children: [
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          // Note: Styles for TextSpans must be explicitly defined.
                                          // Child text spans will inherit styles from parent
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Localização: ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: ride.event.location,
                                                style: TextStyle(
                                                    color: APP_SUB_TEXT)),
                                          ],
                                        ),
                                      ),
                                    )
                                  ]),
                                  Row(children: [
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(text: 'Obs.: '),
                                            TextSpan(
                                                text: ride.event.obsEvent,
                                                style: TextStyle(
                                                    color: APP_SUB_TEXT)),
                                          ],
                                        ),
                                      ),
                                    )
                                  ]),
                                  Row(children: [
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          // Note: Styles for TextSpans must be explicitly defined.
                                          // Child text spans will inherit styles from parent
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text:
                                                    ride.event.dateEventStart +
                                                        " - " +
                                                        ride.event.dateEventEnd,
                                                style: TextStyle(
                                                    color: APP_SUB_TEXT)),
                                          ],
                                        ),
                                      ),
                                    )
                                  ]),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        child: Text(
                                          "Alterar",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                        onTap: () => {_updateEventBase()},
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Divider(),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Veículo",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )
                              ]),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(children: [
                                  Text("Placa: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  Text(ride.vehicle.sign,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                  Spacer(),
                                  Text("Modelo: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  Text(ride.vehicle.model,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                ]),
                                Row(children: [
                                  Text("Cor: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  Text(ride.vehicle.color,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                  Spacer(),
                                ]),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      child: Text(
                                        "Alterar",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                      onTap: () => {_updateVehicle()},
                                    ),
                                  ],
                                ),
                                Divider(),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Espaços",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      )
                                    ]),
                                Row(children: [
                                  Text("Assentos: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  Text(ride.vehicle.seats,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                  Spacer(),
                                  Row(children: [
                                    Text("Bagagens: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                    Text(ride.vehicle.luggageSpaces,
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 15)),
                                  ]),
                                ]),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      child: Text(
                                        "Alterar",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                      onTap: () => {_updateVehicleNumbers()},
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Carona",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )
                              ]),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Row(children: [
                                    Text("Endereço de partida",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                  ]),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Column(
                                    children: [
                                      Row(children: [
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              // Note: Styles for TextSpans must be explicitly defined.
                                              // Child text spans will inherit styles from parent
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        'Local de partida: : ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(
                                                    text: ride.departureAddress,
                                                    style: TextStyle(
                                                        color: APP_SUB_TEXT)),
                                              ],
                                            ),
                                          ),
                                        )
                                      ]),
                                      Row(children: [
                                        Text("Data/Horário: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                        Text(
                                            ride.departureDate +
                                                " - " +
                                                ride.departureTime,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15)),
                                      ])
                                    ],
                                  ),
                                ),
                                ride.returnAddress.length > 0
                                    ? Column(children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Row(children: [
                                            Text("Endereço de retorno",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15)),
                                          ]),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Column(
                                            children: [
                                              Row(children: [
                                                Text("Local de retorno: ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15)),
                                                Text(ride.returnAddress,
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 15)),
                                              ]),
                                              Row(children: [
                                                Text("Data/Horário: ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15)),
                                                Text(
                                                    ride.returnDate +
                                                        " - " +
                                                        ride.returnTime,
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 15)),
                                              ])
                                            ],
                                          ),
                                        )
                                      ])
                                    : Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(
                                          "Sem dados de retorno informados",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold),
                                        )),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      child: Text(
                                        "Alterar",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                      onTap: () => {_updateEvent()},
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: ElevatedButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        padding:
                                            EdgeInsets.fromLTRB(28, 16, 28, 16),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30))),
                                    child: Text(
                                      "Registrar Carona",
                                      style: (TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                    ),
                                    onPressed: () {
                                      save(ride);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: ElevatedButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: APP_ERROR_BACKGROUND,
                                        padding:
                                            EdgeInsets.fromLTRB(28, 16, 28, 16),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30))),
                                    child: Text(
                                      "Cancelar Carona",
                                      style: (TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                    ),
                                    onPressed: () {
                                      print("CLICADO CANCELAR");
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                  AppLocalizations.of(context)!
                                                      .confirmarExclusao),
                                              content: Text(
                                                  "Tem certeza que deseja excluir esta carona?"),
                                              actions: <Widget>[
                                                TextButton(
                                                    onPressed: () {
                                                      finishRide();
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
                                                          color: APP_MAIN_TEXT,
                                                        ),
                                                      ),
                                                    )),
                                              ],
                                            );
                                          });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void save(eRide ride) {
    ride.driverId = _idLoggedUser!;
    ride.driverName = user!.nickName + " [ " + user!.userName + "]";

    if (edit) {
      update(ride);
      Navigator.pop(context);
    } else {
      ride.registerDate = Utils.getDateTimeNow()!;
      insert(ride);
      Utils.showToast("Cadastrado com sucesso!", APP_SUCCESS_BACKGROUND);
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 5);
    }
  }

  void insert(eRide ride) {
    db.collection(DbData.TABLE_RIDE).add(ride.toMap());
  }

  void _getUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;

    if (usuarioLogado != null) {
      _idLoggedUser = usuarioLogado.uid;

      DocumentSnapshot<Map<String, dynamic>> docUser =
          await db.collection(DbData.TABLE_USER).doc(_idLoggedUser).get();

      user!.docToUser(docUser);
    }
  }

  _updateEventBase() async {
    eRide result = await Navigator.pushNamed(context, cRoutes.REGISTER_RIDE1,
        arguments: {'ride': ride, 'edit': true}) as eRide;

    setState(() {
      ride = result;
    });
  }

  _updateVehicle() async {
    eRide result = await Navigator.pushNamed(context, cRoutes.REGISTER_RIDE2,
        arguments: {'ride': ride, 'edit': true}) as eRide;

    setState(() {
      ride = result;
    });
  }

  _updateVehicleNumbers() async {
    eRide result = await Navigator.pushNamed(context, cRoutes.REGISTER_RIDE3,
        arguments: {'ride': ride, 'edit': true}) as eRide;

    setState(() {
      ride = result;
    });
  }

  _updateEvent() async {
    eRide result = await Navigator.pushNamed(context, cRoutes.REGISTER_RIDE4,
        arguments: {'ride': ride, 'edit': true}) as eRide;

    setState(() {
      ride = result;
    });
  }

  update(eRide ride) {
    db.collection(DbData.TABLE_RIDE).doc(ride.uid).update(ride.toMap());
  }

  void finishRide() {
    updateScheduleHistory();
  }

  void updateScheduleHistory() async {
    QuerySnapshot<Map<String, dynamic>> result = await db
        .collection(DbData.TABLE_SCHEDULING_HISTORY)
        .where(DbData.COLUMN_RIDE_ID, isEqualTo: ride.uid)
        .get();

    final docs = result.docs;
    print("CANCELANDO " + docs.length.toString() + " agendamentos");
    for (var doc in docs) {
      db
          .collection(DbData.TABLE_SCHEDULING_HISTORY)
          .doc(doc.id)
          .update({DbData.COLUMN_SITUATION: cSituation.RIDE_CANCELLED});
    }
  }
}
