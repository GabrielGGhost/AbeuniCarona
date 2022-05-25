import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:abeuni_carona/Entity/eEvent.dart';
import 'package:abeuni_carona/Entity/eRide.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'package:abeuni_carona/Constants/cDate.dart';

class RideRegister_4 extends StatefulWidget {
  eRide ride;
  bool edit;
  RideRegister_4(this.ride, this.edit);

  @override
  _RideRegister_4State createState() => _RideRegister_4State();
}

FirebaseFirestore db = FirebaseFirestore.instance;

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

  @override
  Widget build(BuildContext context) {
    eRide? ride = widget.ride;
    edit = widget.edit;

    if (edit) {
      _departureAddressController.text = ride.departureAddress;
      _departureDateController.text = ride.departureDate;
      _departureTimeController.text = ride.departureTime;
      _returnAddressController.text = ride.returnAddress;
      _returnDateController.text = ride.returnDate;
      _returnTimeController.text = ride.returnTime;
    }

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
              Row(
                children: [
                  Expanded(child: FutureBuilder(
                    future: findEventByID(ride.codEvent),
                      builder: (_, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Erro ao carregar dados",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey));
                    } else if (!snapshot.hasData) {
                      return Text("Evento Excluído");
                    } else {
                      eEvent event = snapshot.data as eEvent;
                      return RichText(
                        text: TextSpan(
                            style: TextStyle(fontSize: 18, color: Colors.black),
                            children: [
                              TextSpan(
                                text: "Localização do evento: ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                  text: event.location,
                                  style: TextStyle(color: Colors.grey))
                            ]),
                      );
                    }
                  }))
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "Dados de Partida",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: TextField(
                  controller: _departureAddressController,
                  keyboardType: TextInputType.text,
                  focusNode: _departureAddressFocus,
                  textCapitalization: TextCapitalization.words,
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
                            padding: EdgeInsets.only(right: 10, top: 10),
                            child: TextField(
                              controller: _departureDateController,
                              readOnly: true,
                              keyboardType: TextInputType.datetime,
                              focusNode: _departureDateFocus,
                              textAlign: TextAlign.center,
                              onTap: () {
                                _pickDepartureDate();
                              },
                              inputFormatters: [dateFormat],
                              decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.fromLTRB(32, 16, 32, 16),
                                  filled: true,
                                  hintText: "Data",
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
                            padding: EdgeInsets.only(right: 10, top: 10),
                            child: TextField(
                              controller: _departureTimeController,
                              readOnly: true,
                              onTap: () {
                                _pickDepartureTime();
                              },
                              keyboardType: TextInputType.datetime,
                              focusNode: _departureTimeFocus,
                              textAlign: TextAlign.center,
                              inputFormatters: [timeFormat],
                              decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.fromLTRB(32, 16, 32, 16),
                                  filled: true,
                                  hintText: "Horário",
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
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text(
                      "Dados de Retorno",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: TextField(
                  controller: _returnAddressController,
                  keyboardType: TextInputType.text,
                  focusNode: _returnAddressFocus,
                  textCapitalization: TextCapitalization.words,
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
                            padding: EdgeInsets.only(right: 10, top: 10),
                            child: TextField(
                              controller: _returnDateController,
                              readOnly: true,
                              onTap: () {
                                _pickReturnDate();
                              },
                              keyboardType: TextInputType.datetime,
                              focusNode: _returnDateFocus,
                              textAlign: TextAlign.center,
                              inputFormatters: [dateFormat],
                              decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.fromLTRB(32, 16, 32, 16),
                                  filled: true,
                                  hintText: "Data",
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
                            padding: EdgeInsets.only(right: 10, top: 10),
                            child: TextField(
                              controller: _returnTimeController,
                              readOnly: true,
                              onTap: () {
                                _pickReturnTime();
                              },
                              keyboardType: TextInputType.datetime,
                              focusNode: _returnTimeFocus,
                              textAlign: TextAlign.center,
                              inputFormatters: [timeFormat],
                              decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.fromLTRB(32, 16, 32, 16),
                                  filled: true,
                                  hintText: "Horário",
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

  void _changeReturnLabels() {}

  void _pickDepartureDate() {
    DateTime dateNow = DateTime.now();

    if (Utils.hasValue(_departureDateController.text))
      dateNow = Utils.getDateTimeFromString(_departureDateController.text);

    showDatePicker(
            context: context,
            initialDate: dateNow,
            firstDate: DateTime.now(),
            lastDate: DateTime(3000))
        .then((value) => {checkDates(value), _checkTimes()});
  }

  void _pickReturnDate() {
    DateTime dateNow =
        Utils.getDateTimeFromString(_departureDateController.text);

    if (Utils.hasValue(_returnDateController.text))
      dateNow = Utils.getDateTimeFromString(_returnDateController.text);

    showDatePicker(
            context: context,
            initialDate: dateNow,
            firstDate:
                Utils.getDateTimeFromString(_departureDateController.text),
            lastDate: DateTime(3000))
        .then((value) => {
              _returnDateController.text = Utils.getFormatedStringFromDateTime(
                  value!, cDate.FORMAT_SLASH_DD_MM_YYYY)!,
              _checkTimes()
            });
  }

  checkDates(DateTime? value) {
    print("definindo valores");
    _departureDateController.text = Utils.getFormatedStringFromDateTime(
        value!, cDate.FORMAT_SLASH_DD_MM_YYYY)!;

    DateTime endDate = Utils.getDateTimeFromString(_returnDateController.text);

    if (value.millisecondsSinceEpoch > endDate.millisecondsSinceEpoch) {
      _returnDateController.text = "";
    }
  }

  void _pickDepartureTime() {
    TimeOfDay time = TimeOfDay.now();

    showTimePicker(context: context, initialTime: time).then((value) => {
          _departureTimeController.text =
              Utils.getStringTimeFromInts(value!.hour, value.minute),
          _checkTimes()
        });
  }

  void _pickReturnTime() {
    TimeOfDay time = TimeOfDay.now();

    showTimePicker(context: context, initialTime: time).then((value) => {
          _returnTimeController.text =
              Utils.getStringTimeFromInts(value!.hour, value.minute),
          _checkTimes()
        });
  }

  _checkTimes() {
    if (Utils.hasValue(_departureDateController.text) &&
        Utils.hasValue(_departureTimeController.text) &&
        Utils.hasValue(_returnDateController.text) &&
        Utils.hasValue(_returnTimeController.text)) {
      if (!Utils.isReturnDateValid(
          _departureDateController.text,
          _departureTimeController.text,
          _returnDateController.text,
          _returnTimeController.text)) {
        _returnTimeController.text = "";
      }
    }
  }

  Future<eEvent> findEventByID(codEvent) async {
    DocumentSnapshot result =
        await db.collection(DbData.TABLE_EVENT).doc(codEvent).get();

    eEvent event = eEvent.doc(result);
    return event;
  }
}
