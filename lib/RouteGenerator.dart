import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';

import 'Screen/Login.dart';

class RouteGenerator {

  static Route<dynamic>? generateRoute(RouteSettings set){

    var args = set.arguments;

    switch(set.name){
      case cRoutes.INITIAL_ROUTE:
      case cRoutes.LOGIN:
        return MaterialPageRoute(
            builder: (_) => Login()
        );
      default :
        _routeNotFound();
    }
  }

  static void _routeNotFound() {
    //Utils.showToast("Erro ao acessar a tela", Colors.redAccent);
  }
}