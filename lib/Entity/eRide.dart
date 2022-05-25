import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Entity/eVehicle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'eEvent.dart';

class eRide {

  String _uid = "";
  String? _codEvent;
  String? _codVehicle;
  String? _departureAddress;
  String? _returnAddress;
  String? _departureDate;
  String? _returnDate;
  String? _departureTime;
  String? _returnTime;
  Timestamp? _registerDate;
  String? _driverId;
  String? _driverName;
  int? _qttSeats;
  int? _qttLuggages;
  int? _situation;

  String get uid => _uid;
  String get codEvent => _codEvent!;
  String get codVehicle => _codVehicle!;
  String get departureAddress => _departureAddress!;
  String get returnAddress => _returnAddress!;
  String get departureDate => _departureDate!;
  String get returnDate => _returnDate!;
  String get departureTime => _departureTime!;
  String get returnTime => _returnTime!;
  Timestamp get registerDate => _registerDate!;
  String get driverId => _driverId!;
  String get driverName => _driverName!;
  int get qttSeats => _qttSeats!;
  int get qttLuggages => _qttLuggages!;
  int get situation => _situation!;


  Map<String, dynamic> toMap() {
    return {
      DbData.COLUMN_DEPARTURE_ADDRESS: this.departureAddress,
      DbData.COLUMN_RETURN_ADDRESS: this.returnAddress,
      DbData.COLUMN_DEPARTURE_DATE: this.departureDate,
      DbData.COLUMN_RETURN_DATE: this.returnDate,
      DbData.COLUMN_DEPARTURE_TIME: this.departureTime,
      DbData.COLUMN_RETURN_TIME: this.returnTime,
      DbData.COLUMN_REGISTRATION_DATE: this.registerDate,
      DbData.COLUMN_DRIVER_ID: this.driverId,
      DbData.COLUMN_DRIVER_NAME: this.driverName,
      DbData.COLUMN_COD_EVENT: this.codEvent,
      DbData.COLUMN_COD_VEHICLE: this.codVehicle,
      DbData.COLUMN_QTT_SEATS: this.qttSeats,
      DbData.COLUMN_QTT_LUGGAGES: this.qttLuggages,
      DbData.COLUMN_SITUATION: this.situation
    };
  }

  void docToRide(DocumentSnapshot ride) {
    this.uid = ride.id;
    this.departureAddress = ride[DbData.COLUMN_DEPARTURE_ADDRESS];
    this.returnAddress = ride[DbData.COLUMN_RETURN_ADDRESS];
    this.departureDate = ride[DbData.COLUMN_DEPARTURE_DATE];
    this.returnDate = ride[DbData.COLUMN_RETURN_DATE];
    this.departureTime = ride[DbData.COLUMN_DEPARTURE_TIME];
    this.returnTime = ride[DbData.COLUMN_RETURN_TIME];
    this.registerDate = ride[DbData.COLUMN_REGISTRATION_DATE];
    this.driverId = ride[DbData.COLUMN_DRIVER_ID];
    this.driverName = ride[DbData.COLUMN_DRIVER_NAME];
    this.codVehicle = ride[DbData.COLUMN_COD_VEHICLE];
    this.codEvent = ride[DbData.COLUMN_COD_EVENT];
    this.qttSeats = ride[DbData.COLUMN_QTT_SEATS];
    this.qttLuggages = ride[DbData.COLUMN_QTT_LUGGAGES];
    this.situation =  ride[DbData.COLUMN_SITUATION];
  }

  set uid(String value) {
    _uid = value;
  }

  set codEvent(String value) {
    _codEvent = value;
  }

  set codVehicle(String value) {
    _codVehicle = value;
  }

  set departureAddress(String value) {
    _departureAddress = value;
  }

  set departureDate(String value) {
    _departureDate = value;
  }

  set returnTime(String value) {
    _returnTime = value;
  }

  set departureTime(String value) {
    _departureTime = value;
  }

  set returnDate(String value) {
    _returnDate = value;
  }

  set registerDate(Timestamp value) {
    _registerDate = value;
  }

  set returnAddress(String value) {
    _returnAddress = value;
  }

  set driverId(String value) {
    _driverId = value;
  }

  set driverName(String value) {
    _driverName = value;
  }
  set qttLuggages(int value) {
    _qttLuggages = value;
  }

  set qttSeats(int value) {
    _qttSeats = value;
  }
  set situation(int value) {
    _situation = value;
  }
}
