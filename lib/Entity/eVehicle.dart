import 'package:abeuni_carona/Constants/DbData.dart';

class eVehicle {

  String? _id;
  String? _sign;
  String? _color;
  String? _model;
  String? _seats;
  String? _luggageSpaces;
  bool? _myCar;



  String get luggageSpaces => _luggageSpaces!;
  String get seats => _seats!;
  String get model => _model!;
  String get color => _color!;
  String get sign => _sign!;
  bool get myCar => _myCar!;

  eVehicle(this._sign, this._color, this._model, this._seats,
      this._luggageSpaces, this._myCar);

  eVehicle.register(this._sign, this._color, this._model, this._seats,
      this._luggageSpaces, this._myCar);

  static List<eVehicle> getVehicles(){
    return <eVehicle> [
      eVehicle("ABC-123", "COR A", "Modelo A", "4", "3", true),
      eVehicle("DEF-456", "COR B", "Modelo B", "6", "4", true),
      eVehicle("GHI-789", "COR C", "Modelo C", "4", "2", false),
      eVehicle("JKL-012", "COR D", "Modelo D", "2", "4", false),
    ];
  }

  Map<String, dynamic> toMap(){

    return {
      DbData.COLUMN_SIGN : this._sign,
      DbData.COLUMN_COLOR: this._color,
      DbData.COLUMN_MODEL : this._model,
      DbData.COLUMN_SEATS : this._seats,
      DbData.COLUMN_LUGGAGE_SPACES : this._luggageSpaces,
      DbData.COLUMN_MY_CAR : this._myCar,
    };

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
  set myCar(bool value) {
    _myCar = value;
  }
}