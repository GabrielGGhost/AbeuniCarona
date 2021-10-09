import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:flutter/material.dart';

import 'RideRegister_4.dart';

class RideRegister_3 extends StatefulWidget {
  const RideRegister_3({Key? key}) : super(key: key);

  @override
  _RideRegister_3State createState() => _RideRegister_3State();
}

class _RideRegister_3State extends State<RideRegister_3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de eventos"),
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
      ),
      body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(cStyles.PADDING_DEFAULT_SCREEN),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      Text(
                          "Placa: ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                      ),
                      Text(
                          "XXX-2154",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18
                          ),
                      )
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      Text(
                        "Cor:: ",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        "Azul",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      Text(
                        "Modelo: ",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        "Carrinho top",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: TextField(
                    controller: null,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Vagas",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(cStyles.RADIUS_BORDER_TEXT_FIELD)
                        )
                    ),
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: TextField(
                    controller: null,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Malas",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(cStyles.RADIUS_BORDER_TEXT_FIELD)
                        )
                    ),
                  ),
                ),
              ],
            ),
          ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.zero,
            child:FloatingActionButton(
              onPressed: (){
                Navigator.pushNamed(
                    context,
                    cRoutes.REGISTER_RIDE4
                );
              },
              backgroundColor: APP_BAR_BACKGROUND_COLOR,
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
