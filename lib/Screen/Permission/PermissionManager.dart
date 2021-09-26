import 'package:abeuni_carona/Entity/ePermission.dart';
import 'package:abeuni_carona/Entity/eUser.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';


class PermissionManager extends StatefulWidget {

  eUser? user;
  PermissionManager(this.user);

  @override
  _PermissionManagerState createState() => _PermissionManagerState();
}

class _PermissionManagerState extends State<PermissionManager> {

  List<ePermission> _permissions = ePermission.getPermissions();
  @override
  Widget build(BuildContext context) {
    eUser? user = widget.user;

    return Scaffold(
      appBar: AppBar(
        title: Text("Permissões"),
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
      ),
      body: _permissions != null && _permissions.length > 0
          ? SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(cStyles.PADDING_DEFAULT_SCREEN),
              child: Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment:  MainAxisAlignment.center,
                          children: [
                            Text(
                              user!.userName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                        ),
                      )
                    ),
                    _permissions != null && _permissions.length > 0 ?
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: _permissions.length,
                        itemBuilder: (_, index){
                          ePermission permission = _permissions[index];
                          return Card(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                                  child:  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Id:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18
                                            ),
                                          ),
                                          Text(
                                            permission.idPermissions,
                                            style: TextStyle(
                                                fontSize: 18
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            permission.descPermission,
                                            style: TextStyle(
                                                color: Colors.grey
                                            ),
                                          ),
                                          Spacer(),
                                          Checkbox(
                                              value: permission.active,
                                              onChanged: (value){
                                                setState(() {
                                                  permission.active = value!;
                                                });
                                              })
                                        ],
                                      ),
                                    ],
                                  )
                              ),
                            ),
                          ) ;
                        }
                    ) : Container()
                  ]
              )
          )
      ) : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Não há permissões cadastradas",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          )
      ),
    );
  }
}
