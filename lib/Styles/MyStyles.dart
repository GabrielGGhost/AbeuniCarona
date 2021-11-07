import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:flutter/material.dart';

Color APP_BAR_BACKGROUND_COLOR = Colors.blueAccent;
Color APP_EDIT_DISMISS = Colors.green;
Color APP_REMOVE_DISMISS = Colors.redAccent;
Color APP_MAIN_TEXT = Colors.black;
Color APP_SUB_TEXT = Colors.grey;
Color APP_ERROR_BACKGROUND = Colors.redAccent;
Color APP_SUCCESS_BACKGROUND = Colors.green;
Color APP_WHITE_FONT = Colors.white;
Color APP_HINT_TEXT_FIELD = Colors.grey;
Color APP_CARD_BACKGROUND = Colors.white;
Color APP_CANCEL_BUTTON = Colors.black;
Color APP_TEXT_FIELD_BACKGROUND = Colors.white;
Color APP_CHECK_COLOR = Colors.white;

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


