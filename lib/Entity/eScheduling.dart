import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'eRide.dart';

class eScheduling {
  String _uid = "";
  String? _rideId;
  String? _partakerId;
  String? _reservedSeats;
  String? _reservedLugagges;
  Timestamp? _registrationDate;

  String get uid => _uid;
  String get partakerId => _partakerId!;
  String get rideId => _rideId!;
  String get reservedSeats => _reservedSeats!;
  String get reservedLugagges => _reservedLugagges!;
  Timestamp get registrationDate => _registrationDate!;

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

  set registrationDate(Timestamp value) {
    _registrationDate = value;
  }
  set uid(String value) {
    _uid = value;
  }
}
