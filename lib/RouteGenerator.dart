import 'package:abeuni_carona/Entity/eEventBase.dart';
import 'package:abeuni_carona/Entity/eUser.dart';
import 'package:abeuni_carona/Entity/eVehicle.dart';
import 'package:abeuni_carona/Screen/Configurations.dart';
import 'package:abeuni_carona/Screen/Events/Events/EventRegister.dart';
import 'package:abeuni_carona/Screen/Events/Events/Events.dart';
import 'package:abeuni_carona/Screen/Events/baseEvents/EventBase.dart';
import 'package:abeuni_carona/Screen/Permission/Permission.dart';
import 'package:abeuni_carona/Screen/RideRegister/RideRegister_1.dart';
import 'package:abeuni_carona/Screen/RideRegister/RideRegister_2.dart';
import 'package:abeuni_carona/Screen/Users/Register/RegisterUserPassword.dart';
import 'package:abeuni_carona/Screen/Users/Register/SendEmailNewUser.dart';
import 'package:abeuni_carona/Screen/Users/UserMenu.dart';
import 'package:abeuni_carona/Screen/Vehicle/Vehicles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'Entity/eEvent.dart';
import 'Screen/Events/baseEvents/EventBaseRegister.dart';
import 'Screen/Login.dart';
import 'Screen/Permission/PermissionManager.dart';
import 'Screen/RideRegister/RideRegister_3.dart';
import 'Screen/RideRegister/RideRegister_4.dart';
import 'Screen/RideRegister/RideRegister_5.dart';
import 'Screen/Users/Register/RegisterUser.dart';
import 'Screen/Users/Register/RegisterUserPicture.dart';
import 'Screen/Users/userRequests/userRequests.dart';
import 'Screen/Vehicle/VehicleRegister.dart';
import 'Util/Utils.dart';
import 'package:abeuni_carona/Screen/Events/baseEvents/EventBase.dart';

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
            builder: (_) => VehicleRegister(args as DocumentSnapshot)
        );
      case cRoutes.EVENTS:
        return MaterialPageRoute(
            builder: (_) => Events()
        );
      case cRoutes.EVENT_REGISTER:
        return MaterialPageRoute(
            builder: (_) => EventRegister(args as DocumentSnapshot)
        );
      case cRoutes.EVENT_BASE_REGISTER:
        return MaterialPageRoute(
            builder: (_) => EventBaseRegister(args as DocumentSnapshot)
        );
      case cRoutes.EVENT_BASE:
        return MaterialPageRoute(
            builder: (_) => EventBase()
        );
      case cRoutes.PERMISSION:
        return MaterialPageRoute(
            builder: (_) => Permission()
        );
      case cRoutes.PERMISSION_MANAGER:
        return MaterialPageRoute(
            builder: (_) => PermissionManager(args as eUser)
        );
      case cRoutes.REGISTER_RIDE1:
        return MaterialPageRoute(
            builder: (_) => RideRegister_1()
        );
      case cRoutes.REGISTER_RIDE2:
        return MaterialPageRoute(
            builder: (_) => RideRegister_2()
        );
      case cRoutes.REGISTER_RIDE3:
        return MaterialPageRoute(
            builder: (_) => RideRegister_3()
        );
      case cRoutes.REGISTER_RIDE4:
        return MaterialPageRoute(
            builder: (_) => RideRegister_4()
        );
      case cRoutes.REGISTER_RIDE5:
        return MaterialPageRoute(
            builder: (_) => RideRegister_5()
        );
      case cRoutes.REGISTER_USER:
        return MaterialPageRoute(
            builder: (_) => RegisterUser()
        );
      case cRoutes.REGISTER_USER_PICTURE:
        return MaterialPageRoute(
            builder: (_) => RegisterUserPicture(args as eUser)
        );
      case cRoutes.REGISTER_USER_PASSWORD:
        return MaterialPageRoute(
            builder: (_) => RegisterUserPassword(args as eUser)
        );
      case cRoutes.USER_MENU:
        return MaterialPageRoute(
            builder: (_) => UserMenu()
        );
      case cRoutes.USER_REQUESTS:
        return MaterialPageRoute(
            builder: (_) => userRequests()
        );
      case cRoutes.SEND_EMAIL_NEW_USER:
        return MaterialPageRoute(
            builder: (_) => SendEmailNewUser()
        );
      default:
        _routeNotFound();
    }
  }

  static void _routeNotFound() {
    Utils.showToast("Erro ao acessar a tela", Colors.redAccent);
  }
}