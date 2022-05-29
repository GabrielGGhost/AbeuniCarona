import 'dart:async';

import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Entity/ePermission.dart';
import 'package:abeuni_carona/Entity/eUser.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PermissionManager extends StatefulWidget {
  DocumentSnapshot? user;
  PermissionManager(this.user);

  @override
  _PermissionManagerState createState() => _PermissionManagerState();
}

class _PermissionManagerState extends State<PermissionManager> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _streamPermission = StreamController<QuerySnapshot>.broadcast();

  List<ePermission> permissionsList = [];
  eUser? user = eUser.empty();

  Stream<QuerySnapshot>? _addListenerPermission() {
    final permissionList = db.collection(DbData.TABLE_PERMISSION).snapshots();

    permissionList.listen((data) {
      _streamPermission.add(data);
    });
  }

  @override
  void initState() {
    _addListenerPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user!.docToUser(widget.user);

    return Scaffold(
        appBar: AppBar(
          title: Text("Permissões"),
          backgroundColor: APP_BAR_BACKGROUND_COLOR,
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(cStyles.PADDING_DEFAULT_SCREEN),
                child: Column(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user!.userName + " [" + user!.nickName + "]",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SingleChildScrollView(
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              StreamBuilder(
                                  stream: _streamPermission.stream,
                                  builder: (_, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.none:
                                      case ConnectionState.waiting:
                                        return Center(
                                          child: Column(
                                            children: [
                                              CircularProgressIndicator()
                                            ],
                                          ),
                                        );
                                      case ConnectionState.active:
                                      case ConnectionState.done:
                                        QuerySnapshot query =
                                            snapshot.data as QuerySnapshot;

                                        if (snapshot.hasError) {
                                          return Center(
                                            child: Column(
                                              children: [
                                                Text(AppLocalizations.of(
                                                        context)!
                                                    .erroAoCarregarDados)
                                              ],
                                            ),
                                          );
                                        } else {
                                          if (query.docs.length > 0) {
                                            List<DocumentSnapshot>
                                                docPermissions =
                                                query.docs.toList();

                                            return StreamBuilder(
                                              stream: db
                                                  .collection(DbData.TABLE_USER)
                                                  .doc(user!.uid)
                                                  .collection(
                                                      DbData.TABLE_PERMISSION)
                                                  .snapshots(),
                                              builder: (_, snapshot) {
                                                switch (
                                                    snapshot.connectionState) {
                                                  case ConnectionState.none:
                                                  case ConnectionState.waiting:
                                                    return Center(
                                                      child: Column(
                                                        children: [
                                                          CircularProgressIndicator()
                                                        ],
                                                      ),
                                                    );
                                                  case ConnectionState.active:
                                                  case ConnectionState.done:
                                                    QuerySnapshot query2 =
                                                        snapshot.data
                                                            as QuerySnapshot;

                                                    if (query.docs.length > 0) {
                                                      return ListView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemCount:
                                                              query.docs.length,
                                                          itemBuilder: (_, i) {
                                                            List<DocumentSnapshot>
                                                                activePermissions =
                                                                query2.docs
                                                                    .toList();

                                                            permissionsList =
                                                                preparePermission(
                                                                    docPermissions,
                                                                    activePermissions);

                                                            ePermission
                                                                permission =
                                                                permissionsList[
                                                                    i];
                                                            return Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          8),
                                                              child: Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                      vertical:
                                                                          15,
                                                                      horizontal:
                                                                          10),
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                              child: Text(permission.name, style: TextStyle(fontWeight: FontWeight.bold)
                                                                          )),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              permission.desc,
                                                                              style: TextStyle(color: Colors.grey),
                                                                            ),
                                                                          ),
                                                                          Checkbox(
                                                                              value: permission.active,
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  permission.active = value!;
                                                                                  updatePermisstion(permission);
                                                                                });
                                                                              })
                                                                        ],
                                                                      ),
                                                                      Divider()
                                                                    ],
                                                                  )),
                                                            );
                                                          });
                                                    } else {
                                                      return Container();
                                                    }
                                                }
                                              },
                                            );
                                          } else {
                                            return Container();
                                          }
                                        }
                                    }
                                  })
                            ],
                          ))),
                ]))));
  }

  List<ePermission> preparePermission(
      List<DocumentSnapshot<Object?>> docPermissions,
      List<DocumentSnapshot<Object?>> activePermissions) {
    List<ePermission> permissions = [];

    if (activePermissions.length == 0) {
      for (var basePermission in docPermissions) {
        ePermission permission = ePermission(
            basePermission.id,
            basePermission[DbData.COLUMN_NAME],
            basePermission[DbData.COLUMN_DESCRIPTION],
            false);
        permissions.add(permission);
      }
      return permissions;
    }

    for (var basePermission in docPermissions) {
      bool found = false;
      for (var userPermission in activePermissions) {
        if (basePermission.id == userPermission.id) {
          ePermission permission = ePermission(
              basePermission.id,
              basePermission[DbData.COLUMN_NAME],
              basePermission[DbData.COLUMN_DESCRIPTION],
              true);
          permissions.add(permission);
          found = true;
          break;
        }
      }
      if (!found) {
        ePermission permission = ePermission(
            basePermission.id,
            basePermission[DbData.COLUMN_NAME],
            basePermission[DbData.COLUMN_DESCRIPTION],
            false);
        permissions.add(permission);
      }
    }
    return permissions;
  }

  void updatePermisstion(ePermission permission) {
    if(permission.active){
      insertPermission(permission);
      return;
    } 
    deletePermission(permission);
  }

  void insertPermission(ePermission permission) {
    db.collection(DbData.TABLE_USER).doc(user!.uid).collection(DbData.TABLE_PERMISSION).doc(permission.idPermission).set(permission.toMap());
  }

  void deletePermission(ePermission permission) {
    db.collection(DbData.TABLE_USER).doc(user!.uid).collection(DbData.TABLE_PERMISSION).doc(permission.idPermission).delete();
  }
}