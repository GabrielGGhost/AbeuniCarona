import 'package:abeuni_carona/Entity/eRide.dart';
import 'package:abeuni_carona/Entity/eVehicle.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Constants/cDate.dart';

import 'RideRegister_1.dart';

class RideRegister_2 extends StatefulWidget {
  eRide ride;
  RideRegister_2(this.ride);
  @override
  _RideRegister_2State createState() => _RideRegister_2State();
}

class _RideRegister_2State extends State<RideRegister_2> {
  bool _myVehiclesOpened = false;
  bool _borrowedVehiclesOpened = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de evento"),
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
      ),
      body: true
          ? SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                children: [
                  StreamBuilder(
                      stream: db
                          .collection(DbData.TABLE_VEHICLE)
                          .where(DbData.COLUMN_ACTIVE, isEqualTo: true)
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
                            } else {
                              return Padding(
                                padding: EdgeInsets.only(left: 10, right: 20),
                                child: ExpansionTile(
                                  title: Text(AppLocalizations.of(context)!
                                      .veiculosProprios),
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
                                          return Card(
                                            child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 15,
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
                                                          Utils.getDateFromBD(
                                                              vehicle[DbData
                                                                  .COLUMN_REGISTRATION_DATE],
                                                              cDate
                                                                  .FORMAT_SLASH_DD_MM_YYYY_KK_MM),
                                                          style: TextStyle(
                                                              color:
                                                                  APP_HINT_TEXT_FIELD),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                )),
                                          );
                                        })
                                  ],
                                ),
                              );
                            }
                        }
                      })
                ],
              ),
            ))
          : Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Não há veículos\ncadastrados ou disponíveis!\nRegistre um para programar\numa carona ",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            )),
    );
  }
}
