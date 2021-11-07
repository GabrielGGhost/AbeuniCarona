import 'package:abeuni_carona/Constants/cErrorCodes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:abeuni_carona/Constants/cImages.dart';
import 'package:abeuni_carona/Constants/cErrorCodes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:abeuni_carona/Constants/cDate.dart';

class Utils{

  /*
  * @Function : Retorna o path completo da imagem a ser exibida
  * @Params :
  *   imageName : Nome da imagem que será exibida
  *   ext : Extensão da imagem
  * */
  static String getPhoto(String imageName, [String? ext]){
    if(ext != null){
      return cImages.IMAGE_PATH + imageName + "." + ext;
    } else {
      return cImages.IMAGE_PATH + imageName + "." + cImages.TYPE_PNG;
    }
  }

  /*
  * @Function : Mostra uma mensagem toast na tela
  * @Params :
  *   message : Mensagem que será exibida
  * */
  static void showToast(String message, [color]){

    Fluttertoast.cancel();
    if(color != null){
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: color
      );
    } else {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
      );
    }

  }

  static void showAuthError(code, context) {
    late String errorMessage;
    switch (code) {
      case cErrorCodes.ERROR_EMAIL_ALREADY_IN_USE:
      case cErrorCodes.ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL:
      case cErrorCodes.EMAIL_ALREADY_IN_USE:
        errorMessage = AppLocalizations.of(context)!.emailJaEmUso;
        break;
      case cErrorCodes.ERROR_WRONG_PASSWORD:
      case cErrorCodes.WRONG_PASSWORD:
      case cErrorCodes.ERROR_USER_NOT_FOUND:
      case cErrorCodes.USER_NOT_FOUND:
        errorMessage = AppLocalizations.of(context)!.cadastroNaoEncontrado;
        break;
      case cErrorCodes.ERROR_USER_DISABLED:
      case cErrorCodes.USER_DISABLED:
        errorMessage = AppLocalizations.of(context)!.cadastroDesativado;
        break;
      case cErrorCodes.ERROR_TOO_MANY_REQUESTS:
      case cErrorCodes.OPERATION_NOT_ALLOWED:
        errorMessage = AppLocalizations.of(context)!.excessoTentativas;
        break;
      case cErrorCodes.ERROR_OPERATION_NOT_ALLOWED:
      case cErrorCodes.OPERATION_NOT_ALLOWED:
        errorMessage = AppLocalizations.of(context)!.erroNoServidorTenteNovamenteMaisTarde;
        break;
      case cErrorCodes.ERROR_INVALID_EMAIL:
      case cErrorCodes.INVALID_EMAIL:
        errorMessage = AppLocalizations.of(context)!.emailInvalido;
        break;
      default:
        errorMessage = AppLocalizations.of(context)!.erroDesconhecido;
        break;
    }

    showToast(errorMessage, Colors.redAccent);
  }

  static void showDialogBox(String message, context) {

    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text(
                message,
                style: TextStyle(
                  fontSize: 16
                ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.ok,)
              )
            ],
          );
        });
  }

  static String getDateFromBD(String date, String format) {

    DateTime dateTime = DateTime.parse(date);
    String formattedDate = DateFormat(cDate.FORMAT_SLASH_DD_MM_YYYY_KK_MM).format(dateTime);

    return formattedDate;
  }

  static String? getDateTimeNow(String format) {

    DateTime dateTime = DateTime.now();
    String formattedDate = DateFormat(format).format(dateTime);

    return formattedDate;
  }
}