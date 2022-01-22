import 'package:abeuni_carona/Screen/Menu/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import '../Constants/cRoutes.dart';
import '../RouteGenerator.dart';
import 'Login.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
      home: MainScreen(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: ThemeData(
    primaryColor: Color(0xff075E54),
    accentColor: Color(0xff25D366)
    ),
    initialRoute: cRoutes.LOGIN,
    onGenerateRoute: RouteGenerator.generateRoute,
    debugShowCheckedModeBanner: false,
    ));
}