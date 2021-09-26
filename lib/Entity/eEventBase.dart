class eEventBase{

  String? id;
  String? eventName;

  eEventBase(this.id, this.eventName);

  static List<eEventBase> getEventsBase(){
    return <eEventBase> [
      eEventBase("0", "Evento A"),
      eEventBase("1", "Evento B"),
      eEventBase("2", "Evento C"),
      eEventBase("3", "Evento D"),
    ];
  }
}