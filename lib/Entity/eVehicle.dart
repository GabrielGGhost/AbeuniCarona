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