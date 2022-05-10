import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Screen/Vehicle/VehiclesForm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VehiclesSelects {
  /**
   * Recebe: stiuação do veículo
   * Retorna: Select de busca de veículos
  **/
  static getSelectByFilters(VehiclesForm form) {
    if (form.situation == 'Ativos') {
      return getAllActiveVechicles(form);
    } else if (form.situation == 'Inativos') {
      return getVechiclesInactives(form);
    } else {
      return getAllVechicles(form);
    }
  }

  /**
   * Reeceb: Formulário de veículos
   * Return: Retorna todos todos os veículos ativos
   * */
  static getAllActiveVechicles(VehiclesForm form) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    return db
        .collection(DbData.TABLE_VEHICLE)
        .where(DbData.COLUMN_ID_OWNER, isEqualTo: form.idUser)
        .where(DbData.COLUMN_ACTIVE, isEqualTo: true)
        .orderBy(DbData.COLUMN_REGISTRATION_DATE, descending: true)
        .snapshots();
  }

  /**
   * Reeceb: Formulário de veículos
   * Retorna: Todos todos os veículos inatívos
   * */
  static getVechiclesInactives(VehiclesForm form) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    return db
        .collection(DbData.TABLE_VEHICLE)
        .where(DbData.COLUMN_ID_OWNER, isEqualTo: form.idUser)
        .where(DbData.COLUMN_ACTIVE, isEqualTo: false)
        .orderBy(DbData.COLUMN_REGISTRATION_DATE, descending: true)
        .snapshots();
  }

  /**
   * Reeceb: Formulário de veículos
   * Retorna: Todos todos os veículos
   * */
  static getAllVechicles(VehiclesForm form) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    return db
        .collection(DbData.TABLE_VEHICLE)
        .where(DbData.COLUMN_ID_OWNER, isEqualTo: form.idUser)
        .orderBy(DbData.COLUMN_REGISTRATION_DATE, descending: true)
        .snapshots();
  }
}
