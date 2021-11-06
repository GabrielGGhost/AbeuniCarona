import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Entity/eVehicle.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VehicleRegister extends StatefulWidget {
  DocumentSnapshot vehicle;
  VehicleRegister(this.vehicle);

  @override
  _VehicleRegisterState createState() => _VehicleRegisterState();
}

class _VehicleRegisterState extends State<VehicleRegister> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  bool? myCar = false;
  double? radiusBorder = 16;
  DocumentSnapshot? vehicle;

  TextEditingController _signControler = TextEditingController();
  TextEditingController _colorControler = TextEditingController();
  TextEditingController _modelControler = TextEditingController();
  TextEditingController _seatsControler = TextEditingController();
  TextEditingController _luggageControler = TextEditingController();
  @override
  Widget build(BuildContext context) {

    vehicle = widget.vehicle;
    String? title = AppLocalizations.of(context)!.registroDeVeiculo;
    String? textButton = AppLocalizations.of(context)!.registrarVeiculo;;
    if(vehicle != null){
      title = AppLocalizations.of(context)!.alteracaoDeVeiculo;
      textButton = AppLocalizations.of(context)!.atualizar;
      _signControler.text = vehicle![DbData.COLUMN_SIGN];
      _colorControler.text = vehicle![DbData.COLUMN_COLOR];
      _modelControler.text = vehicle![DbData.COLUMN_MODEL];
      _seatsControler.text = vehicle![DbData.COLUMN_SEATS];
      _luggageControler.text = vehicle![DbData.COLUMN_LUGGAGE_SPACES];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(cStyles.PADDING_DEFAULT_SCREEN),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _signControler,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: AppLocalizations.of(context)!.placa,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(radiusBorder!)
                      )
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _colorControler,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: AppLocalizations.of(context)!.cor,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(radiusBorder!)
                      )
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _modelControler,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: AppLocalizations.of(context)!.modelo,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(radiusBorder!)
                      )
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _seatsControler,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: AppLocalizations.of(context)!.vagas,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(radiusBorder!)
                      )
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _luggageControler,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: AppLocalizations.of(context)!.espacoParaMalas,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(radiusBorder!)
                      )
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.fromLTRB(28, 16, 28, 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)
                        )
                    ),
                    child: Text(
                      textButton,
                      style: (
                          TextStyle(
                              color: Colors.white, fontSize: 20
                          )
                      ),
                    ),
                    onPressed: (){

                      saveVehicle();
                    },
                  ),
              )
            ],
          ),
        )
      ),
    );
  }

  void saveVehicle() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    eVehicle v = eVehicle.register(_signControler.text,
        _colorControler.text,
        _modelControler.text,
        _seatsControler.text,
        _luggageControler.text);

    if(vehicle != null){

      update(v);

      Navigator.pop(context);
      Utils.showToast("Atualizado");
    } else {

      insert(v);

      Navigator.pop(context);
      Utils.showToast("Cadastrado");
    }

  }

  void update(vehicle){

    db.collection(DbData.TABLE_VEHICLE)
        .doc(_signControler.text)
        .update(vehicle.toMap());

  }

  void insert(eVehicle vehicle) {

    db.collection(DbData.TABLE_VEHICLE)
        .doc(_signControler.text)
        .set(vehicle.toMap());
  }
}
