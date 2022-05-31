import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Entity/eUser.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';

class Configurations extends StatefulWidget {
  const Configurations({Key? key}) : super(key: key);

  @override
  _ConfigurationsState createState() => _ConfigurationsState();
}

class _ConfigurationsState extends State<Configurations> {
  String? _idUser;
  String? _name;
  String? _pathPicture;
  TextEditingController? _nameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Configurações",
        ),
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(cStyles.PADDING_DEFAULT_SCREEN),
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          maxRadius: 90,
                          backgroundImage: _pathPicture != null
                              ? NetworkImage(_pathPicture!)
                              : null,
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 120),
                            child: ElevatedButton(
                              onPressed: () => {},
                              child: Icon(
                                Icons.camera_alt,
                                size: 25,
                              ),
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.all(25),
                                  backgroundColor: APP_BAR_BACKGROUND_COLOR,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(60))),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 65, 15, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: Icon(
                              Icons.person,
                              color: APP_BAR_BACKGROUND_COLOR,
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Text(
                                "Nome",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Text(
                                _name != null ? _name! : "Carregando...",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Text(
                              "Nome usado para identificar você aos outros usuários",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  Padding(
                      padding: EdgeInsets.all(16),
                      child: GestureDetector(
                        child: Row(
                          children: [
                            Icon(
                              Icons.transit_enterexit,
                              size: 25,
                              color: Colors.redAccent,
                            ),
                            Text(
                              "Encerrar sessão",
                              style: TextStyle(color: Colors.redAccent),
                            )
                          ],
                        ),
                        onTap: () {
                          _unlogUser();
                        },
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _getUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;
    _idUser = usuarioLogado!.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
        await db.collection(DbData.TABLE_USER).doc(_idUser).get();

    var data = snapshot.data() as Map;

    setState(() {
      _name = _getColumn(DbData.COLUMN_USERNAME, data);
      _pathPicture = _getColumn(DbData.COLUMN_PICTURE_PATH, data);
      _nameController!.text = _name!;
    });
  }

  _getColumn(String str, Map data) {
    return Utils.getColumn(str, data);
  }

  void _unlogUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    Navigator.pushReplacementNamed(context, cRoutes.LOGIN);
  }
}
