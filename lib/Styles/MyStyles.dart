import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:flutter/material.dart';

Color APP_BAR_BACKGROUND_COLOR = Colors.blueAccent;


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


