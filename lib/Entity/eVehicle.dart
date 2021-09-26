class eVehicle {

  String? _id;
  String? _sign;
  String? _color;
  String? _model;
  String? _seats;
  String? _luggageSpaces;

  String get id => _id!;
  String get luggageSpaces => _luggageSpaces!;
  String get seats => _seats!;
  String get model => _model!;
  String get color => _color!;
  String get sign => _sign!;


  eVehicle(this._id, this._sign, this._color, this._model, this._seats,
      this._luggageSpaces);

  static List<eVehicle> getVehicles(){
    return <eVehicle> [
      eVehicle("0", "ABC-123", "COR A", "Modelo A", "4", "3"),
      eVehicle("1", "DEF-456", "COR B", "Modelo B", "6", "4"),
      eVehicle("2", "GHI-789", "COR C", "Modelo C", "4", "2"),
      eVehicle("3", "JKL-012", "COR D", "Modelo D", "2", "4"),
    ];
  }

  set id(String value) {
    _id = value;
  }
  set luggageSpaces(String value) {
    _luggageSpaces = value;
  }
  set seats(String value) {
    _seats = value;
  }
  set model(String value) {
    _model = value;
  }
  set color(String value) {
    _color = value;
  }
  set sign(String value) {
    _sign = value;
  }
}