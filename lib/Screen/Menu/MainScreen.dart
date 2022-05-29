import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'package:abeuni_carona/Constants/cPermission.dart';
import 'package:abeuni_carona/Entity/ePermission.dart';
import 'package:abeuni_carona/Screen/Menu/MyRides.dart';
import 'package:abeuni_carona/Screen/Rides/Ride/Rides.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        vsync: this,
        length: 3,
        initialIndex: 1
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
        title: Text("Abeuni Carona"),
        centerTitle: true,
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 15),
              child: IconButton(
                  onPressed: (){
                    Navigator.pushNamed(
                        context,
                        cRoutes.CONFIGURATIONS
                    );
                  },
                  icon: Icon(Icons.account_circle, size: 35),
              ),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Text(
                "Buscar\nCarona",
                textAlign: TextAlign.center,
              ),
            ),
            Tab(
              text: "Menu",
            ),
            Tab(
              child: Text(
                  "Minhas\nCarona",
                  textAlign: TextAlign.center,
              ),

            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: FutureBuilder(
          future: findAllUserPermission(),
          builder: (_, snapshot) {

            if(!snapshot.hasData){
              return Text("Carregando...");
            } else if(snapshot.hasError){
              return Text("Erro ao carregar dados");
            }

            List<String> permissions = snapshot.data as List<String>;

            return Padding(
                padding: EdgeInsets.only(top: 50),
                child: ListView(
                  children: [
                    Utils.checkPermission(cPermission.REGISTER_BASE_EVENT, permissions) ?
                    ListTile(
                      title: Text(
                        "Meus Veículos",
                        style: TextStyle(
                            fontSize: 15
                        ),
                      ),
                      leading: Icon(Icons.car_rental),
                      onTap: (){
                        Navigator.pushNamed(
                            context,
                            cRoutes.VEHICLES
                        );
                      },
                      subtitle: Text("Cadastre seus veículos para usar em suas viagens"),
                      horizontalTitleGap: 1,
                    ) : Container(),
                    ListTile(
                      title: Text(
                        "Caronas",
                        style: TextStyle(
                            fontSize: 15
                        ),
                      ),
                      leading: Icon(Icons.electric_car),
                      onTap: (){
                        Navigator.pushNamed(
                            context,
                            cRoutes.RIDES,
                            arguments: permissions
                        );
                      },
                      subtitle: Text("Programe uma carona."),
                      horizontalTitleGap: 1,
                    ),
                    Utils.checkPermission(cPermission.REGISTER_BASE_EVENT, permissions) ?
                    ListTile(
                      title: Text(
                        "Eventos Base",
                        style: TextStyle(
                            fontSize: 15
                        ),
                      ),
                      leading: Icon(Icons.model_training),
                      onTap: (){
                        Navigator.pushNamed(
                            context,
                            cRoutes.EVENT_BASE
                        );
                      },
                      subtitle: Text("Gerencie os eventos ativos."),
                      horizontalTitleGap: 1,
                    ) : Container(),
                    Utils.checkPermission(cPermission.REGISTER_BASE_EVENT, permissions) ?
                    ListTile(
                      title: Text(
                        "Eventos Ativos",
                        style: TextStyle(
                            fontSize: 15
                        ),
                      ),
                      leading: Icon(Icons.stream),
                      onTap: (){
                        Navigator.pushNamed(
                            context,
                            cRoutes.EVENTS
                        );
                      },
                      subtitle: Text("Gerencie os eventos ativos."),
                      horizontalTitleGap: 1,
                    ) : Container(),
                    ListTile(
                      title: Text(
                        "Histórico de viagens",
                        style: TextStyle(
                            fontSize: 15
                        ),
                      ),
                      leading: Icon(Icons.watch_later_outlined),
                      onTap: (){
                        Navigator.pushNamed(context, cRoutes.SCHEDULING_HISTORY);
                      },
                      subtitle: Text("Registro de suas viagens"),
                      horizontalTitleGap: 1,
                    ),
                    Utils.checkPermission(cPermission.REGISTER_PERMISSION, permissions) ?
                    ListTile(
                      title: Text(
                        "Permissões",
                        style: TextStyle(
                            fontSize: 15
                        ),
                      ),
                      leading: Icon(Icons.vpn_key_outlined),
                      onTap: (){
                        Navigator.pushNamed(
                            context,
                            cRoutes.PERMISSION
                        );
                      },
                      subtitle: Text("Gerencie as permissões dos usuários."),
                      horizontalTitleGap: 1,
                    ) : Container(),
                    Utils.checkPermission(cPermission.REGISTER_WATCH_USERS, permissions) ?
                    ListTile(
                      title: Text(
                        "Usuários",
                        style: TextStyle(
                            fontSize: 15
                        ),
                      ),
                      leading: Icon(Icons.electric_car),
                      onTap: (){
                        Navigator.pushNamed(
                            context,
                            cRoutes.USER_MENU,
                            arguments: permissions
                        );
                      },
                      subtitle: Text("Gerencia usuáruis."),
                      horizontalTitleGap: 1,
                    ) : Container(),
                  ],
                )
            );
          },
        )

        ,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Não há caronas\ndisponíveis para agendar",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
          ),
          Text(""),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MyRides()
              ],
            )
          )
        ],
      ),
    );
  }

  Future<List<String>> findAllUserPermission() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    List<String> permisisons = [];

    QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore.instance.collection(DbData.TABLE_USER).doc(user!.uid).collection(DbData.TABLE_PERMISSION).get();

    var docs = result.docs;

    for(var doc in docs){
      permisisons.add(doc.id.toString());
    }

    return permisisons;
  }
}
