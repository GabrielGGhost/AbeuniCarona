import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Entity/eVehicle.dart';

import 'eEvent.dart';

class eRide {
  eEvent? _event;
  eVehicle? _vehicle;
  String? _departureAddress;
  String? _returnAddress;
  String? _departureDate;
  String? _returnDate;
  String? _departureTime;
  String? _returnTime;


  set returnAddress(String value) {
    _returnAddress = value;
  }

  eEvent get event => _event!;
  eVehicle get vehicle => _vehicle!;
  String get departureAddress => _departureAddress!;
  String get returnAddress => _returnAddress!;
  String get departureDate => _departureDate!;
  String get returnDate => _returnDate!;
  String get departureTime => _departureTime!;
  String get returnTime => _returnTime!;

  Map<String, dynamic> toMap(){
    return {
      DbData.COLUMN_DEPARTURE_ADDRESS : this.departureAddress,
      DbData.COLUMN_RETURN_ADDRESS : this.returnAddress,
      DbData.COLUMN_DEPARTURE_DATE : this.departureDate,
      DbData.COLUMN_RETURN_DATE : this.returnDate,
      DbData.COLUMN_DEPARTURE_TIME : this.departureTime,
      DbData.COLUMN_RETURN_TIME : this.returnTime,
      DbData.COLUMN_EVENT : this.event.toMap(),
      DbData.COLUMN_VEHICLE : this.vehicle.toMap()
    };
  }

  set departureAddress(String value) {
    _departureAddress = value;
  }
  set event(eEvent value) {
    _event = value;
  }
  set vehicle(eVehicle value) {
    _vehicle = value;
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
}
