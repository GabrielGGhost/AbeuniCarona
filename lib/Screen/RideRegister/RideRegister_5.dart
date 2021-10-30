import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:flutter/material.dart';

import 'RideRegister_4.dart';

class RideRegister_5 extends StatefulWidget {
  const RideRegister_5({Key? key}) : super(key: key);

  @override
  _RideRegister_5State createState() => _RideRegister_5State();
}

class _RideRegister_5State extends State<RideRegister_5> {
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
                Card(
                  child: Column(
                    children: [
                      Row(
                        children : [
                          RichText(
                            text: TextSpan(
                              text: "Placa:"
                            ),

                          )
                        ]

                      )
                    ],
                  ),
                )
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
