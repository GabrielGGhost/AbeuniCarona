import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class eEvent {

  bool? _done;
  String? _codEvent;
  String? _codBaseEvent;
  String? _location;
  String? _userId;
  String? _obsEvent;
  Timestamp? _dateEventStart;
  Timestamp? _dateEventEnd;
  Timestamp? _registrationDate;


  set userId(String value) {
    _userId = value;
  }

  Map<String, dynamic> toMap() {
    return {
      DbData.COLUMN_COD_BASE_EVENT: this._codBaseEvent,
      DbData.COLUMN_LOCATION: this._location,
      DbData.COLUMN_START_DATE: this._dateEventStart,
      DbData.COLUMN_END_DATE: this._dateEventEnd,
      DbData.COLUMN_OBS: this._obsEvent,
      DbData.COLUMN_REGISTRATION_DATE: this._registrationDate,
      DbData.COLUMN_DONE: this._done,
      DbData.COLUMN_USER_ID: this.userId
    };
  }

  docToEntity(event) {
      this._codBaseEvent = event[DbData.COLUMN_COD_BASE_EVENT];
      this._location = event[DbData.COLUMN_LOCATION ];
      this._dateEventStart = event[DbData.COLUMN_START_DATE];
      this._dateEventEnd = event[DbData.COLUMN_END_DATE];
      this._obsEvent = event[DbData.COLUMN_OBS];
      this._registrationDate = event[DbData.COLUMN_REGISTRATION_DATE];
      this._done = event[DbData.COLUMN_DONE];
      this._userId = event[DbData.COLUMN_USER_ID];
  }

  eEvent.empty();

  eEvent.doc(codEvent){
    docToEntity(codEvent);
  }

  eEvent(
      this._codEvent,
      this._codBaseEvent,
      this._location,
      this._dateEventStart,
      this._dateEventEnd,
      this._obsEvent,
      this._registrationDate,
      this._done);

  bool get done => _done!;
  String get codEvent => _codEvent!;
  String get location => _location!;
  String get userId => _userId!;
  String get obsEvent => _obsEvent!;
  String get descBaseEvent => _codBaseEvent!;
  Timestamp get registrationDate => _registrationDate!;
  Timestamp get dateEventEnd => _dateEventEnd!;
  Timestamp get dateEventStart => _dateEventStart!;
  String get codBaseEvent => _codBaseEvent!;

  set codEvent(String value) {
    _codEvent = value;
  }
  set obsEvent(String value) {
    _obsEvent = value;
  }
  set dateEventEnd(Timestamp value) {
    _dateEventEnd = value;
  }
  set dateEventStart(Timestamp value) {
    _dateEventStart = value;
  }
  set location(String value) {
    _location = value;
  }
  set registrationDate(Timestamp value) {
    _registrationDate = value;
  }
  set codBaseEvent(String value) {
    _codBaseEvent = value;
  }
  set done(bool value) {
    _done = value;
  }
}