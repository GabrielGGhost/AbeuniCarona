class EventBase{

  String? id;
  String? eventName;

  EventBase(this.id, this.eventName);

  static List<EventBase> getEventsBase(){
    return <EventBase> [
      EventBase("0", "Evento A"),
      EventBase("1", "Evento B"),
      EventBase("2", "Evento C"),
      EventBase("3", "Evento D"),
    ];
  }
}