class ePhone{

  String? _phoneNumber;
  String? _ddd;
  String? _type;


  String get phoneNumber => _phoneNumber!;
  String get ddd => _ddd!;
  String get type => _type!;

  set phoneNumber(String value) {
    _phoneNumber = value;
  }
  set type(String value) {
    _type = value;
  }
  set ddd(String value) {
    _ddd = value;
  }
}