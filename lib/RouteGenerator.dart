import 'package:abeuni_carona/Entity/eEventBase.dart';
import 'package:abeuni_carona/Entity/eVehicle.dart';
import 'package:abeuni_carona/Screen/Configurations.dart';
import 'package:abeuni_carona/Screen/Events/EventRegister.dart';
import 'package:abeuni_carona/Screen/Events/Events.dart';
import 'package:abeuni_carona/Screen/Events/EventBase.dart';
import 'package:abeuni_carona/Screen/Permission/Permission.dart';
import 'package:abeuni_carona/Screen/Vehicle/Vehicles.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'Entity/eEvent.dart';
import 'Screen/Events/EventBaseRegister.dart';
import 'Screen/Login.dart';
import 'Screen/Vehicle/VehicleRegister.dart';
import 'Util/Utils.dart';
import 'package:abeuni_carona/Screen/Events/EventBase.dart';

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
            builder: (_) => VehicleRegister(args as eVehicle)
        );
      case cRoutes.EVENTS:
        return MaterialPageRoute(
            builder: (_) => Events()
        );
      case cRoutes.EVENT_REGISTER:
        return MaterialPageRoute(
            builder: (_) => EventRegister(args as eEvent)
        );
      case cRoutes.EVENT_BASE_REGISTER:
        return MaterialPageRoute(
            builder: (_) => EventBaseRegister(args as eEventBase)
        );
      case cRoutes.EVENT_BASE:
        return MaterialPageRoute(
            builder: (_) => EventBase()
        );
      case cRoutes.PERMISSION:
        return MaterialPageRoute(
            builder: (_) => Permission()
        );
      default:
        _routeNotFound();
    }
  }

  static void _routeNotFound() {
    Utils.showToast("Erro ao acessar a tela", Colors.redAccent);
  }
}