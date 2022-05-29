import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'package:abeuni_carona/Entity/eUser.dart';
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

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

enum PhoneType { cellphone, home }

class _RegisterUserState extends State<RegisterUser> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  double? radiusBorder = 16;
  String? _registration = "";

  TextEditingController _emailControler = TextEditingController();
  TextEditingController _userNameControler = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();
  TextEditingController _cpfController = TextEditingController();
  TextEditingController _nickNameController = TextEditingController();
  TextEditingController _departmentController = TextEditingController();
  TextEditingController _picturePathControler = TextEditingController();

  FocusNode? _emailFocus;
  FocusNode? _userNameFocus;
  FocusNode? _phoneNumberFocus;
  FocusNode? _birthDateFocus;
  FocusNode? _cpfFocus;
  FocusNode? _nickNameFocus;
  FocusNode? _departmentFocus;

  var phoneFormat = new MaskTextInputFormatter(mask: '(##) #####-####');
  var cpfFormat = new MaskTextInputFormatter(mask: '###.###.###-##');
  var dateFormat = new MaskTextInputFormatter(mask: '##/##/####');

  PhoneType? _phoneType = PhoneType.cellphone;

  @override
  void initState() {
    _emailFocus = FocusNode();
    _registration = Utils.getDateTimeNow(cDate.FORMAT_SLASH_DD_MM_YYYY_KK_MM);
    _userNameFocus = FocusNode();
    _cpfFocus = FocusNode();
    _phoneNumberFocus = FocusNode();
    _birthDateFocus = FocusNode();
    _nickNameFocus = FocusNode();
    _departmentFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _emailFocus!.dispose();
    _userNameFocus!.dispose();
    _cpfFocus!.dispose();
    _phoneNumberFocus!.dispose();
    _birthDateFocus!.dispose();
    _nickNameFocus!.dispose();
    _departmentFocus!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? title = AppLocalizations.of(context)!.registroDeVeiculo;

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
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: TextField(
                      controller: _userNameControler,
                      autofocus: true,
                      focusNode: _userNameFocus,
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: AppLocalizations.of(context)!.nomeCompleto +
                              AppLocalizations.of(context)!.obr,
                          filled: true,
                          fillColor: APP_TEXT_FIELD_BACKGROUND,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(radiusBorder!))),
                    ),
                  ),
                )
              ],
            ),
            Row(children: [
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _emailControler,
                  autofocus: true,
                  focusNode: _emailFocus,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: AppLocalizations.of(context)!.email +
                          AppLocalizations.of(context)!.obr,
                      filled: true,
                      fillColor: APP_TEXT_FIELD_BACKGROUND,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(radiusBorder!))),
                ),
              ))
            ]),
            Row(children: [
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _nickNameController,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.text,
                  focusNode: _nickNameFocus,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: AppLocalizations.of(context)!.apelido +
                          AppLocalizations.of(context)!.obr,
                      filled: true,
                      fillColor: APP_TEXT_FIELD_BACKGROUND,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(radiusBorder!))),
                ),
              ))
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: TextField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.number,
                    focusNode: _phoneNumberFocus,
                    inputFormatters: [phoneFormat],
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: AppLocalizations.of(context)!.telefone +
                            AppLocalizations.of(context)!.obr,
                        filled: true,
                        fillColor: APP_TEXT_FIELD_BACKGROUND,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(radiusBorder!))),
                  ),
                )),
                Column(children: [
                  Row(
                    children: [
                      Radio<PhoneType>(
                          value: PhoneType.cellphone,
                          groupValue: _phoneType,
                          onChanged: (PhoneType? value) {
                            setState(() {
                              _phoneType = value;
                              phoneFormat = new MaskTextInputFormatter(
                                  mask: '(##) #####-####');
                              _phoneNumberController.clear();
                            });
                          }),
                      Icon(
                        Icons.phone_android,
                        color: APP_BAR_BACKGROUND_COLOR,
                        size: 26.0,
                      ),
                    ],
                  ),
                  Row(children: [
                    Radio<PhoneType>(
                        value: PhoneType.home,
                        groupValue: _phoneType,
                        onChanged: (PhoneType? value) {
                          setState(() {
                            _phoneType = value;
                            phoneFormat = new MaskTextInputFormatter(
                                mask: '(##) ####-####');
                            _phoneNumberController.clear();
                          });
                        }),
                    Icon(
                      Icons.house,
                      color: APP_BAR_BACKGROUND_COLOR,
                      size: 26.0,
                    ),
                  ]),
                ])
              ],
            ),
            Row(children: [
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: TextField(
                  controller: _birthDateController,
                  keyboardType: TextInputType.datetime,
                  textAlign: TextAlign.center,
                  focusNode: _birthDateFocus,
                  readOnly: true,
                  inputFormatters: [dateFormat],
                  onTap: () {
                    pickBirthDate();
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      filled: true,
                      hintText: "Data de nascimento*",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              cStyles.RADIUS_BORDER_TEXT_FIELD))),
                ),
              ))
            ]),
            Row(children: [
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: TextField(
                  controller: _cpfController,
                  keyboardType: TextInputType.number,
                  focusNode: _cpfFocus,
                  inputFormatters: [cpfFormat],
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      filled: true,
                      hintText: "CPF*",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              cStyles.RADIUS_BORDER_TEXT_FIELD))),
                ),
              ))
            ]),
            Row(children: [
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: TextField(
                  controller: _departmentController,
                  keyboardType: TextInputType.text,
                  focusNode: _departmentFocus,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      filled: true,
                      hintText: "Departamento*",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              cStyles.RADIUS_BORDER_TEXT_FIELD))),
                ),
              ))
            ]),
            Padding(
              padding: EdgeInsets.all(20),
              child: ElevatedButton(
                style: TextButton.styleFrom(
                    backgroundColor: APP_BAR_BACKGROUND_COLOR,
                    padding: EdgeInsets.fromLTRB(28, 16, 28, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                child: Text(
                  "Continuar",
                  style: (TextStyle(color: APP_WHITE_FONT, fontSize: 20)),
                ),
                onPressed: () {
                  saveUser();
                },
              ),
            )
          ],
        ),
      )),
    );
  }

  void saveUser() {
    eUser u = eUser.full(
        _userNameControler.text.trim(),
        _emailControler.text.trim(),
        _phoneNumberController.text.trim(),
        _birthDateController.text.trim(),
        _cpfController.text.trim(),
        _nickNameController.text.trim(),
        _departmentController.text.trim(),
        "",
        Timestamp.now(),
        "0",
        "0",
        "",
        "");

    if (checkFields()) {
      Navigator.pushNamed(context, cRoutes.REGISTER_USER_PICTURE, arguments: u);
    }
  }

  bool checkFields() {
    if (!hasValue(_userNameControler.text.trim())) {
      Utils.showDialogBox(
          AppLocalizations.of(context)!.informeONomeCompletoDoUsuario, context);
      _userNameFocus!.requestFocus();
      return false;
    }

    var array = _userNameControler.text.trim().split(" ");
    if (array.length < 2) {
      Utils.showDialogBox(
          AppLocalizations.of(context)!.informeONomeCompletoDoUsuario, context);
      _userNameFocus!.requestFocus();
      return false;
    }

    if (!hasValue(_emailControler.text.trim())) {
      Utils.showDialogBox(
          AppLocalizations.of(context)!.informeOEmailDoUsuario, context);
      _emailFocus!.requestFocus();
      return false;
    }

    if (!hasValue(_nickNameController.text.trim())) {
      Utils.showDialogBox(
          AppLocalizations.of(context)!.informeOApelidoDoUsuario, context);
      _nickNameFocus!.requestFocus();
      return false;
    }

    if (!hasValue(_phoneNumberController.text.trim())) {
      Utils.showDialogBox(
          AppLocalizations.of(context)!.informeOTelefoneDoUsuario, context);
      _phoneNumberFocus!.requestFocus();
      return false;
    }

    if (!hasValue(_birthDateController.text.trim())) {
      Utils.showDialogBox(
          AppLocalizations.of(context)!.informeADataDeNascimentoDoUsuario,
          context);
      _birthDateFocus!.requestFocus();
      return false;
    }

    if (!hasValue(_cpfController.text.trim())) {
      Utils.showDialogBox(
          AppLocalizations.of(context)!.informeOCpfDoUsuario, context);
      _cpfFocus!.requestFocus();
      return false;
    }

    if (!hasValue(_departmentController.text.trim())) {
      Utils.showDialogBox(
          AppLocalizations.of(context)!.informeODepartamentoDoUsuario, context);
      _departmentFocus!.requestFocus();
      return false;
    }

    return true;
  }

  void goToPhones() {}

  hasValue(str) {
    return Utils.hasValue(str);
  }

  void pickBirthDate() {
    DateTime dateNow = DateTime.now();

    if (Utils.hasValue(_birthDateController.text))
      dateNow = Utils.getDateTimeFromString(_birthDateController.text);

    showDatePicker(
            context: context,
            initialDate: dateNow,
            firstDate: DateTime(0),
            lastDate: DateTime(3000))
        .then((value) => {
              _birthDateController.text = Utils.getFormatedStringFromDateTime(
                  value!, cDate.FORMAT_SLASH_DD_MM_YYYY)!
            });
  }
}