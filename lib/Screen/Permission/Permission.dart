import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'package:abeuni_carona/Entity/eUser.dart';

class Permission extends StatefulWidget {

  @override
  _PermissionState createState() => _PermissionState();
}

class _PermissionState extends State<Permission> {

  List<eUser> users = eUser.getUsers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Permissões"),
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
      ),
      body: true ? SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(cStyles.PADDING_DEFAULT_SCREEN),
            child: Column(
              children: [
                users != null && users.length > 0 ?
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: users.length,
                    itemBuilder: (_, index){
                      eUser user = users[index];
                      return Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.pushNamed(
                                  context,
                                  cRoutes.PERMISSION_MANAGER,
                                  arguments: user
                              );
                            },
                            onLongPress: (){
                              Utils.showToast("Longepress");
                            },
                            child: Card(
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            user.userName,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Assentos",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                              ),
                            ),
                          )
                      );
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
                "Não há usuários cadastrados ainda",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          )
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child:FloatingActionButton(
              onPressed: (){
                Utils.showDialogBox("Teste", context);
              },
              backgroundColor: APP_BAR_BACKGROUND_COLOR,
              child: Icon(
                Icons.filter_alt_sharp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
