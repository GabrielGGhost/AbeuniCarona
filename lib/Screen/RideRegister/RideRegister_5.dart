import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:abeuni_carona/Entity/eRide.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'RideRegister_4.dart';

class RideRegister_5 extends StatefulWidget {
  eRide ride;
  RideRegister_5(this.ride);

  @override
  _RideRegister_5State createState() => _RideRegister_5State();
}

class _RideRegister_5State extends State<RideRegister_5> {
  @override
  Widget build(BuildContext context) {
    eRide ride = widget.ride;
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
                      "Confira as informações informadas, para corrigir alguma, clique no card para ser redirecionado à tela!",
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
                                Row(children: [
                                  Text("Assentos: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  Text(ride.vehicle.seats,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                ]),
                                Row(children: [
                                  Text("Bagagens: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  Text(ride.vehicle.luggageSpaces,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                ])
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Evento Base",
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
                                  Text("Tipo: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  Text(ride.event.descBaseEvent,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                ]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Column(
                  children: [
                    Card(
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Evento",
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
                                  Text("Tipo: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  Text(ride.event.descBaseEvent,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                ]),
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
                                        Text("Local de partida: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                        Text(ride.departureAddress,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15)),
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
                                        ))
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.zero,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, cRoutes.REGISTER_RIDE4);
              },
              backgroundColor: APP_BAR_BACKGROUND_COLOR,
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
