class VehiclesForm {
  String? _idUser;
  String? _situation = "Ativos";

  String get idUser => _idUser!;
  String get situation => _situation!;

  set idUser(String value) {
    _idUser = value;
  }

  set situation(String value) {
    _situation = value;
  }
}
