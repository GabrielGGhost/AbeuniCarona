import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'package:abeuni_carona/Screen/Menu/MyRides.dart';
import 'package:abeuni_carona/Screen/Rides/Ride/Rides.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
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
        child: Padding(
            padding: EdgeInsets.only(top: 50),
            child: ListView(
              children: [
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
                ),
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
                        cRoutes.RIDES
                    );
                  },
                  subtitle: Text("Programe uma carona."),
                  horizontalTitleGap: 1,
                ),
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
                ),
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
                ),
                ListTile(
                  title: Text(
                    "Histórico de viagens",
                    style: TextStyle(
                        fontSize: 15
                    ),
                  ),
                  leading: Icon(Icons.watch_later_outlined),
                  onTap: (){},
                  subtitle: Text("Registro de suas viagens"),
                  horizontalTitleGap: 1,
                ),
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
                ),
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
                        cRoutes.USER_MENU
                    );
                  },
                  subtitle: Text("Programe uma carona."),
                  horizontalTitleGap: 1,
                ),
              ],
            )
        ),
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
}
