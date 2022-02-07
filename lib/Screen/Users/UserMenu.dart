import 'dart:io';

import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Entity/eUser.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'dart:async';

class UserMenu extends StatefulWidget {
  @override
  _UserMenuState createState() => _UserMenuState();
}

class _UserMenuState extends State<UserMenu> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  double? radiusBorder = 16;
  String usersLength = "";

  FocusNode? _passowrdFocus;


  @override
  void initState() {
    super.initState();
    _passowrdFocus = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();

    _passowrdFocus!.dispose();
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        title: Text("Usuários"),
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(cStyles.PADDING_DEFAULT_SCREEN),
        child: ListView(
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                ListTile(
                  leading: Icon(Icons.supervised_user_circle),
                  title: Text('Visualizar usuários'),
                  onTap: (){
                    Navigator.pushNamed(
                        context,
                        cRoutes.USERS_LIST
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.check),
                  title: Text('Aprovar requisições'),
                  onTap: (){
                    Navigator.pushNamed(
                        context,
                        cRoutes.USER_REQUESTS
                    );
                  },
                ),
              ],
            ),
      )),
    );
  }

  void saveUser(eUser? user) {
    try {
      insert(user);
      Utils.showToast("Usuário registrado", APP_SUCCESS_BACKGROUND);
      Navigator.popUntil(
          context,
          ModalRoute.withName("")
      );
    } catch (e) {
      Utils.showToast(
          AppLocalizations.of(context)!.erroAoAtualizar, APP_ERROR_BACKGROUND);
    }
  }

  void insert(eUser? user) {
    db.collection(DbData.TABLE_USER).add(user!.toMap());
  }

  bool checkFields() {
    return true;
  }
}

