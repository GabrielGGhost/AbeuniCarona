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
  String? _userApprovalDate;
  String? _department;

  eUser.empty();

  eUser.full(
      this._userName,
      this._email,
      this._phoneNumber,
      this._birthDate,
      this._cpf,
      this._nickName,
      this._department,
      this._picturePath,
      this._registrationDate,
      this._role,
      this._approved,
      this._idUserApprover,
      this._userApprovalDate);

  static List<eUser> getUsers() {
    return <eUser>[
      // eUser.full("1", "Fábio Roberto Evangelista", "", "", "", []),
      // eUser.full("2", "Gabriel Carnelós Seara", "", "", "", []),
      // eUser.full("3", "Gabriel Santos Artioli", "", "", "", []),
      // eUser.full("4", "Gustava Miranda Negrini", "", "", "", []),
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      DbData.COLUMN_USERNAME: getSafeString(this.userName),
      DbData.COLUMN_PHONE_NUMBER: getSafeString(this.phoneNumber),
      DbData.COLUMN_BIRTH_DATE: getSafeString(this.birthDate),
      DbData.COLUMN_CPF: getSafeString(this.cpf),
      DbData.COLUMN_NICKNAME: getSafeString(this.nickName),
      DbData.COLUMN_PICTURE_PATH: getSafeString(this.picturePath),
      DbData.COLUMN_REGISTRATION_DATE: getSafeString(this.registrationDate),
      DbData.COLUMN_EMAIL: getSafeString(this.email),
      DbData.COLUMN_APPROVED: getSafeString(this.approved),
      DbData.COLUMN_ROLE: getSafeString(this.role),
      DbData.COLUMN_USER_ID_APPROVER: getSafeString(this.idUserApprover),
      DbData.COLUMN_USER_APPROVAL_DATE: getSafeString(this.userApprovalDate),
      DbData.COLUMN_DEPARTMENT : getSafeString(this._department)
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
  String get userApprovalDate => _userApprovalDate!;
  String get department => _department!;

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

  set email(String value) {
    _email = value;
  }

  set userApprovalDate(String value) {
    _userApprovalDate = value;
  }

  set idUserApprover(String value) {
    _idUserApprover = value;
  }

  set nickName(String value) {
    _nickName = value;
  }

  set role(String value) {
    _role = value;
  }

  set approved(String value) {
    _approved = value;
  }

  set department(String value) {
    _department = value;
  }

  String getSafeString(string) {
    return Utils.getSafeString(string);
  }

  void docToUser(DocumentSnapshot<Map<String, dynamic>> docUser) {
    this.userName = docUser[DbData.COLUMN_USERNAME];
    this.phoneNumber = docUser[DbData.COLUMN_PHONE_NUMBER];
    this.birthDate = docUser[DbData.COLUMN_BIRTH_DATE];
    this.cpf = docUser[DbData.COLUMN_CPF];
    this.nickName = docUser[DbData.COLUMN_NICKNAME];
    this.picturePath = docUser[DbData.COLUMN_PICTURE_PATH];
    this.registrationDate = docUser[DbData.COLUMN_REGISTRATION_DATE];
    this.email = docUser[DbData.COLUMN_EMAIL];
    this.approved = docUser[DbData.COLUMN_APPROVED];
    this.role = docUser[DbData.COLUMN_ROLE];
    this.idUserApprover = docUser[DbData.COLUMN_USER_ID_APPROVER];
    this.userApprovalDate = docUser[DbData.COLUMN_USER_APPROVAL_DATE];
    this._department = docUser[DbData.COLUMN_DEPARTMENT];

  }
}
