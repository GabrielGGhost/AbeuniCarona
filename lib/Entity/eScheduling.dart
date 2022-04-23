import 'package:abeuni_carona/Constants/DbData.dart';

import 'eRide.dart';

class eScheduling {
  String? _rideId;
  String? _reservedSeats;
  String? _reservedLugagges;

  String get rideId => _rideId!;
  String get reservedSeats => _reservedSeats!;
  String get reservedLugagges => _reservedLugagges!;

  eScheduling.full(this._rideId, this._reservedSeats, this._reservedLugagges);

  Map<String, dynamic> toMap() {
    return {
      DbData.COLUMN_RIDE_ID: rideId,
      DbData.COLUMN_RESERVED_SEATS: reservedSeats,
      DbData.COLUMN_RESERVED_LUGGAGES: reservedLugagges
    };
  }

  set rideId(String value) {
    _rideId = value;
  }

  set reservedSeats(String value) {
    _reservedSeats = value;
  }

  set reservedLugagges(String value) {
    _reservedLugagges = value;
  }
}
