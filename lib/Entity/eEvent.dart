import 'package:abeuni_carona/Constants/DbData.dart';

class eEvent {

  String? _id;
  String? _codBaseEvent;
  String? _location;
  String? _dateEventStart;
  String? _dateEventEnd;
  String? _obsEvent;
  String? _registrationDate;

  static List<eEvent> getEvents(){
    return <eEvent> [
      eEvent("1", "3", "Localização A", "01/10/2021", "10/10/2021", "teste teste teste", "12/02/0222"),
      eEvent("2", "2", "Localização B", "xx-xx-xxxx", "xx-xx-xxxx", "teste teste teste", "12/02/0222"),
      eEvent("3", "1", "Localização C", "xx-xx-xxxx", "xx-xx-xxxx", "teste teste teste", "12/02/0222"),
      eEvent("4", "1", "Localização D", "xx-xx-xxxx", "xx-xx-xxxx", "teste teste teste", "12/02/0222"),
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      DbData.COLUMN_COD_BASE_EVENT: this._codBaseEvent,
      DbData.COLUMN_LOCATION: this._location,
      DbData.COLUMN_START_DATE: this._dateEventStart,
      DbData.COLUMN_END_DATE: this._dateEventEnd,
      DbData.COLUMN_OBS: this._obsEvent,
      DbData.COLUMN_REGISTRATION_DATE: this._registrationDate
    };
  }

  eEvent(
      this._id,
      this._codBaseEvent,
      this._location,
      this._dateEventStart,
      this._dateEventEnd,
      this._obsEvent,
      this._registrationDate);

  String get codEvent => _id!;
  String get location => _location!;
  String get obsEvent => _obsEvent!;
  String get dateEventEnd => _dateEventEnd!;
  String get dateEventStart => _dateEventStart!;
  String get codBaseEvent => _codBaseEvent!;
  String get registrationDate => _registrationDate!;

  set codEvent(String value) {
    _id = value;
  }
  set obsEvent(String value) {
    _obsEvent = value;
  }
  set dateEventEnd(String value) {
    _dateEventEnd = value;
  }
  set dateEventStart(String value) {
    _dateEventStart = value;
  }
  set location(String value) {
    _location = value;
  }
  set codBaseEvent(String value) {
    _codBaseEvent = value;
  }
  set registrationDate(String value) {
    _registrationDate = value;
  }
}