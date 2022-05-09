import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class eEventBase{

  String? _id;
  String? _eventName;
  String? _obsEvent;
  bool _active;
  DateTime? _registerDate;

  eEventBase(this._id, this._eventName, this._obsEvent, this._active, this._registerDate);

  String get id => _id!;
  String get eventName => _eventName!;
  String get obsEvent => _obsEvent!;
  bool get active => _active;
  DateTime get registerDate => _registerDate!;


  toMap(){
    return {
      DbData.COLUMN_NAME : this._eventName,
      DbData.COLUMN_OBS : this._obsEvent,
      DbData.COLUMN_ACTIVE : this._active,
      DbData.COLUMN_REGISTRATION_DATE : this._registerDate,
    };
  }

  set id(String value) {
    _id = value;
  }
  set obsEvent(String value) {
    _obsEvent = value;
  }
  set eventName(String value) {
    _eventName = value;
  }
  set active(bool value) {
    _active = value;
  }
  set registerDate(DateTime value) {
    _registerDate = value;
  }
}