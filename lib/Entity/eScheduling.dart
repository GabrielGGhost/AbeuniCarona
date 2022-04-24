import 'package:abeuni_carona/Constants/DbData.dart';

import 'eRide.dart';

class eScheduling {
  String? _rideId;
  String? _partakerId;
  String? _reservedSeats;
  String? _reservedLugagges;
  String? _registrationDate;

  String get partakerId => _partakerId!;
  String get rideId => _rideId!;
  String get reservedSeats => _reservedSeats!;
  String get reservedLugagges => _reservedLugagges!;
  String get registrationDate => _registrationDate!;

  eScheduling.full(this._rideId, this._partakerId, this._reservedSeats,
      this._reservedLugagges);

  Map<String, dynamic> toMap() {
    return {
      DbData.COLUMN_RIDE_ID: rideId,
      DbData.COLUMN_PARTAKER_ID: partakerId,
      DbData.COLUMN_RESERVED_SEATS: reservedSeats,
      DbData.COLUMN_RESERVED_LUGGAGES: reservedLugagges,
      DbData.COLUMN_REGISTRATION_DATE: registrationDate
    };
  }

  set rideId(String value) {
    _rideId = value;
  }

  set partakerId(String value) {
    _partakerId = value;
  }

  set reservedSeats(String value) {
    _reservedSeats = value;
  }

  set reservedLugagges(String value) {
    _reservedLugagges = value;
  }

  set registrationDate(String value) {
    _registrationDate = value;
  }
}
