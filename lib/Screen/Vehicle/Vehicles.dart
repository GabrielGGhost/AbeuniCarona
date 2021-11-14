import 'dart:async';
import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'package:abeuni_carona/Entity/eVehicle.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:abeuni_carona/Constants/cDate.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';

class Vechicles extends StatefulWidget {
  const Vechicles({Key? key}) : super(key: key);

  @override
  _VechiclesState createState() => _VechiclesState();
}

class _VechiclesState extends State<Vechicles> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  bool _myVehiclesOpened = false;
  bool _borrowedVehiclesOpened = false;

  final _controllerBorrowedVehicles =
      StreamController<QuerySnapshot>.broadcast();
  final _controllerMyVehicles = StreamController<QuerySnapshot>.broadcast();

  Stream<QuerySnapshot>? _addListenerBorrowedVehicles() {
    final borrowedCars = db.collection(DbData.TABLE_VEHICLE).snapshots();
    final myCars = db.collection(DbData.TABLE_VEHICLE).snapshots();

    myCars.listen((data) {
      _controllerMyVehicles.add(data);
    });
    borrowedCars.listen((data) {
      _controllerBorrowedVehicles.add(data);
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
        title: Text(AppLocalizations.of(context)!.meusVeiculos),
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
                color: APP_CARD_BACKGROUND,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.veiculosProprios,
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
                            children: [
                              Text(AppLocalizations.of(context)!
                                  .erroAoCarregarDados)
                            ],
                          ),
                        );
                      } else {
                        return Padding(
                            padding: EdgeInsets.only(left: 10, right: 20),
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
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
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Card(
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15, horizontal: 10),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        vehicle[DbData
                                                            .COLUMN_MODEL],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                      ),
                                                      Text(" - "),
                                                      Text(
                                                        vehicle[
                                                            DbData.COLUMN_SIGN],
                                                        style: TextStyle(
                                                            color: APP_HINT_TEXT_FIELD,
                                                            fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .assentos,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(": "),
                                                      Text(
                                                        vehicle[DbData
                                                                    .COLUMN_SEATS] !=
                                                                ""
                                                            ? vehicle[DbData
                                                                .COLUMN_SEATS]
                                                            : AppLocalizations
                                                                    .of(context)!
                                                                .naoInformado,
                                                        style: TextStyle(
                                                            color: APP_HINT_TEXT_FIELD),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .malas,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(": "),
                                                      Text(
                                                        vehicle[DbData
                                                                    .COLUMN_LUGGAGE_SPACES] !=
                                                                ""
                                                            ? vehicle[DbData
                                                                .COLUMN_LUGGAGE_SPACES]
                                                            : AppLocalizations
                                                                    .of(context)!
                                                                .naoInformado,
                                                        style: TextStyle(
                                                            color: APP_HINT_TEXT_FIELD),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        AppLocalizations.of(
                                                            context)!
                                                            .registro,
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight.bold),
                                                      ),
                                                      Text(": "),
                                                      Text(
                                                        Utils.getDateFromBD(vehicle[DbData
                                                            .COLUMN_REGISTRATION_DATE], cDate.FORMAT_SLASH_DD_MM_YYYY_KK_MM),
                                                        style: TextStyle(
                                                            color: APP_HINT_TEXT_FIELD),
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
                                                title: Text(AppLocalizations.of(
                                                        context)!
                                                    .confirmarExclusao),
                                                content: Text(AppLocalizations
                                                        .of(context)!
                                                    .temCertezaQueDesejaExcluirEsteVeiculo),
                                                actions: <Widget>[
                                                  TextButton(
                                                      onPressed: () {
                                                        delete(vehicle.id);
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
                                                            color: APP_CANCEL_BUTTON,
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
                                        color: APP_EDIT_DISMISS,
                                        child: Icon(Icons.edit),
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(left: 15),
                                        margin: EdgeInsets.only(bottom: 20),
                                      ),
                                      secondaryBackground: Container(
                                        color: APP_REMOVE_DISMISS,
                                        child: Icon(Icons.delete),
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.only(right: 15),
                                        margin: EdgeInsets.only(bottom: 20),
                                      ),
                                    ),
                                    visible: _myVehiclesOpened,
                                  );
                                }));
                      }
                  }
                }),
            GestureDetector(
              onTap: () {
                setState(
                    () => _borrowedVehiclesOpened = !_borrowedVehiclesOpened);
              },
              child: Card(
                color: APP_CARD_BACKGROUND,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.veiculosEmprestados,
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
                            children: [
                              Text(AppLocalizations.of(context)!
                                  .erroAoCarregarDados)
                            ],
                          ),
                        );
                      } else {
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
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
                                          padding: EdgeInsets.only(
                                              left: 10,
                                              top: 10,
                                              bottom: 10,
                                              right: 50),
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
                                                        color: APP_HINT_TEXT_FIELD,
                                                        fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .assentos,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(": "),
                                                  Text(
                                                    vehicle[DbData
                                                                .COLUMN_SEATS] !=
                                                            ""
                                                        ? vehicle[
                                                            DbData.COLUMN_SEATS]
                                                        : AppLocalizations.of(
                                                                context)!
                                                            .naoInformado,
                                                    style: TextStyle(
                                                        color: APP_HINT_TEXT_FIELD),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .malas,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(": "),
                                                  Text(
                                                    vehicle[DbData
                                                                .COLUMN_LUGGAGE_SPACES] !=
                                                            ""
                                                        ? vehicle[DbData
                                                            .COLUMN_LUGGAGE_SPACES]
                                                        : AppLocalizations.of(
                                                                context)!
                                                            .naoInformado,
                                                    style: TextStyle(
                                                        color: APP_HINT_TEXT_FIELD),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(
                                                        context)!
                                                        .registro,
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                  Text(": "),
                                                  Text(
                                                    Utils.getDateFromBD(vehicle[DbData
                                                        .COLUMN_REGISTRATION_DATE], cDate.FORMAT_SLASH_DD_MM_YYYY_KK_MM),
                                                    style: TextStyle(
                                                        color: APP_HINT_TEXT_FIELD),
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
                                            title: Text(
                                                AppLocalizations.of(context)!
                                                    .confirmarExclusao),
                                            content: Text(AppLocalizations.of(
                                                    context)!
                                                .temCertezaQueDesejaExcluirEsteVeiculo),
                                            actions: <Widget>[
                                              TextButton(
                                                  onPressed: () {
                                                    delete(vehicle.id);
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
                                                    padding: EdgeInsets.all(5),
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .cancelar,
                                                      style: TextStyle(
                                                        color: APP_CANCEL_BUTTON,
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
                                    color: APP_EDIT_DISMISS,
                                    child: Icon(Icons.edit),
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 20),
                                  ),
                                  secondaryBackground: Container(
                                    color: APP_REMOVE_DISMISS,
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
              backgroundColor: APP_BAR_BACKGROUND_COLOR,
              child: Icon(
                Icons.filter_alt_sharp,
                color: APP_WHITE_FONT,
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
                color: APP_WHITE_FONT,
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
          item.id,
          data[DbData.COLUMN_SIGN],
          data[DbData.COLUMN_COLOR],
          data[DbData.COLUMN_MODEL],
          data[DbData.COLUMN_SEATS],
          data[DbData.COLUMN_LUGGAGE_SPACES],
          data[DbData.COLUMN_REGISTRATION_DATE]);
      myVehicles.add(vehicle);
    }

    return myVehicles;
  }

  void delete(String id) {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      db.collection(DbData.TABLE_VEHICLE).doc(id).delete();

      Utils.showToast(AppLocalizations.of(context)!.deletado, APP_SUCCESS_BACKGROUND);
    } catch (e) {
      Utils.showToast(AppLocalizations.of(context)!.falhaAoDeletarVeiculo, APP_ERROR_BACKGROUND);
    }
  }
}
