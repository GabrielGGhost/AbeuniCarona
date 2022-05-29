import 'dart:io';

import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Constants/cPermission.dart';
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
  List<String> permissions;
  UserMenu(this.permissions);

  @override
  _UserMenuState createState() => _UserMenuState();
}

class _UserMenuState extends State<UserMenu> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  double? radiusBorder = 16;
  String usersLength = "";

  FocusNode? _passowrdFocus;
  List<String>? permissions;

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
    permissions = widget.permissions;

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
              onTap: () {
                Navigator.pushNamed(context, cRoutes.USERS_LIST);
              },
            ),
            Utils.checkPermission(
                    cPermission.REGISTER_APPROVE_USERS, permissions!)
                ? ListTile(
                    leading: Icon(Icons.check),
                    title: Text('Aprovar requisições'),
                    trailing: FutureBuilder(
                      future: findAllUserRequests(),
                      builder: (_, snapshot) {
                        if (!snapshot.hasData) {
                          return Text("");
                        } else if (snapshot.hasError) {
                          return Text("Erro ao carregar dados");
                        }
                        if(snapshot.data.toString() == "0"){
                          return Text("");
                        }
                        return Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(8),
                            child: Text(
                              snapshot.data.toString(),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            decoration: BoxDecoration(
                              color: APP_BAR_BACKGROUND_COLOR,
                              shape: BoxShape.circle,
                            ));
                      },
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, cRoutes.USER_REQUESTS);
                    },
                  )
                : Container(),
          ],
        ),
      )),
    );
  }

  void saveUser(eUser? user) {
    try {
      insert(user);
      Utils.showToast("Usuário registrado", APP_SUCCESS_BACKGROUND);
      Navigator.popUntil(context, ModalRoute.withName(""));
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

  Future<int> findAllUserRequests() async {
    QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore
        .instance
        .collection(DbData.TABLE_USER)
        .where(DbData.COLUMN_APPROVED, isEqualTo: "0")
        .get();

    return result.docs.length;
  }
}
