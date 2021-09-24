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
        backgroundColor: Colors.blue,
        title: Text("Abeuni Carona"),
        centerTitle: true,
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(Icons.account_circle, size: 35),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: "Buscar",
            ),
            Tab(
              text: "Menu",
            ),
            Tab(
              text: "Minhas",

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
                  onTap: (){},
                  subtitle: Text("Cadastre seus veículos para usar em suas viagens"),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Você não possui\ncaronas para realizar",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          )
        ],
      ),
    );
  }
}
