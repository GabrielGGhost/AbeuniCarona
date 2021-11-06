import 'package:abeuni_carona/Constants/DbData.dart';

class eVehicle {

  String? _id;
  String? _sign;
  String? _color;
  String? _model;
  String? _seats;
  String? _luggageSpaces;



  String get luggageSpaces => _luggageSpaces!;
  String get seats => _seats!;
  String get model => _model!;
  String get color => _color!;
  String get sign => _sign!;

  eVehicle(this._sign, this._color, this._model, this._seats,
      this._luggageSpaces);

  eVehicle.register(this._sign, this._color, this._model, this._seats,
      this._luggageSpaces);

  static List<eVehicle> getVehicles(){
    return <eVehicle> [
      eVehicle("ABC-123", "COR A", "Modelo A", "4", "3"),
      eVehicle("DEF-456", "COR B", "Modelo B", "6", "4"),
      eVehicle("GHI-789", "COR C", "Modelo C", "4", "2"),
      eVehicle("JKL-012", "COR D", "Modelo D", "2", "4"),
    ];
  }
  Map<String, dynamic> toMap(){

    return {
      DbData.COLUMN_SIGN : this._sign,
      DbData.COLUMN_COLOR: this._color,
      DbData.COLUMN_MODEL : this._model,
      DbData.COLUMN_SEATS : this._seats,
      DbData.COLUMN_LUGGAGE_SPACES : this._luggageSpaces,
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
}