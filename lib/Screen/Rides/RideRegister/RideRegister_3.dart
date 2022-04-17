import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:abeuni_carona/Entity/eRide.dart';
import 'package:abeuni_carona/Entity/eVehicle.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:flutter/material.dart';

import 'RideRegister_4.dart';

class RideRegister_3 extends StatefulWidget {
  eRide ride;
  bool edit;
  RideRegister_3(this.ride, this.edit);

  @override
  _RideRegister_3State createState() => _RideRegister_3State();
}

class _RideRegister_3State extends State<RideRegister_3> {
  TextEditingController _seatsController = TextEditingController();
  TextEditingController _luggageSpacesController = TextEditingController();

  eRide ride = eRide();
  bool edit = false;
  @override
  Widget build(BuildContext context) {
    ride = widget.ride;
    edit = widget.edit;
    eVehicle? vehicle = ride.vehicle;

    _seatsController.text = vehicle.seats;
    _luggageSpacesController.text = vehicle.luggageSpaces;

    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de eventos"),
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(cStyles.PADDING_DEFAULT_SCREEN),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Text(
                      "Placa: ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      vehicle.sign,
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    )
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Text(
                      "Cor:: ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      vehicle.color,
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    )
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Text(
                      "Modelo: ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      vehicle.model,
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    )
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _seatsController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Vagas",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              cStyles.RADIUS_BORDER_TEXT_FIELD))),
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _luggageSpacesController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Malas",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              cStyles.RADIUS_BORDER_TEXT_FIELD))),
                ),
              ),
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
                nextStep(vehicle, ride);
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

  void nextStep(eVehicle vehicle, eRide ride) {
    vehicle.seats = _seatsController.text;
    vehicle.luggageSpaces = _luggageSpacesController.text;

    ride.vehicle = vehicle;

    edit
        ? Navigator.pop(context, ride)
        : Navigator.pushNamed(context, cRoutes.REGISTER_RIDE4, arguments: ride);
  }
}
