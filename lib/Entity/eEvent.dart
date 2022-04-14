import 'package:abeuni_carona/Constants/DbData.dart';

class eEvent {

  String? _codEvent;
  String? _descBaseEvent;
  String? _location;
  String? _dateEventStart;
  String? _dateEventEnd;
  String? _obsEvent;
  String? _registrationDate;

  Map<String, dynamic> toMap() {
    return {
      DbData.COLUMN_EVENT_DESC_BASE_EVENT: this._descBaseEvent,
      DbData.COLUMN_LOCATION: this._location,
      DbData.COLUMN_START_DATE: this._dateEventStart,
      DbData.COLUMN_END_DATE: this._dateEventEnd,
      DbData.COLUMN_OBS: this._obsEvent,
      DbData.COLUMN_REGISTRATION_DATE: this._registrationDate
    };
  }

  eEvent(
      this._codEvent,
      this._descBaseEvent,
      this._location,
      this._dateEventStart,
      this._dateEventEnd,
      this._obsEvent,
      this._registrationDate);

  String get codEvent => _codEvent!;
  String get location => _location!;
  String get obsEvent => _obsEvent!;
  String get dateEventEnd => _dateEventEnd!;
  String get dateEventStart => _dateEventStart!;
  String get registrationDate => _registrationDate!;
  String get descBaseEvent => _descBaseEvent!;

  set codEvent(String value) {
    _codEvent = value;
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
  set registrationDate(String value) {
    _registrationDate = value;
  }
  set descBaseEvent(String value) {
    _descBaseEvent = value;
  }
}