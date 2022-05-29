class ePermission {

  String? _idPermission;
  String? _name;
  String? _desc;
  bool? _active;

  ePermission.empty();
  ePermission(this._idPermission, this._name, this._desc, this._active);

  String get idPermission => _idPermission!;
  String get name => _name!;
  String get desc => _desc!;
  bool get active => _active!;

  set idPermission(String value) {
    _idPermission = value;
  }
  set name(String value) {
    _name = value;
  }
  set desc(String value) {
    _desc = value;
  }
  set active(bool value) {
    _active = value;
  }

  Map<String, dynamic> toMap() {
    return {

    };
  }
}