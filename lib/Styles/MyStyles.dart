import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
const APP_BAR_BACKGROUND_COLOR = Colors.blueAccent;
const APP_EDIT_DISMISS = Colors.green;
const APP_REMOVE_DISMISS = Colors.redAccent;
const APP_MAIN_TEXT = Colors.black;
const APP_SUB_TEXT = Colors.grey;
const APP_ERROR_BACKGROUND = Colors.redAccent;
const APP_ERROR_FINISH_EVENT = Colors.redAccent;
const APP_ERROR_REACTIVE_EVENT = Colors.blueAccent;
const APP_SUCCESS_BACKGROUND = Colors.green;
const APP_WHITE_FONT = Colors.white;
const APP_HINT_TEXT_FIELD = Colors.grey;
const APP_CARD_BACKGROUND = Colors.white;
const APP_CANCEL_BUTTON = Colors.black;
const APP_TEXT_FIELD_BACKGROUND = Colors.white;
const APP_CHECK_COLOR = Colors.white;

double APP_TEXT_EDIT_RADIUS_BORDER = 16;
// TEXT FIELDS

/*
* Estilo padrão do textField
* */
textFieldDefaultDecoration(String str){
  return InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
      hintText: str,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(cStyles.RADIUS_BORDER_TEXT_FIELD)
      )
  );
}


