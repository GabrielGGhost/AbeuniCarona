import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:abeuni_carona/Entity/eRide.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';

class RideRegister_4 extends StatefulWidget {
  eRide ride;
  bool edit;
  RideRegister_4(this.ride, this.edit);

  @override
  _RideRegister_4State createState() => _RideRegister_4State();
}

class _RideRegister_4State extends State<RideRegister_4> {
  var timeFormat = new MaskTextInputFormatter(mask: '##:##');
  var dateFormat = new MaskTextInputFormatter(mask: '##/##/####');

  bool edit = false;

  TextEditingController _departureAddressController = TextEditingController();
  TextEditingController _returnAddressController = TextEditingController();
  TextEditingController _departureDateController = TextEditingController();
  TextEditingController _returnDateController = TextEditingController();
  TextEditingController _departureTimeController = TextEditingController();
  TextEditingController _returnTimeController = TextEditingController();

  FocusNode? _departureAddressFocus;
  FocusNode? _returnAddressFocus;
  FocusNode? _departureDateFocus;
  FocusNode? _returnDateFocus;
  FocusNode? _departureTimeFocus;
  FocusNode? _returnTimeFocus;

  @override
  void initState() {
    super.initState();
    _departureAddressFocus = FocusNode();
    _returnAddressFocus = FocusNode();
    _departureDateFocus = FocusNode();
    _returnDateFocus = FocusNode();
    _departureTimeFocus = FocusNode();
    _returnTimeFocus = FocusNode();

    _returnAddressController.addListener(_changeReturnLabels);
  }

  @override
  void dispose() {
    super.dispose();
    _departureAddressFocus!.dispose();
    _returnAddressFocus!.dispose();
    _departureDateFocus!.dispose();
    _returnDateFocus!.dispose();
    _departureTimeFocus!.dispose();
    _returnTimeFocus!.dispose();
  }

  //Labels de retorno
  String lblDateReturn = "Data de retorno";
  String lblTimeReturn = "Horário de retorno";

  @override
  Widget build(BuildContext context) {
    eRide? ride = widget.ride;
    edit = widget.edit;

    _departureAddressController.text = ride.departureAddress;
    _departureDateController.text = ride.departureDate;
    _departureTimeController.text = ride.departureTime;
    _returnAddressController.text = ride.returnAddress;
    _returnDateController.text = ride.returnDate;
    _returnTimeController.text = ride.returnTime;

    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de Carona"),
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(cStyles.PADDING_DEFAULT_SCREEN),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40),
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      children: [
                        TextSpan(
                          text: "Localização do evento: ",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                            text: ride.event.location,
                            style: TextStyle(color: Colors.grey))
                      ]),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _departureAddressController,
                  keyboardType: TextInputType.text,
                  focusNode: _departureAddressFocus,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Localização de partida*",
                      suffixIcon: Icon(Icons.gps_fixed),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              cStyles.RADIUS_BORDER_TEXT_FIELD))),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(top: 20, right: 10, bottom: 10),
                        child: Text(
                          "Data de saída*",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: TextField(
                          controller: _departureDateController,
                          keyboardType: TextInputType.datetime,
                          focusNode: _departureDateFocus,
                          textAlign: TextAlign.center,
                          inputFormatters: [dateFormat],
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(32, 16, 32, 16),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      cStyles.RADIUS_BORDER_TEXT_FIELD))),
                        ),
                      ),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(top: 20, right: 10, bottom: 10),
                        child: Text(
                          "Horário de saída*",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: TextField(
                          controller: _departureTimeController,
                          keyboardType: TextInputType.datetime,
                          focusNode: _departureTimeFocus,
                          textAlign: TextAlign.center,
                          inputFormatters: [timeFormat],
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(32, 16, 32, 16),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      cStyles.RADIUS_BORDER_TEXT_FIELD))),
                        ),
                      ),
                    ],
                  )),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: TextField(
                  controller: _returnAddressController,
                  keyboardType: TextInputType.text,
                  focusNode: _returnAddressFocus,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Localização de retorno",
                      suffixIcon: Icon(Icons.gps_fixed),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              cStyles.RADIUS_BORDER_TEXT_FIELD))),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(top: 20, right: 10, bottom: 10),
                        child: Text(
                          lblDateReturn,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: TextField(
                          controller: _returnDateController,
                          keyboardType: TextInputType.datetime,
                          focusNode: _returnDateFocus,
                          textAlign: TextAlign.center,
                          inputFormatters: [dateFormat],
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(32, 16, 32, 16),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      cStyles.RADIUS_BORDER_TEXT_FIELD))),
                        ),
                      ),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(top: 20, right: 10, bottom: 10),
                        child: Text(
                          lblTimeReturn,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: TextField(
                          controller: _returnTimeController,
                          keyboardType: TextInputType.datetime,
                          focusNode: _returnTimeFocus,
                          textAlign: TextAlign.center,
                          inputFormatters: [timeFormat],
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(32, 16, 32, 16),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      cStyles.RADIUS_BORDER_TEXT_FIELD))),
                        ),
                      ),
                    ],
                  )),
                ],
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
                nextStep(ride);
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

  void nextStep(eRide ride) {
    ride.departureAddress = _departureAddressController.text;
    ride.returnAddress = _returnAddressController.text;
    ride.departureDate = _departureDateController.text;
    ride.returnDate = _returnDateController.text;
    ride.departureTime = _departureTimeController.text;
    ride.returnTime = _returnTimeController.text;

    if (checkFields()) {
      if (edit) {
        Navigator.pop(context, ride);
      } else {
        Navigator.pushNamed(context, cRoutes.REGISTER_RIDE5, arguments: ride);
      }
    }
  }

  bool checkFields() {
    if (_departureAddressController.text.isEmpty) {
      showDialogBox("Informe a localização de partida!");
      _departureAddressFocus!.requestFocus();
      return false;
    }

    if (_departureAddressController.text.isEmpty) {
      showDialogBox("Informe a localização de partida!");
      _departureAddressFocus!.requestFocus();
      return false;
    }

    if (_departureDateController.text.isEmpty) {
      showDialogBox("Informe a data de partida!");
      _departureDateFocus!.requestFocus();
      return false;
    }

    if (!Utils.isDateValid(_departureDateController.text)) {
      showDialogBox("Data de partida inválida!");
      _departureDateFocus!.requestFocus();
      return false;
    }

    if (_departureTimeController.text.isEmpty) {
      showDialogBox("Informe o horário de partida!");
      _departureTimeFocus!.requestFocus();
      return false;
    }

    if (_returnAddressController.text.isNotEmpty) {
      if (!Utils.isDateValid(_returnDateController.text)) {
        showDialogBox("Data de retorno inválida!");
        _returnDateFocus!.requestFocus();
        return false;
      }

      if (_returnTimeController.text.isEmpty) {
        showDialogBox("Informe o horário de retorno!");
        _returnTimeFocus!.requestFocus();
        return false;
      }
    }
    return true;
  }

  void showDialogBox(msg) {
    Utils.showDialogBox(msg, context);
  }

  void _changeReturnLabels() {
    if (_returnAddressController.text.isEmpty) {
      setState(() {
        lblDateReturn = "Data de retorno";
        lblTimeReturn = "Horário de retorno";
      });
    } else {
      setState(() {
        lblDateReturn = "Data de retorno*";
        lblTimeReturn = "Horário de retorno*";
      });
    }
  }
}
