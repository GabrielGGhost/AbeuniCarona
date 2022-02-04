import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Entity/ePhone.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class eUser {

  String? _userName;
  String? _email;
  String? _phoneNumber;
  String? _birthDate;
  String? _cpf;
  String? _nickName;
  String? _picturePath;
  List<ePhone>? _phoneNumbers;
  String? _registrationDate;
  XFile? _file;
  String? _approved;
  String? _role;
  String? _idUserApprover;



  set idUserApprover(String value) {
    _idUserApprover = value;
  }

  set role(String value) {
    _role = value;
  }


  set approved(String value) {
    _approved = value;
  }

  eUser.full(this._userName, this._email, this._phoneNumber, this._birthDate,  this._cpf, this._nickName, this._picturePath, this._registrationDate, this._role, this._approved);

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
      DbData.COLUMN_USERNAME : getSafeString(this.userName),
      DbData.COLUMN_PHONE_NUMBER : getSafeString(this.phoneNumber),
      DbData.COLUMN_BIRTH_DATE : getSafeString(this.birthDate),
      DbData.COLUMN_CPF : getSafeString(this.cpf),
      DbData.COLUMN_NICKNAME : getSafeString(this.nickName),
      DbData.COLUMN_PICTURE_PATH : getSafeString(this.picturePath),
      DbData.COLUMN_REGISTRATION_DATE : getSafeString(this.registrationDate),
      DbData.COLUMN_EMAIL : getSafeString(this.email),
      DbData.COLUMN_APPROVED : getSafeString(this.approved),
      DbData.COLUMN_ROLE : getSafeString(this.role),

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
  XFile get file => _file!;
  String get role => _role!;
  String get approved => _approved!;
  String get idUserApprover => _idUserApprover!;

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
  set file(XFile value) {
    _file = value;
  }
  set email(String value){
    _email = value;
  }

  String getSafeString(string){
    return Utils.getSafeString(string);
  }
}