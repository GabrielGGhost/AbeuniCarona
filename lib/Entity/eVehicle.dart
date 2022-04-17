import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class eVehicle {
  String? _id;
  String? _sign;
  String? _color;
  String? _model;
  String? _seats;
  String? _luggageSpaces;
  String? _registrationDate;
  String? _idOwner;
  bool? _active;




  String get id => _id!;
  String get luggageSpaces => _luggageSpaces!;
  String get seats => _seats!;
  String get model => _model!;
  String get color => _color!;
  String get sign => _sign!;
  String get registrationDate => _registrationDate!;
  String get idOwner => _idOwner!;
  bool get active => _active!;

  eVehicle.empty(){}

  eVehicle(this._id, this._sign, this._color, this._model, this._seats,
      this._luggageSpaces, this._registrationDate, this._idOwner, this._active);

  Map<String, dynamic> toMap() {
    return {
      DbData.COLUMN_SIGN: this._sign,
      DbData.COLUMN_COLOR: this._color,
      DbData.COLUMN_MODEL: this._model,
      DbData.COLUMN_SEATS: this._seats,
      DbData.COLUMN_LUGGAGE_SPACES: this._luggageSpaces,
      DbData.COLUMN_REGISTRATION_DATE: this._registrationDate,
      DbData.COLUMN_ID_OWNER: this._idOwner,
      DbData.COLUMN_ACTIVE : this._active
    };
  }

  void docToEntity(vehicle) {
    this._sign = vehicle[DbData.COLUMN_SIGN];
    this._color = vehicle[DbData.COLUMN_COLOR];
    this._model = vehicle[DbData.COLUMN_MODEL];
    this._seats = vehicle[DbData.COLUMN_SEATS];
    this._luggageSpaces = vehicle[DbData.COLUMN_LUGGAGE_SPACES];
    this._registrationDate = vehicle[DbData.COLUMN_REGISTRATION_DATE];
    this._idOwner = vehicle[DbData.COLUMN_ID_OWNER];
    this._active = vehicle[DbData.COLUMN_ACTIVE];
  }

  set id(String value) {
    _id = value;
  }

  set luggageSpaces(String value) {
    _luggageSpaces = value;
  }

  set seats(String value) {
    _seats = value;
  }

  set model(String value) {
    _model = value;
  }

  set color(String value) {
    _color = value;
  }

  set sign(String value) {
    _sign = value;
  }

  set registrationDate(String value) {
    _registrationDate = value;
  }

  set idOwner(String value) {
    _idOwner = value;
  }
  set active(bool value) {
    _active = value;
  }
}
