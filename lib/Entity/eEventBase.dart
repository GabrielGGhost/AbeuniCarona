class eEventBase{

  String? _id;
  String? _eventName;
  String? _obsEvent;

  eEventBase(this._id, this._eventName, this._obsEvent);

  String get id => _id!;
  String get eventName => _eventName!;
  String get obsEvent => _obsEvent!;



  static List<eEventBase> getEventsBase(){
    return <eEventBase> [
      eEventBase("0", "Evento A", "Observação A"),
      eEventBase("1", "Evento B", "Observação B"),
      eEventBase("2", "Evento C", "Observação C"),
      eEventBase("3", "Evento D", "Observação D"),
    ];
  }


  set id(String value) {
    _id = value;
  }
  set obsEvent(String value) {
    _obsEvent = value;
  }
  set eventName(String value) {
    _eventName = value;
  }
}