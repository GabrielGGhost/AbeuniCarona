import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Entity/eScheduling.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'eRide.dart';

class eSchedulingHistory {
  int? _situation;
  String? _rideId;
  String? _userId;
  Timestamp? _registerDate;

  eSchedulingHistory.empty();
  eSchedulingHistory.full(this._situation, this._rideId, this._userId);
  eSchedulingHistory.updateHistories(this._rideId);


  Map<String, dynamic> toMap() {
    return {
      DbData.COLUMN_SITUATION: this.situation,
      DbData.COLUMN_RIDE_ID: this.rideId,
      DbData.COLUMN_USER_ID: this.userId,
      DbData.COLUMN_REGISTRATION_DATE: this.registerDate};
  }

  String get rideId => _rideId!;
  int get situation => _situation!;
  String get userId => _userId!;
  Timestamp get registerDate => _registerDate!;

  set userId(String value) {
    _userId = value;
  }

  set rideId(String value) {
    _rideId = value;
  }

  set situation(int value) {
    _situation = value;
  }

  set registerDate(Timestamp value) {
    _registerDate = value;
  }
}
