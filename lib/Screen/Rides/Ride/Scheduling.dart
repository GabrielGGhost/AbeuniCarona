import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Entity/eRide.dart';
import 'package:abeuni_carona/Entity/eScheduling.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class Scheduling extends StatefulWidget {
  DocumentSnapshot ride;
  Scheduling(this.ride);

  @override
  _SchedulingState createState() => _SchedulingState();
}

class _SchedulingState extends State<Scheduling> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  eRide ride = eRide();
  String? _seatsReserved = "0";
  String? _lugaggeReserved = "0";
  int totalAvaliableSeats = 0;
  int totalAvaliableLuggages = 0;

  TextEditingController _controllerSeats = TextEditingController();
  TextEditingController _controllerLuggages = TextEditingController();

  FocusNode? _focusSeats;
  FocusNode? _focusLuggages;

  @override
  void initState() {
    _focusSeats = FocusNode();
    _focusLuggages = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusSeats!.dispose();
    _focusLuggages!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ride.docToRide(widget.ride);
    totalAvaliableSeats = int.parse(ride.vehicle.seats);
    totalAvaliableLuggages = int.parse(ride.vehicle.luggageSpaces);

    return Scaffold(
      appBar: AppBar(
        title: Text("Agendamento"),
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Detalhes do Evento ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text.rich(TextSpan(
                          text: "Local: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                        TextSpan(
                            text: ride.event.location,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey))
                      ])))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text.rich(TextSpan(
                          text: "Data: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                        TextSpan(
                            text: ride.event.dateEventStart +
                                " - " +
                                ride.event.dateEventEnd,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey))
                      ])))
                ],
              ),
              ride.event.location != ""
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Text.rich(TextSpan(
                                text: "Obs: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                              TextSpan(
                                  text: ride.event.obsEvent,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey))
                            ])))
                      ],
                    )
                  : Container(),
              Divider(),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "Detalhes da Carona",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Text(
                        "Motorista: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      FutureBuilder(
                        future: getDriverName(ride.driverId),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Text("Falha ao buscar motorista",
                                style: TextStyle(fontWeight: FontWeight.bold));
                          } else if (snapshot.hasError) {
                            return Text(snapshot.error.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold));
                          } else {
                            return Text(snapshot.data.toString(),
                                style: TextStyle(color: Colors.grey));
                          }
                        },
                      )
                    ],
                  ))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text.rich(TextSpan(
                          text: "Partida: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                        TextSpan(
                            text: ride.departureAddress,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey))
                      ])))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text.rich(TextSpan(
                          text: "Data: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                        TextSpan(
                            text:
                                ride.departureDate + " - " + ride.departureTime,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey))
                      ])))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text.rich(TextSpan(
                          text: "Registrado: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                        TextSpan(
                            text: Utils.getDateTimeUntilNow(ride.registerDate),
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey))
                      ])))
                ],
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "Detalhes do Veículo",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  Text("Modelo: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(ride.vehicle.model,
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
              Row(
                children: [
                  Text("Cor: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(ride.vehicle.color,
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
              Row(
                children: [
                  Text("Vagas Remanescentes: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  FutureBuilder(
                      future: findAllSchedulingSeatsByRide(ride),
                      builder: (_, snapshot) {
                        int totalSeats = int.parse(ride.vehicle.seats);

                        if (snapshot.hasError) {
                          return Text("Carregando...",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent));
                        } else if (!snapshot.hasData) {
                          return Text("Carregando...",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent));
                        } else {
                          int reservedSeats =
                              int.parse(snapshot.data.toString());
                          totalAvaliableSeats = totalSeats - reservedSeats;
                          return Text((totalSeats - reservedSeats).toString(),
                              style: TextStyle(color: Colors.grey));
                        }
                      })
                ],
              ),
              Row(
                children: [
                  Text("Bagagens Remanescentes: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  FutureBuilder(
                      future: findAllSchedulingSeatsByRide(ride),
                      builder: (_, snapshot) {
                        int totalLuggages =
                            int.parse(ride.vehicle.luggageSpaces);

                        if (snapshot.hasError) {
                          return Text("Carregando...",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent));
                        } else if (!snapshot.hasData) {
                          return Text("Carregando...",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent));
                        } else {
                          int reservedLuggages =
                              int.parse(snapshot.data.toString());
                          totalAvaliableLuggages =
                              totalLuggages - reservedLuggages;
                          return Text(
                              (totalLuggages - reservedLuggages).toString(),
                              style: TextStyle(color: Colors.grey));
                        }
                      }),
                ],
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "Detalhes",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  _seatsReserved == "1"
                      ? Text("Reservar $_seatsReserved vaga*: ",
                          style: TextStyle(fontWeight: FontWeight.bold))
                      : Text("Reservar $_seatsReserved vagas*: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                  Spacer(),
                  Expanded(
                      child: Container(
                          height: 35,
                          child: TextField(
                            controller: _controllerSeats,
                            focusNode: _focusSeats,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                value =
                                    checkMaxSeats(value, totalAvaliableSeats);
                                value = Utils.getSafeNumber(value);
                                _seatsReserved = value;
                              });
                            },
                          )))
                ],
              ),
              Row(
                children: [
                  _lugaggeReserved == "1"
                      ? Text("Reservar $_lugaggeReserved vaga*: ",
                          style: TextStyle(fontWeight: FontWeight.bold))
                      : Text("Reservar $_lugaggeReserved vagas*: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                  Spacer(),
                  Expanded(
                      child: Container(
                          height: 35,
                          child: TextField(
                            controller: _controllerLuggages,
                            focusNode: _focusLuggages,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                value = checkMaxLuggages(
                                    value, totalAvaliableLuggages);
                                value = Utils.getSafeNumber(value);
                                _lugaggeReserved = value;
                              });
                            },
                          )))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      style: TextButton.styleFrom(
                          backgroundColor: APP_BAR_BACKGROUND_COLOR,
                          padding: EdgeInsets.fromLTRB(28, 16, 28, 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: Text(
                        "Agendar",
                        style: (TextStyle(color: APP_WHITE_FONT, fontSize: 20)),
                      ),
                      onPressed: () {
                        save();
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getDriverName(String driverId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var result = await db.collection(DbData.TABLE_USER).doc(driverId).get();

    return result[DbData.COLUMN_USERNAME];
  }

  String checkMaxSeats(String value, int qtt) {
    int avaliable = qtt;
    value = value == "" ? "0" : value;
    int required = int.parse(value);

    if ((required > 0 && required > avaliable) || required < 1) {
      if (avaliable == 1) {
        Utils.showToast("Espaço insuficiente! Apenas 1 disponível");
      } else if (required == 0) {
        return "";
      } else if (avaliable > 1) {
        Utils.showToast("Espaço insuficiente! Apenas $avaliable disponíveis");
      } else {
        Utils.showToast("Espaço para vagas lotado!");
      }
      return "0";
    }
    return required.toString();
  }

  String checkMaxLuggages(String value, int qtt) {
    int avaliable = qtt;
    value = value == "" ? "0" : value;
    int required = int.parse(value);

    if ((required > 0 && required > avaliable) || required < 0) {
      if (avaliable == 1) {
        Utils.showToast("Espaço insuficiente! Apenas 1 disponível");
      } else if (required == 0) {
        return "";
      } else if (avaliable > 1) {
        Utils.showToast("Espaço insuficiente! Apenas $avaliable disponíveis");
      } else {
        Utils.showToast("Espaço para bagagens lotado!");
      }
      return "0";
    }
    return required.toString();
  }

  void save() {
    if (checkFields()) {
      eScheduling scheduling =
          eScheduling.full(ride.uid, _seatsReserved, _lugaggeReserved);

      insert(scheduling);
      Utils.showToast("Registrado", APP_SUCCESS_BACKGROUND);
      Navigator.pop(context);
    }
  }

  bool checkFields() {
    if (_seatsReserved == "") {
      Utils.showDialogBox(
          "É preciso selecionar quantas vagas irá ocupar!", context);
      _focusSeats!.requestFocus();
      return false;
    }

    if (_seatsReserved == "0") {
      Utils.showDialogBox(
          "As vagas reservadas precisam ser de no mínimo 1!", context);
      _focusSeats!.requestFocus();
      return false;
    }

    return true;
  }

  void insert(eScheduling scheduling) {
    db.collection(DbData.TABLE_SCHEDULING).add(scheduling.toMap());
  }

  Future<int> findAllSchedulingSeatsByRide(eRide ride) async {
    QuerySnapshot<Map<String, dynamic>> result = await db
        .collection(DbData.TABLE_SCHEDULING)
        .where(DbData.COLUMN_RIDE_ID, isEqualTo: ride.uid)
        .get();

    final allData = result.docs.map((doc) => doc.data()).toList();
    int totalReservedSeats = 0;
    for (var schedule in allData) {
      totalReservedSeats += int.parse(
          Utils.getSafeNumber(schedule[DbData.COLUMN_RESERVED_SEATS]));
    }

    return totalReservedSeats;
  }

  Future<int> findAllSchedulingLuggagesByRide(eRide ride) async {
    QuerySnapshot<Map<String, dynamic>> result = await db
        .collection(DbData.TABLE_SCHEDULING)
        .where(DbData.COLUMN_RIDE_ID, isEqualTo: ride.uid)
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
