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
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class VehicleRegister extends StatefulWidget {
  DocumentSnapshot vehicle;
  VehicleRegister(this.vehicle);

  @override
  _VehicleRegisterState createState() => _VehicleRegisterState();
}

class _VehicleRegisterState extends State<VehicleRegister> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  bool? myCar = false;
  bool? _active = true;
  bool? _loaded = false;
  double? radiusBorder = 16;
  DocumentSnapshot? vehicle;
  String? _registration = "";

  TextEditingController _signController = TextEditingController();
  TextEditingController _colorController = TextEditingController();
  TextEditingController _modelController = TextEditingController();
  TextEditingController _seatsController = TextEditingController();
  TextEditingController _luggageController = TextEditingController();

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
    String? title = AppLocalizations.of(context)!.registroDeVeiculo;
    String? textButton = AppLocalizations.of(context)!.registrarVeiculo;
    if (vehicle != null) {
      _registration = Utils.getStringDateFromTimestamp(
          vehicle![DbData.COLUMN_REGISTRATION_DATE],
          cDate.FORMAT_SLASH_DD_MM_YYYY_KK_MM);
      title = AppLocalizations.of(context)!.alteracaoDeVeiculo;
      textButton = AppLocalizations.of(context)!.atualizar;
    }

    if (vehicle != null && !_loaded!) {
      _signController.text = vehicle![DbData.COLUMN_SIGN];
      _colorController.text = vehicle![DbData.COLUMN_COLOR];
      _modelController.text = vehicle![DbData.COLUMN_MODEL];
      _seatsController.text = vehicle![DbData.COLUMN_SEATS];
      _luggageController.text = vehicle![DbData.COLUMN_LUGGAGE_SPACES];
      _active = vehicle![DbData.COLUMN_ACTIVE];

      _loaded = true;
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
                controller: _signController,
                autofocus: true,
                focusNode: _signFocus,
                textCapitalization: TextCapitalization.characters,
                keyboardType: TextInputType.text,
                maxLength: 10,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    hintText: AppLocalizations.of(context)!.placa +
                        AppLocalizations.of(context)!.obr,
                    filled: true,
                    fillColor: APP_TEXT_FIELD_BACKGROUND,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(radiusBorder!))),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: TextField(
                controller: _colorController,
                keyboardType: TextInputType.text,
                focusNode: _colorFocus,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    hintText: AppLocalizations.of(context)!.cor +
                        AppLocalizations.of(context)!.obr,
                    filled: true,
                    fillColor: APP_TEXT_FIELD_BACKGROUND,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(radiusBorder!))),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: TextField(
                controller: _modelController,
                keyboardType: TextInputType.text,
                focusNode: _modelFocus,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    hintText: AppLocalizations.of(context)!.modelo +
                        AppLocalizations.of(context)!.obr,
                    filled: true,
                    fillColor: APP_TEXT_FIELD_BACKGROUND,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(radiusBorder!))),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: TextField(
                controller: _seatsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    hintText: AppLocalizations.of(context)!.vagas,
                    filled: true,
                    fillColor: APP_TEXT_FIELD_BACKGROUND,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(radiusBorder!))),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: TextField(
                controller: _luggageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    hintText: AppLocalizations.of(context)!.espacoParaMalas,
                    filled: true,
                    fillColor: APP_TEXT_FIELD_BACKGROUND,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(radiusBorder!))),
              ),
            ),
            Row(
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Checkbox(
                          checkColor: APP_CHECK_COLOR,
                          value: _active,
                          onChanged: (bool? value) {
                            setState(() {
                              _active = !_active!;
                            });
                          },
                        ),
                        RichText(
                          text: TextSpan(
                              text: AppLocalizations.of(context)!.ativo,
                              style: TextStyle(
                                  color:
                                      _active! ? APP_MAIN_TEXT : APP_SUB_TEXT),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  setState(() {
                                    _active = !_active!;
                                  });
                                }),
                        )
                      ],
                    )),
              ],
            ),
            Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.registro,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(": "),
                    Text(
                      _registration!,
                      style: TextStyle(color: APP_SUB_TEXT),
                    )
                  ],
                )),
            Padding(
              padding: EdgeInsets.all(20),
              child: ElevatedButton(
                style: TextButton.styleFrom(
                    backgroundColor: APP_BAR_BACKGROUND_COLOR,
                    padding: EdgeInsets.fromLTRB(28, 16, 28, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                child: Text(
                  textButton,
                  style: (TextStyle(color: APP_WHITE_FONT, fontSize: 20)),
                ),
                onPressed: () {
                  saveVehicle();
                },
              ),
            )
          ],
        ),
      )),
    );
  }

  void saveVehicle() {
    eVehicle v = eVehicle(
        null,
        _signController.text.trim(),
        _colorController.text.trim(),
        _modelController.text.trim(),
        _seatsController.text.trim(),
        _luggageController.text.trim(),
        Timestamp.now(),
        _idLoggedUser,
        _active);

    if (vehicle != null) {
      try {
        v.id = vehicle!.id;
        v.registrationDate = vehicle![DbData.COLUMN_REGISTRATION_DATE];
        update(v);

        Navigator.pop(context);
        Utils.showToast(AppLocalizations.of(context)!.veiculoAtualizado,
            APP_SUCCESS_BACKGROUND);
      } catch (e) {
        Utils.showToast(AppLocalizations.of(context)!.erroAoAtualizar,
            APP_ERROR_BACKGROUND);
      }
    } else {
      try {
        if (checkFields()) {
          insert(v);
          Navigator.pop(context);
          Utils.showToast(AppLocalizations.of(context)!.veiculoCadastrado,
              APP_SUCCESS_BACKGROUND);
        }
      } catch (e) {
        Utils.showToast(
            AppLocalizations.of(context)!.erroAoInserir, APP_ERROR_BACKGROUND);
      }
    }
  }

  void update(vehicle) {
    db.collection(DbData.TABLE_VEHICLE).doc(vehicle.id).update(vehicle.toMap());
  }

  void insert(eVehicle vehicle) {
    db.collection(DbData.TABLE_VEHICLE).add(vehicle.toMap());
  }

  bool checkFields() {
    if (_signController.text.length == 0) {
      Utils.showDialogBox(
          AppLocalizations.of(context)!.oVeiculoPrecisaDeUmaPlaca, context);
      _signFocus!.requestFocus();
      return false;
    }

    if (_colorController.text.length == 0) {
      Utils.showDialogBox(
          AppLocalizations.of(context)!.informeACorDoVeiculo, context);
      _colorFocus!.requestFocus();
      return false;
    }

    if (_modelController.text.length == 0) {
      Utils.showDialogBox(
          AppLocalizations.of(context)!.informeOModeloDoVeiculo, context);
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
