import 'package:abeuni_carona/Screen/Configurations.dart';
import 'package:abeuni_carona/Screen/Events/Events.dart';
import 'package:abeuni_carona/Screen/Events/EventsBase.dart';
import 'package:abeuni_carona/Screen/Vehicle/Vehicles.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';

import 'Screen/Login.dart';
import 'Screen/Vehicle/VehicleRegister.dart';
import 'Util/Utils.dart';

class RouteGenerator {

  static Route<dynamic>? generateRoute(RouteSettings set){

    var args = set.arguments;

    switch(set.name){
      case cRoutes.INITIAL_ROUTE:
      case cRoutes.LOGIN:
        return MaterialPageRoute(
            builder: (_) => Login()
        );
      case cRoutes.CONFIGURATIONS:
        return MaterialPageRoute(
            builder: (_) => Configurations()
        );
      case cRoutes.VEHICLES:
        return MaterialPageRoute(
            builder: (_) => Vechicles()
        );
      case cRoutes.VEHICLES_REGISTER:
        return MaterialPageRoute(
            builder: (_) => VehicleRegister()
        );
      case cRoutes.EVENTS:
        return MaterialPageRoute(
            builder: (_) => Events()
        );
      default :
        _routeNotFound();
    }
  }

  static void _routeNotFound() {
    Utils.showToast("Erro ao acessar a tela", Colors.redAccent);
  }
}