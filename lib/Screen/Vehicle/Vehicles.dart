import 'dart:async';
import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'package:abeuni_carona/Entity/eVehicle.dart';
import 'package:abeuni_carona/Screen/Vehicle/VehiclesForm.dart';
import 'package:abeuni_carona/Selects/VehiclesSelects.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:abeuni_carona/Constants/cDate.dart';

class Vechicles extends StatefulWidget {
  const Vechicles({Key? key}) : super(key: key);

  @override
  _VechiclesState createState() => _VechiclesState();
}

class _VechiclesState extends State<Vechicles> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  VehiclesForm form = VehiclesForm();
  bool list = true;
  final _controllerMyVehicles = StreamController<QuerySnapshot>.broadcast();

  Future<Stream<QuerySnapshot<Object?>>?> _addListenerBorrowedVehicles() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = auth.currentUser;

    form.idUser = usuarioLogado!.uid;
    final myCars = VehiclesSelects.getSelectByFilters(form);

    myCars.listen((data) {
      _controllerMyVehicles.add(data);
    });
  }

  @override
  void initState() {
    _getUserData();
    _addListenerBorrowedVehicles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Veiculos"),
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(cStyles.PADDING_DEFAULT_SCREEN),
        child: Column(
          children: [
            Visibility(
              child: Row(
                children: [
                  Text("Situação:  "),
                  DropdownButton<String>(
                    value: form.situation,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        form.situation = newValue!;
                      });
                      _addListenerBorrowedVehicles();
                    },
                    items: <String>['Ativos', 'Inativos', 'Todos']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              visible: !list,
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
                            padding: EdgeInsets.only(top: 0),
                            child: ExpansionTile(
                                title: Text("Veículos"),
                                subtitle: Text(
                                  "Esses são os veículos cadastrados por você",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                textColor: APP_BAR_BACKGROUND_COLOR,
                                children: [
                                  ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: query.docs.length,
                                      itemBuilder: (_, index) {
                                        List<DocumentSnapshot> vechicles =
                                            query.docs.toList();

                                        DocumentSnapshot vehicle =
                                            vechicles[index];
                                        return Dismissible(
                                          child: Padding(
                                            padding: EdgeInsets.only(bottom: 0),
                                            child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 10),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          vehicle[DbData
                                                              .COLUMN_MODEL],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18),
                                                        ),
                                                        Text(" - "),
                                                        Text(
                                                          vehicle[DbData
                                                              .COLUMN_SIGN],
                                                          style: TextStyle(
                                                              color:
                                                                  APP_HINT_TEXT_FIELD,
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
                                                              color:
                                                                  APP_HINT_TEXT_FIELD),
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
                                                              color:
                                                                  APP_HINT_TEXT_FIELD),
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
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(": "),
                                                        Text(
                                                          Utils.getStringDateFromTimestamp(
                                                              vehicle[DbData
                                                                  .COLUMN_REGISTRATION_DATE],
                                                              cDate
                                                                  .FORMAT_SLASH_DD_MM_YYYY_KK_MM)!,
                                                          style: TextStyle(
                                                              color:
                                                                  APP_HINT_TEXT_FIELD),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                )),
                                          ),
                                          confirmDismiss: (d) async {
                                            if (d ==
                                                DismissDirection.startToEnd) {
                                              final result =
                                                  await Navigator.pushNamed(
                                                      context,
                                                      cRoutes.VEHICLES_REGISTER,
                                                      arguments: vehicle);
                                              _addListenerBorrowedVehicles();
                                              return false;
                                            } else {
                                              return await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .confirmarExclusao),
                                                    content: Text(AppLocalizations
                                                            .of(context)!
                                                        .temCertezaQueDesejaExcluirEsteVeiculo),
                                                    actions: <Widget>[
                                                      TextButton(
                                                          onPressed: () {
                                                            delete(vehicle.id);
                                                            Navigator.of(
                                                                    context)
                                                                .pop(true);
                                                          },
                                                          child: Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .tenhoCerteza)),
                                                      TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(false),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            child: Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .cancelar,
                                                              style: TextStyle(
                                                                color:
                                                                    APP_CANCEL_BUTTON,
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
                                        );
                                      })
                                ]));
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
                setState(() {
                  list = !list;
                });
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

  void delete(String id) {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      db.collection(DbData.TABLE_VEHICLE).doc(id).delete();

      Utils.showToast(
          AppLocalizations.of(context)!.deletado, APP_SUCCESS_BACKGROUND);
    } catch (e) {
      Utils.showToast(AppLocalizations.of(context)!.falhaAoDeletarVeiculo,
          APP_ERROR_BACKGROUND);
    }
  }

  void _getUserData() async {}
}
