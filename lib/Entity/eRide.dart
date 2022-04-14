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
  String get departureDate => _departureDate!;
  String get returnTime => _returnTime!;
  String get departureTime => _departureTime!;
  String get returnDate => _returnDate!;
  String get returnAddress => _returnAddress!;

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
