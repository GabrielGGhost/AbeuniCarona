class ePermission {

  String? _idPermissions;
  String? _descPermission;

  ePermission(this._idPermissions, this._descPermission);

  static List<ePermission> getEvents(){
    return <ePermission> [
      ePermission("1", "Permite gerenciar permissões"),
      ePermission("2", "Permite cadastrar eventos bases"),
      ePermission("3", "Permite cadastrar eventos"),
      ePermission("4", "Permite realizar caronas"),
    ];
  }

  String get idPermissions => _idPermissions!;
  String get descPermission => _descPermission!;

  set idPermissions(String value) {
    _idPermissions = value;
  }
  set descPermission(String value) {
    _descPermission = value;
  }
}