class eUser {

  String? _idUser;
  String? _userName;
  String? _picturePath;

  eUser(this._idUser, this._userName, this._picturePath);

  static List<eUser> getUsers(){
    return <eUser> [
      eUser("1", "Fábio Roberto Evangelista", ""),
      eUser("2", "Gabriel Carnelós Seara", ""),
      eUser("3", "Gabriel Santos Artioli", ""),
      eUser("4", "Gustava Miranda Negrini", ""),
    ];
  }

  String get idUser => _idUser!;
  String get userName => _userName!;
  String get picturePath => _picturePath!;

  set idUser(String value) {
    _idUser = value;
  }
  set picturePath(String value) {
    _picturePath = value;
  }
  set userName(String value) {
    _userName = value;
  }
}