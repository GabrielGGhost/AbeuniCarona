import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Entity/eVehicle.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:abeuni_carona/Constants/cDate.dart';

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
  String? _registration = "";

  TextEditingController _signControler = TextEditingController();
  TextEditingController _colorControler = TextEditingController();
  TextEditingController _modelControler = TextEditingController();
  TextEditingController _seatsControler = TextEditingController();
  TextEditingController _luggageControler = TextEditingController();

  FocusNode? _signFocus;
  FocusNode? _colorFocus;
  FocusNode? _modelFocus;

  String? _idLoggedUser;

  @override
  void initState() {
    _registration = Utils.getDateTimeNow(cDate.FORMAT_SLASH_DD_MM_YYYY_KK_MM);
    _signFocus = FocusNode();
    _colorFocus = FocusNode();
    _modelFocus = FocusNode();
    _getUserData();
    super.initState();
  }

  @override
  void dispose() {

    _signFocus!.dispose();
    _colorFocus!.dispose();
    _modelFocus!.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    vehicle = widget.vehicle;

    if(vehicle != null){
      _registration = Utils.getDateFromBD(vehicle![DbData.COLUMN_REGISTRATION_DATE], cDate.FORMAT_SLASH_DD_MM_YYYY_KK_MM);
    }

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
                  focusNode: _signFocus,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: AppLocalizations.of(context)!.placa + AppLocalizations.of(context)!.obr,
                      filled: true,
                      fillColor: APP_TEXT_FIELD_BACKGROUND,
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
                  focusNode: _colorFocus,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: AppLocalizations.of(context)!.cor + AppLocalizations.of(context)!.obr,
                      filled: true,
                      fillColor: APP_TEXT_FIELD_BACKGROUND,
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
                  focusNode: _modelFocus,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: AppLocalizations.of(context)!.modelo + AppLocalizations.of(context)!.obr,
                      filled: true,
                      fillColor: APP_TEXT_FIELD_BACKGROUND,
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
                      fillColor: APP_TEXT_FIELD_BACKGROUND,
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
                      fillColor: APP_TEXT_FIELD_BACKGROUND,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(radiusBorder!)
                      )
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
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
                        _registration!,
                      style: TextStyle(
                          color: APP_SUB_TEXT),
                    )
                  ],
                )
              ),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor: APP_BAR_BACKGROUND_COLOR,
                        padding: EdgeInsets.fromLTRB(28, 16, 28, 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)
                        )
                    ),
                    child: Text(
                      textButton,
                      style: (
                          TextStyle(
                              color: APP_WHITE_FONT, fontSize: 20
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
    eVehicle v = eVehicle(null,
                          _signControler.text,
                          _colorControler.text,
                          _modelControler.text,
                          _seatsControler.text,
                          _luggageControler.text,
                          Utils.getDateTimeNow(cDate.FORMAT_SLASH_DD_MM_YYYY_KK_MM),
                          _idLoggedUser);

    if(vehicle != null){

      try{
        v.id = vehicle!.id;
        v.registrationDate = vehicle![DbData.COLUMN_REGISTRATION_DATE];
        update(v);

        Navigator.pop(context);
        Utils.showToast(AppLocalizations.of(context)!.veiculoAtualizado, APP_SUCCESS_BACKGROUND);
      } catch (e){
        Utils.showToast(AppLocalizations.of(context)!.erroAoAtualizar, APP_ERROR_BACKGROUND);
      }

    } else {
      try{
        if(checkFields()){
          v.registrationDate = DateTime.now().toString();
          insert(v);
          Navigator.pop(context);
          Utils.showToast(AppLocalizations.of(context)!.veiculoCadastrado, APP_SUCCESS_BACKGROUND);
        }
      } catch (e){
        Utils.showToast(AppLocalizations.of(context)!.erroAoInserir, APP_ERROR_BACKGROUND);
      }

    }

  }

  void update(vehicle){

    db.collection(DbData.TABLE_VEHICLE)
        .doc(vehicle.id)
        .update(vehicle.toMap());

  }

  void insert(eVehicle vehicle) {

    db.collection(DbData.TABLE_VEHICLE)
        .add(vehicle.toMap());
  }

  bool checkFields() {

    if(_signControler.text.length == 0){

      Utils.showDialogBox(AppLocalizations.of(context)!.oVeiculoPrecisaDeUmaPlaca, context);
      _signFocus!.requestFocus();
      return false;
    }
    if(_signControler.text.length > 8 || _signControler.text.length < 8){

      Utils.showDialogBox(AppLocalizations.of(context)!.aPlacaDeveConterOitoCaracteres, context);
      _signFocus!.requestFocus();
      return false;
    }

    if(_colorControler.text.length == 0){

      Utils.showDialogBox(AppLocalizations.of(context)!.informeACorDoVeiculo, context);
      _colorFocus!.requestFocus();
      return false;
    }

    if(_modelControler.text.length == 0){

      Utils.showDialogBox(AppLocalizations.of(context)!.informeOModeloDoVeiculo, context);
      _modelFocus!.requestFocus();
      return false;
    }

    return true;
  }

  void _getUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;

    if (usuarioLogado != null) {
      _idLoggedUser = usuarioLogado.uid;
    }
  }
}
