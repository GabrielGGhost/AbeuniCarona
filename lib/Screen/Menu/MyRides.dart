import 'dart:async';

import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';

class MyRides extends StatefulWidget {
  const MyRides({Key? key}) : super(key: key);

  @override
  _MyRidesState createState() => _MyRidesState();
}

class _MyRidesState extends State<MyRides> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  final _streamMyRides = StreamController<QuerySnapshot>.broadcast();

  String? _idLoggedUser;

  Future<Stream<QuerySnapshot<Object?>>?> _addListenerBorrowedVehicles() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;

    final MyRides = db
        .collection(DbData.TABLE_RIDE)
        .where(DbData.COLUMN_DRIVER_ID, isEqualTo: usuarioLogado!.uid)
        .snapshots();

    MyRides.listen((data) {
      _streamMyRides.add(data);
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
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: GestureDetector(
          child: StreamBuilder(
              stream: _streamMyRides.stream,
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
                      if (query.docs.length > 0) {
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: query.docs.length,
                            itemBuilder: (_, index) {
                              List<DocumentSnapshot> rides =
                                  query.docs.toList();

                              DocumentSnapshot ride = rides[index];

                              bool edit =
                                  ride[DbData.COLUMN_DRIVER_ID] != null &&
                                      ride[DbData.COLUMN_DRIVER_ID] != "" &&
                                      ride[DbData.COLUMN_DRIVER_ID] ==
                                          _idLoggedUser;

                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          ride[DbData.COLUMN_EVENT][DbData
                                              .COLUMN_EVENT_DESC_BASE_EVENT],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
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
                                              TextSpan(text: 'Localização: '),
                                              TextSpan(
                                                  text: ride[
                                                          DbData.COLUMN_EVENT]
                                                      [DbData.COLUMN_LOCATION],
                                                  style: TextStyle(
                                                      color: APP_SUB_TEXT)),
                                            ],
                                          ),
                                        )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Data/Horário: "),
                                        Text(
                                          ride[DbData.COLUMN_DEPARTURE_DATE] +
                                              " - " +
                                              ride[
                                                  DbData.COLUMN_DEPARTURE_TIME],
                                          style: TextStyle(color: APP_SUB_TEXT),
                                        )
                                      ],
                                    ),
                                    ride[DbData.COLUMN_RETURN_DATE] != null &&
                                            ride[DbData.COLUMN_RETURN_DATE] !=
                                                ""
                                        ? Text(
                                            ride[DbData.COLUMN_RETURN_DATE] +
                                                " - " +
                                                ride[DbData.COLUMN_RETURN_TIME],
                                            style:
                                                TextStyle(color: APP_SUB_TEXT),
                                          )
                                        : Text(
                                            "Sem Dados de Retorno Informados",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: APP_SUB_TEXT),
                                          ),
                                    Row(
                                      children: [
                                        Text("Motorista: "),
                                        Text(
                                          ride[DbData.COLUMN_DRIVER_NAME],
                                          style: TextStyle(color: APP_SUB_TEXT),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Registrado há : " +
                                            Utils.getDateTimeUntilNow(ride[
                                                DbData
                                                    .COLUMN_REGISTRATION_DATE]))
                                      ],
                                    ),
                                    Divider(),
                                  ],
                                ),
                              );
                            });
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Não há caronas disponíveis",
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
                }
              }),
          onTap: () {
            Navigator.pushNamed(context, cRoutes.PARTAKER);
          },
        ));
  }

  void _getUserData() async {}
}
