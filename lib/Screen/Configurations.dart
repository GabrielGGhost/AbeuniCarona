import 'package:flutter/material.dart';

class Configurations extends StatefulWidget {
  const Configurations({Key? key}) : super(key: key);

  @override
  _ConfigurationsState createState() => _ConfigurationsState();
}

class _ConfigurationsState extends State<Configurations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Configurações",
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          maxRadius: 90,
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
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(60)
                                  )
                              ),
                            )
                        ),
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
                    children: [
                    ],
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
                              color: Colors.green,
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
                                //user["name"].toString().split(" ")[0],
                                "NOME USUÁRIO",
                                style: TextStyle(
                                    fontSize: 16
                                ),
                              ),
                            ),
                            Text(
                              "Nome usado para identificar você aos outros usuários",
                              style: TextStyle(
                                  color: Colors.grey
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: (){
                            },
                            icon: Icon(
                              Icons.create_rounded,
                              size: 25,
                              color: Colors.grey,
                            ),)

                        ],
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
