import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'package:abeuni_carona/Entity/eUser.dart';
import 'package:abeuni_carona/Entity/eVehicle.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  TextEditingController _departamentoController = TextEditingController();
  TextEditingController _picturePathControler = TextEditingController();

  FocusNode? _emailFocus;
  FocusNode? _userNameFocus;
  FocusNode? _phoneNumberFocus;
  FocusNode? _birthDateFocus;
  FocusNode? _cpfFocus;
  FocusNode? _nickNameFocus;
  FocusNode? _departamentoFocus;

  var timeFormat = new MaskTextInputFormatter(mask: 'HH:mm');
  var dateFormat = new MaskTextInputFormatter(mask: 'dd/MM/yyyy');

  @override
  void initState() {
    _emailFocus = FocusNode();
    _registration = Utils.getDateTimeNow(cDate.FORMAT_SLASH_DD_MM_YYYY_KK_MM);
    _userNameFocus = FocusNode();
    _cpfFocus = FocusNode();
    _phoneNumberFocus = FocusNode();
    _birthDateFocus = FocusNode();
    _nickNameFocus = FocusNode();
    _departamentoFocus = FocusNode();
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
    _departamentoFocus!.dispose();
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
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: TextField(
                    controller: _userNameControler,
                    autofocus: true,
                    focusNode: _userNameFocus,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: AppLocalizations.of(context)!.nomeCompleto + AppLocalizations.of(context)!.obr,
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
                    controller: _emailControler,
                    autofocus: true,
                    focusNode: _emailFocus,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: AppLocalizations.of(context)!.email + AppLocalizations.of(context)!.obr,
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
                    controller: _nickNameController,
                    keyboardType: TextInputType.text,
                    focusNode: _nickNameFocus,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: AppLocalizations.of(context)!.apelido + AppLocalizations.of(context)!.obr,
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
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.text,
                    focusNode: _phoneNumberFocus,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: AppLocalizations.of(context)!.telefone + AppLocalizations.of(context)!.obr,
                        filled: true,
                        fillColor: APP_TEXT_FIELD_BACKGROUND,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(radiusBorder!)
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top : 10),
                  child: TextField(
                    controller: _birthDateController,
                    keyboardType: TextInputType.datetime,
                    textAlign: TextAlign.center,
                    focusNode: _birthDateFocus,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        filled: true,
                        hintText: "Data de nascimento*",
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(cStyles.RADIUS_BORDER_TEXT_FIELD)
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top : 10),
                  child: TextField(
                    controller: _cpfController,
                    keyboardType: TextInputType.number,
                    focusNode: _cpfFocus,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        filled: true,
                        hintText: "CPF*",
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(cStyles.RADIUS_BORDER_TEXT_FIELD)
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top : 10),
                  child: TextField(
                    controller: _departamentoController,
                    keyboardType: TextInputType.text,
                    focusNode: _departamentoFocus,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        filled: true,
                        hintText: "Departamento*",
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(cStyles.RADIUS_BORDER_TEXT_FIELD)
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
                      "Continuar",
                      style: (
                          TextStyle(
                              color: APP_WHITE_FONT, fontSize: 20
                          )
                      ),
                    ),
                    onPressed: (){

                      saveUser();
                    },
                  ),
                )
              ],
            ),
          )
      ),
    );
  }

  void saveUser() {
    eUser u = eUser.full(_userNameControler.text,
        _emailControler.text,
        _phoneNumberController.text,
        _birthDateController.text,
        _cpfController.text,
        _nickNameController.text,
        "",
        _registration,
        "");

    eUser? userLoged = null;

    if(userLoged == null) {

      if(checkFields()){
        Navigator.pushNamed(
            context,
            cRoutes.REGISTER_USER_PICTURE,
            arguments: u
        );
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

    if(_userNameControler.text.length == 0){

      Utils.showDialogBox(AppLocalizations.of(context)!.informeONomeCompletoDoUsuario, context);
      _userNameFocus!.requestFocus();
      return false;
    }

    var array = _userNameControler.text.trim().split(" ");
    if(array.length < 2){

      Utils.showDialogBox(AppLocalizations.of(context)!.informeONomeCompletoDoUsuario, context);
      _userNameFocus!.requestFocus();
      return false;
    }

    if(_emailControler.text.trim().length == 0){

      Utils.showDialogBox("Informe o email do usuári.", context);
      _emailFocus!.requestFocus();
      return false;
    }

    if(_nickNameController.text.trim().length == 0){

      Utils.showDialogBox("Informe o apelido do usuário", context);
      _nickNameFocus!.requestFocus();
      return false;
    }

    if(_phoneNumberController.text.trim().length == 0){

      Utils.showDialogBox("Informe o telefone do usuário", context);
      _phoneNumberFocus!.requestFocus();
      return false;
    }

    if(_birthDateController.text.trim().length == 0){

      Utils.showDialogBox("Informe a data de nascimento do usuário.", context);
      _birthDateFocus!.requestFocus();
      return false;
    }

    if(_cpfController.text.trim().length == 0){

      Utils.showDialogBox("Informe o cpf do usuário.", context);
      _cpfFocus!.requestFocus();
      return false;
    }

    if(_departamentoController.text.trim().length == 0){

      Utils.showDialogBox("Informe o departamento do usuário.", context);
      _departamentoFocus!.requestFocus();
      return false;
    }

    return true;
  }

  void goToPhones() {}
}
