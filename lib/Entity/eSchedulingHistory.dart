import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Entity/eScheduling.dart';

import 'eRide.dart';

class eSchedulingHistory {
  String? _situation;
  String? _rideId;
  String? _userId;

  eSchedulingHistory.empty();
  eSchedulingHistory.full(this._situation, this._rideId, this._userId);
  eSchedulingHistory.updateHistories(this._rideId);


  Map<String, dynamic> toMap() {
    return {
      DbData.COLUMN_SITUATION: situation,
      DbData.COLUMN_RIDE_ID: rideId,
      DbData.COLUMN_USER_ID: userId
    };
  }

  String get rideId => _rideId!;
  String get situation => _situation!;
  String get userId => _userId!;

  set userId(String value) {
    _userId = value;
  }

  set rideId(String value) {
    _rideId = value;
  }

  set situation(String value) {
    _situation = value;
  }
}
