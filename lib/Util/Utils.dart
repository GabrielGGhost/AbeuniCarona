import 'package:abeuni_carona/Constants/cErrorCodes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:abeuni_carona/Constants/cImages.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:abeuni_carona/Constants/cDate.dart';

class Utils {
  /*
  * @Function : Retorna o path completo da imagem a ser exibida
  * @Params :
  *   imageName : Nome da imagem que será exibida
  *   ext : Extensão da imagem
  * */
  static String getPhoto(String imageName, [String? ext]) {
    if (ext != null) {
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
  static void showToast(String message, [color]) {
    Fluttertoast.cancel();
    if (color != null) {
      Fluttertoast.showToast(
          msg: message, toastLength: Toast.LENGTH_LONG, backgroundColor: color);
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
        errorMessage =
            AppLocalizations.of(context)!.erroNoServidorTenteNovamenteMaisTarde;
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
        builder: (context) {
          return AlertDialog(
            title: Text(
              message,
              style: TextStyle(fontSize: 16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    AppLocalizations.of(context)!.ok,
                  ))
            ],
          );
        });
  }

  static String getDateFromBD(String date, String format) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate =
        DateFormat(cDate.FORMAT_SLASH_DD_MM_YYYY_KK_MM).format(dateTime);

    return formattedDate;
  }


  /*
  * Recebe: Um parâmetro do formato de data desejado, caso nulo, usa o formato dd/MM/yyyy
  * Retorna: Uma data no formato recebido ou no formato padrão
  * */
  static String? getDateTimeNow([String? format]) {

    if(format == null){
      format = cDate.FORMAT_SLASH_DD_MM_YYYY_KK_MM;
    }

    DateTime dateTime = DateTime.now();
    String formattedDate = DateFormat(format).format(dateTime);

    return formattedDate;
  }

  //Retorna um valor booleano se a variável possui um valor.
  static bool hasValue(String? value) {
    if (value == null) {
      return false;
    } else if (value.length == 0) {
      return false;
    } else {
      return true;
    }
  }

  static getColumn(String str, Map data) {
    return !isNull(data[str]) ? data[str] : "";
  }

  static bool isNull(String str) {
    return str == null || str == "";
  }

  static getSafeString(String string) {
    return string != null ? string : "";
  }

  /**
    Recebe: Data no formato DateTime
    Retorna: Se a uma String com uma descrição de menor tempo segundo a data
  */
  static String getDateTimeUntilNow(dateTime) {
    int dia = int.parse(dateTime.toString().substring(0, 2));
    int mes = int.parse(dateTime.toString().substring(3, 5));
    int ano = int.parse(dateTime.toString().substring(6, 10));
    int hora = int.parse(dateTime.toString().substring(13, 15));
    int minuto = int.parse(dateTime.toString().substring(16, 18));

    final registerDate = DateTime(ano, mes, dia, hora, minuto);
    final dateNow = DateTime.now();
    int diffence = dateNow.difference(registerDate).inSeconds;

    int seconds = 0;
    int minutes = 0;
    int hours = 0;
    int days = 0;
    int months = 0;
    int years = 0;
    int weeks = 0;

    seconds = diffence % 60;
    minutes = (diffence / 60).floor();
    hours = (diffence / 3600).floor();
    days = (diffence / 86400).floor();
    weeks = (days / 86400).floor();
    months = (diffence / 2592000).floor();
    years = (diffence / 31557600).floor();

    if (years > 0) {
      if (years == 1) {
        return "1 ano";
      } else {
        return years.toString() + " anos atrás";
      }
    } else if (months > 0) {
      if (months == 1) {
        return "1 mês";
      } else {
        return months.toString() + " meses atrás";
      }
    } else if (weeks > 0) {
      if (weeks == 1) {
        return "1 seamana";
      } else {
        return days.toString() + " semanas atrás";
      }
    } else if (days > 0) {
      if (days == 1) {
        return "1 dia";
      } else {
        return days.toString() + " dias atrás";
      }
    } else if (hours > 0) {
      if (hours == 1) {
        return "1 hora";
      } else {
        return hours.toString() + " horas atrás";
      }
    } else if (minutes > 0) {
      if (minutes == 1) {
        return "1 minuto";
      } else {
        return minutes.toString() + " minutos atrás";
      }
    } else if (seconds > 0) {
      if (seconds == 1) {
        return "1 segundo";
      } else {
        return seconds.toString() + " segundos atrás";
      }
    }

    return "Não foi possível calcular a data";
  }

  /*
    Recebe: Data no formato dd/MM/yyyy
    Retorna: Data no formato yyyy-MM-dd
  */
  static String toAmericanDate(String date) {
    String day = date.substring(0, 2);
    String month = date.substring(3, 5);
    String year = date.substring(6, 10);

    final fullDate = year + "-" + month + "-" + day;
    print("DATA");
    return fullDate;
  }

  /*
    Recebe: Data no formato dd/MM/yyyy
    Retorna: Se a data é válida
  */
  static bool isDateValid(String date) {
    if(date.isEmpty || date.length != 10){
      return false;
    }
    if (date.indexOf("/") == 2) {
      date = toAmericanDate(date);
    }

    date = date.replaceAll("-", "");

    try {
      final dateTime = DateTime.parse(date);
      final originalFormatString = toOriginalFormatString(dateTime);
      return date == originalFormatString;
    } catch (Ex) {
      return false;
    }
  }

  /*
    Recebe: Data no formato DateTime
    Retorna: Uma String no formato yyyy-MM-dd
  */
  static String toOriginalFormatString(DateTime dateTime) {
    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return "$y$m$d";
  }

  static String getSafeNumber(String value) {
    try{
      int number = int.parse(value);
      return number.toString();
    } catch(e){
      return "0";
    }
  }

  /// Recebe:
  ///      date: Data a ser convertida
  ///      format: formato a ser convertido
  /// Retorna:
  ///      Data em formato String formatada
  static String? getFormatedStringFromDateTime(DateTime date, String format) {
    final DateFormat formatter = DateFormat(format);
    final String formatted = formatter.format(date);
    return formatted;
  }

  static String? getStringDateFromTimestamp(Timestamp stamp, String format) {
    int milliseconds = (stamp.seconds * 1000).round();
    DateTime date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return getFormatedStringFromDateTime(date, format);
  }

  static getDateTimeFromString(String date) {
    String day = date.toString().substring(0, 2);
    String month = date.toString().substring(3, 5);
    String year = date.toString().substring(6, 10);

    return DateTime.parse(year + "-" + month + "-" + day);
  }
}
