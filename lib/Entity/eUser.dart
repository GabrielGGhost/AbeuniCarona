import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Entity/ePhone.dart';
import 'package:image_picker/image_picker.dart';

class eUser {

  String? _userName;
  String? _email;
  String? _phoneNumber;
  String? _birthDate;
  String? _cpf;
  String? _nickName;
  String? _password;
  String? _picturePath;
  List<ePhone>? _phoneNumbers;
  String? _registrationDate;
  String? _userIdRegister;
  XFile? _file;

  eUser.full(this._userName, this._email, this._phoneNumber, this._birthDate,  this._cpf, this._nickName, this._picturePath, this._registrationDate, this._userIdRegister);

  eUser();

  static List<eUser> getUsers(){
    return <eUser> [
      // eUser.full("1", "Fábio Roberto Evangelista", "", "", "", []),
      // eUser.full("2", "Gabriel Carnelós Seara", "", "", "", []),
      // eUser.full("3", "Gabriel Santos Artioli", "", "", "", []),
      // eUser.full("4", "Gustava Miranda Negrini", "", "", "", []),
    ];
  }

  Map<String, dynamic> toMap(){
    return {
      DbData.COLUMN_USERNAME : this.userName,
      DbData.COLUMN_PHONE_NUMBER : this.phoneNumber,
      DbData.COLUMN_BIRTH_DATE : this.birthDate,
      DbData.COLUMN_CPF : this.cpf,
      DbData.COLUMN_NICKNAME : this.nickName,
      DbData.COLUMN_PICTURE_PATH : this.picturePath,
      DbData.COLUMN_REGISTRATION_DATE : this.registrationDate,
      DbData.COLUMN_USER_ID_REGISTER : this.userIdRegister
    };
  }

  String get birthDate => _birthDate!;
  String get nickName => _nickName!;
  String get email => _email!;
  String get phoneNumber => _phoneNumber!;
  String get userName => _userName!;
  String get picturePath => _picturePath!;
  String get cpf => _cpf!;
  List<ePhone> get phoneNumbers => _phoneNumbers!;
  String get registrationDate => _registrationDate!;
  String get userIdRegister => _userIdRegister!;
  XFile get file => _file!;
  String get password => _password!;

  set phoneNumber(String value) {
    _phoneNumber = value;
  }
  set birthDate(String value) {
    _birthDate = value;
  }
  set picturePath(String value) {
    _picturePath = value;
  }
  set userName(String value) {
    _userName = value;
  }
  set cpf(String value) {
    _cpf = value;
  }
  set phoneNumbers(List<ePhone> value) {
    _phoneNumbers = value;
  }
  set registrationDate(String value) {
    _registrationDate = value;
  }
  set userIdRegister(String value) {
    _userIdRegister = value;
  }
  set file(XFile value) {
    _file = value;
  }
  set password(String value) {
    _password = value;
  }
  set email(String value){
    _email = value;
  }
}