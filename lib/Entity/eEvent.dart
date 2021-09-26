class eEvent {

  String? _id;
  String? _codBaseEvent;
  String? _location;
  String? _dateEventStart;
  String? _dateEventEnd;
  String? _dateRegisterStart;
  String? _dateRegisterEnd;
  String? _obsEvent;

  static List<eEvent> getEvents(){
    return <eEvent> [
      eEvent("1", "3", "Localização A", "01/10/2021", "10/10/2021","xx-xx-xxxx", "xx-xx-xxxx", "teste teste teste"),
      eEvent("2", "2", "Localização B", "xx-xx-xxxx", "xx-xx-xxxx","xx-xx-xxxx", "xx-xx-xxxx","teste teste teste"),
      eEvent("3", "1", "Localização C", "xx-xx-xxxx", "xx-xx-xxxx","xx-xx-xxxx", "xx-xx-xxxx", "teste teste teste"),
      eEvent("4", "1", "Localização D", "xx-xx-xxxx", "xx-xx-xxxx","xx-xx-xxxx", "xx-xx-xxxx", "teste teste teste"),
    ];
  }

  eEvent(
      this._id,
      this._codBaseEvent,
      this._location,
      this._dateEventStart,
      this._dateEventEnd,
      this._dateRegisterStart,
      this._dateRegisterEnd,
      this._obsEvent);

  String get codEvent => _id!;
  String get location => _location!;
  String get obsEvent => _obsEvent!;
  String get dateRegisterEnd => _dateRegisterEnd!;
  String get dateRegisterStart => _dateRegisterStart!;
  String get dateEventEnd => _dateEventEnd!;
  String get dateEventStart => _dateEventStart!;
  String get codBaseEvent => _codBaseEvent!;



  set codEvent(String value) {
    _id = value;
  }
  set obsEvent(String value) {
    _obsEvent = value;
  }
  set dateRegisterEnd(String value) {
    _dateRegisterEnd = value;
  }
  set dateRegisterStart(String value) {
    _dateRegisterStart = value;
  }
  set dateEventEnd(String value) {
    _dateEventEnd = value;
  }
  set dateEventStart(String value) {
    _dateEventStart = value;
  }
  set location(String value) {
    _location = value;
  }
  set codBaseEvent(String value) {
    _codBaseEvent = value;
  }
}