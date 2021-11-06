import 'dart:async';
import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'package:abeuni_carona/Entity/eVehicle.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';

class Vechicles extends StatefulWidget {
  const Vechicles({Key? key}) : super(key: key);

  @override
  _VechiclesState createState() => _VechiclesState();
}

class _VechiclesState extends State<Vechicles> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<eVehicle>?> _myVehicles = _findAllMyVehicles();

  bool _myVehiclesOpened = false;
  bool _borrowedVehiclesOpened = true;

  final _controllerBorrowedVehicles =
      StreamController<QuerySnapshot>.broadcast();
  final _controllerMyVehicles = StreamController<QuerySnapshot>.broadcast();

  Stream<QuerySnapshot>? _addListenerBorrowedVehicles() {
    final borrowedCars = db.collection(DbData.TABLE_VEHICLE).snapshots();

    borrowedCars.listen((data) {
      _controllerBorrowedVehicles.add(data);
      _controllerMyVehicles.add(data);
    });
  }

  @override
  void initState() {
    _addListenerBorrowedVehicles();
    super.initState();
    //_getUserLoggedData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus Veículos"),
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(cStyles.PADDING_DEFAULT_SCREEN),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() => _myVehiclesOpened = !_myVehiclesOpened);
              },
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Text(
                        "Veículos próprios",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      _myVehiclesOpened
                          ? Icon(Icons.arrow_drop_up_rounded)
                          : Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
            ),
            StreamBuilder(
                stream: _controllerMyVehicles.stream,
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
                        return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: query.docs.length,
                            itemBuilder: (_, index) {
                              List<DocumentSnapshot> vechicles =
                                  query.docs.toList();

                              DocumentSnapshot vehicle = vechicles[index];
                              return Visibility(
                                child: Dismissible(
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 15),
                                    child: Card(
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 10),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    vehicle[
                                                        DbData.COLUMN_MODEL],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                  Text(" - "),
                                                  Text(
                                                    vehicle[DbData.COLUMN_SIGN],
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Assentos",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(": "),
                                                  Text(
                                                    vehicle[
                                                        DbData.COLUMN_SEATS],
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Malas",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(": "),
                                                  Text(
                                                    vehicle[DbData
                                                        .COLUMN_LUGGAGE_SPACES],
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  )
                                                ],
                                              )
                                            ],
                                          )),
                                    ),
                                  ),
                                  confirmDismiss: (d) async {
                                    if (d == DismissDirection.startToEnd) {
                                      Navigator.pushNamed(
                                          context, cRoutes.VEHICLES_REGISTER,
                                          arguments: vehicle);
                                      return false;
                                    } else {
                                      return await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Confirmar exclusão"),
                                            content: Text(
                                                "Tem certeza que deseja cancelar este carro?"),
                                            actions: <Widget>[
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(true),
                                                  child: Text("Tenho certeza")),
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Text(
                                                      "Cancelar",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                  key: Key(vehicle[DbData.COLUMN_SIGN]),
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
                                ),
                                visible: _myVehiclesOpened,
                              );
                            });
                      }
                  }
                })

            /*
            FutureBuilder<List<eVehicle>>(
                future: _myVehicles as Future<List<eVehicle>>,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                          child: Column(
                        children: [CircularProgressIndicator()],
                      ));
                    case ConnectionState.active:
                    case ConnectionState.done:
                      int size = snapshot.data!.length;
                      return size > 0
                          ? Visibility(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: size,
                                  itemBuilder: (_, index) {
                                    List<eVehicle> vehicles =
                                        snapshot.data!.toList();
                                    eVehicle vehicle = vehicles[index];
                                    return Dismissible(
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 15),
                                        child: Card(
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15, horizontal: 10),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        vehicle.model,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                      ),
                                                      Text(" - "),
                                                      Text(
                                                        vehicle.sign,
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Assentos",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(": "),
                                                      Text(
                                                        vehicle.seats,
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Malas",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(": "),
                                                      Text(
                                                        vehicle.luggageSpaces,
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              )),
                                        ),
                                      ),
                                      confirmDismiss: (d) async {
                                        if (d == DismissDirection.startToEnd) {
                                          Navigator.pushNamed(context,
                                              cRoutes.VEHICLES_REGISTER,
                                              arguments: vehicle);
                                          return false;
                                        } else {
                                          return await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title:
                                                    Text("Confirmar exclusão"),
                                                content: Text(
                                                    "Tem certeza que deseja cancelar este carro?"),
                                                actions: <Widget>[
                                                  TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(true),
                                                      child: Text(
                                                          "Tenho certeza")),
                                                  TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(false),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        child: Text(
                                                          "Cancelar",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      )),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      key: Key(vehicle.sign),
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
                                  }),
                              visible: _myVehiclesOpened,
                            )
                          : Container();
                  }
                })*/
            ,
            GestureDetector(
              onTap: () {
                setState(
                    () => _borrowedVehiclesOpened = !_borrowedVehiclesOpened);
              },
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Text(
                        "Veículos emprestados",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      _borrowedVehiclesOpened
                          ? Icon(Icons.arrow_drop_up_rounded)
                          : Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
            ),
            StreamBuilder(
                stream: _controllerBorrowedVehicles.stream,
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
                        return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: query.docs.length,
                            itemBuilder: (_, index) {
                              List<DocumentSnapshot> vechicles =
                                  query.docs.toList();

                              DocumentSnapshot vehicle = vechicles[index];
                              return Visibility(
                                child: Dismissible(
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 15),
                                    child: Card(
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 10),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    vehicle[
                                                        DbData.COLUMN_MODEL],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                  Text(" - "),
                                                  Text(
                                                    vehicle[DbData.COLUMN_SIGN],
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Assentos",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(": "),
                                                  Text(
                                                    vehicle[
                                                        DbData.COLUMN_SEATS],
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Malas",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(": "),
                                                  Text(
                                                    vehicle[DbData
                                                        .COLUMN_LUGGAGE_SPACES],
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  )
                                                ],
                                              )
                                            ],
                                          )),
                                    ),
                                  ),
                                  confirmDismiss: (d) async {
                                    if (d == DismissDirection.startToEnd) {
                                      Navigator.pushNamed(
                                          context, cRoutes.VEHICLES_REGISTER,
                                          arguments: vehicle);
                                      return false;
                                    } else {
                                      return await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Confirmar exclusão"),
                                            content: Text(
                                                "Tem certeza que deseja cancelar este carro?"),
                                            actions: <Widget>[
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(true),
                                                  child: Text("Tenho certeza")),
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Text(
                                                      "Cancelar",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                  key: Key(vehicle[DbData.COLUMN_SIGN]),
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
                                ),
                                visible: _borrowedVehiclesOpened,
                              );
                            });
                      }
                  }
                }),
          ],
        ),
      )),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
              onPressed: () {
                Utils.showDialogBox("Teste", context);
              },
              backgroundColor: Colors.blueAccent,
              child: Icon(
                Icons.filter_alt_sharp,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.zero,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, cRoutes.VEHICLES_REGISTER);
              },
              backgroundColor: APP_BAR_BACKGROUND_COLOR,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<List<eVehicle>?> _findAllMyVehicles() async {
    List<eVehicle> myVehicles = [];

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(DbData.TABLE_VEHICLE).get();

    for (DocumentSnapshot item in querySnapshot.docs) {
      var data = item.data() as Map;

      eVehicle vehicle = eVehicle(
          data[DbData.COLUMN_SIGN],
          data[DbData.COLUMN_COLOR],
          data[DbData.COLUMN_MODEL],
          data[DbData.COLUMN_SEATS],
          data[DbData.COLUMN_LUGGAGE_SPACES],
          data[DbData.COLUMN_MY_CAR]);
      myVehicles.add(vehicle);
    }

    return myVehicles;
  }
}
