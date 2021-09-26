class ePermission {

  String? _idPermissions;
  String? _descPermission;
  bool _active;

  ePermission(this._idPermissions, this._descPermission, this._active);

  static List<ePermission> getPermissions(){
    return <ePermission> [
      ePermission("1", "Permite gerenciar permissões", true),
      ePermission("2", "Permite cadastrar eventos bases", false),
      ePermission("3", "Permite cadastrar eventos", false),
      ePermission("4", "Permite realizar caronas", true),
    ];
  }

  String get idPermissions => _idPermissions!;
  String get descPermission => _descPermission!;
  bool get active => _active;

  set idPermissions(String value) {
    _idPermissions = value;
  }
  set descPermission(String value) {
    _descPermission = value;
  }
  set active(bool value) {
    _active = value;
  }
}