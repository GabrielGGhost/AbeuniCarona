import 'package:abeuni_carona/Entity/eUser.dart';
import 'package:abeuni_carona/Screen/Configurations.dart';
import 'package:abeuni_carona/Screen/Events/Events/EventRegister.dart';
import 'package:abeuni_carona/Screen/Events/Events/Events.dart';
import 'package:abeuni_carona/Screen/Events/baseEvents/EventBase.dart';
import 'package:abeuni_carona/Screen/Permission/Permission.dart';
import 'package:abeuni_carona/Screen/Rides/History/History.dart';
import 'package:abeuni_carona/Screen/Rides/Scheduling/Scheduling.dart';
import 'package:abeuni_carona/Screen/Users/Perfil/userPerfil.dart';
import 'package:abeuni_carona/Screen/Users/Register/RegisterUserPassword.dart';
import 'package:abeuni_carona/Screen/Users/Register/SendEmailNewUser.dart';
import 'package:abeuni_carona/Screen/Users/UserMenu.dart';
import 'package:abeuni_carona/Screen/Users/UsersList.dart';
import 'package:abeuni_carona/Screen/Vehicle/Vehicles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'Entity/eRide.dart';
import 'Screen/Events/baseEvents/EventBaseRegister.dart';
import 'Screen/Login.dart';
import 'Screen/Permission/PermissionManager.dart';
import 'Screen/Rides/Ride/Partaker.dart';
import 'Screen/Rides/Ride/Rides.dart';
import 'Screen/Rides/RideRegister/RideRegister_1.dart';
import 'Screen/Rides/RideRegister/RideRegister_2.dart';
import 'Screen/Rides/RideRegister/RideRegister_3.dart';
import 'Screen/Rides/RideRegister/RideRegister_4.dart';
import 'Screen/Rides/RideRegister/RideRegister_5.dart';
import 'Screen/Users/Register/RegisterUser.dart';
import 'Screen/Users/Register/RegisterUserPicture.dart';
import 'Screen/Users/userRequests/userRequests.dart';
import 'Screen/Users/userRequests/userRequestsDetail.dart';
import 'Screen/Vehicle/VehicleRegister.dart';
import 'Util/Utils.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings set) {
    var args = set.arguments;

    switch (set.name) {
      case cRoutes.INITIAL_ROUTE:
      case cRoutes.LOGIN:
        return MaterialPageRoute(builder: (_) => Login());
      case cRoutes.CONFIGURATIONS:
        return MaterialPageRoute(builder: (_) => Configurations());
      case cRoutes.VEHICLES:
        return MaterialPageRoute(builder: (_) => Vechicles());
      case cRoutes.VEHICLES_REGISTER:
        return MaterialPageRoute(
            builder: (_) => VehicleRegister(args as DocumentSnapshot));
      case cRoutes.EVENTS:
        return MaterialPageRoute(builder: (_) => Events());
      case cRoutes.EVENT_REGISTER:{
        if(args == null){
          return MaterialPageRoute(
              builder: (_) => EventRegister(null, false));
        } else {
          Map<String, dynamic> values = args as Map<String, dynamic>;
          return MaterialPageRoute(
              builder: (_) => EventRegister(values['event'], values['edit']));
        }
      }
      case cRoutes.EVENT_BASE_REGISTER:
        return MaterialPageRoute(
            builder: (_) => EventBaseRegister(args as DocumentSnapshot));
      case cRoutes.EVENT_BASE:
        return MaterialPageRoute(builder: (_) => EventBase());
      case cRoutes.PERMISSION:
        return MaterialPageRoute(builder: (_) => Permission());
      case cRoutes.PERMISSION_MANAGER:
        return MaterialPageRoute(
            builder: (_) => PermissionManager(args as DocumentSnapshot));
      case cRoutes.REGISTER_RIDE1:
        if (args == null) {
          return MaterialPageRoute(builder: (_) => RideRegister_1(null, false));
        } else {
          Map<String, dynamic> values = args as Map<String, dynamic>;
          return MaterialPageRoute(
              builder: (_) => RideRegister_1(values['ride'], values['edit']));
        }
      case cRoutes.REGISTER_RIDE2:
        {
          if (args is eRide) {
            return MaterialPageRoute(
                builder: (_) => RideRegister_2(args as eRide, false));
          } else {
            Map<String, dynamic> values = args as Map<String, dynamic>;
            return MaterialPageRoute(
                builder: (_) => RideRegister_2(values['ride'], values['edit']));
          }
        }
      case cRoutes.REGISTER_RIDE3:
        {
          if (args is eRide) {
            return MaterialPageRoute(
                builder: (_) => RideRegister_3(args as eRide, false));
          } else {
            Map<String, dynamic> values = args as Map<String, dynamic>;
            return MaterialPageRoute(
                builder: (_) => RideRegister_3(values['ride'], values['edit']));
          }
        }

      case cRoutes.REGISTER_RIDE4:
        {
          if (args is eRide) {
            return MaterialPageRoute(
                builder: (_) => RideRegister_4(args as eRide, false));
          } else {
            Map<String, dynamic> values = args as Map<String, dynamic>;
            return MaterialPageRoute(
                builder: (_) => RideRegister_4(values['ride'], values['edit']));
          }
        }
      case cRoutes.REGISTER_RIDE5:
        if (args is eRide) {
          return MaterialPageRoute(builder: (_) => RideRegister_5(args, false));
        } else {
          Map<String, dynamic> values = args as Map<String, dynamic>;
          return MaterialPageRoute(
              builder: (_) => RideRegister_5(values['ride'], values['edit']));
        }
      case cRoutes.REGISTER_USER:
        return MaterialPageRoute(builder: (_) => RegisterUser());
      case cRoutes.REGISTER_USER_PICTURE:
        return MaterialPageRoute(
            builder: (_) => RegisterUserPicture(args as eUser));
      case cRoutes.REGISTER_USER_PASSWORD:
        return MaterialPageRoute(
            builder: (_) => RegisterUserPassword(args as eUser));
      case cRoutes.USER_MENU:
        return MaterialPageRoute(builder: (_) => UserMenu());
      case cRoutes.USER_REQUESTS:
        return MaterialPageRoute(builder: (_) => userRequests());
      case cRoutes.SEND_EMAIL_NEW_USER:
        return MaterialPageRoute(builder: (_) => SendEmailNewUser());
      case cRoutes.USER_REQUEST_DETAIL:
        return MaterialPageRoute(
            builder: (_) => userRequestDetail(args as DocumentSnapshot));
      case cRoutes.USERS_LIST:
        return MaterialPageRoute(builder: (_) => usersList());
      case cRoutes.USER_PERFIL:
        return MaterialPageRoute(
            builder: (_) => userPerfil(args as DocumentSnapshot));
      case cRoutes.PARTAKER:
        return MaterialPageRoute(
            builder: (_) => Partaker(args as DocumentSnapshot));
      case cRoutes.RIDES:
        return MaterialPageRoute(builder: (_) => Rides());
      case cRoutes.SCHEDULING:
        return MaterialPageRoute(
            builder: (_) => Scheduling(args as DocumentSnapshot));
      case cRoutes.SCHEDULING_HISTORY:
        return MaterialPageRoute(
            builder: (_) => History());
      default:
        _routeNotFound();
    }
  }

  static void _routeNotFound() {
    Utils.showToast("Erro ao acessar a tela", Colors.redAccent);
  }
}
