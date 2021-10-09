import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:flutter/material.dart';

class RideRegister_4 extends StatefulWidget {
  const RideRegister_4({Key? key}) : super(key: key);

  @override
  _RideRegister_4State createState() => _RideRegister_4State();
}

class _RideRegister_4State extends State<RideRegister_4> {
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
                  child: TextField(
                    controller: null,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Localização de partida",
                        suffixIcon: Icon(Icons.gps_fixed),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(cStyles.RADIUS_BORDER_TEXT_FIELD)
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize:  18,
                        color: Colors.black
                      ),
                      children: [
                        TextSpan(
                            text: "Localização do evento: ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                        ),
                        TextSpan(
                          text : "Rua tal das tal, 5814 - Sorocaba SP",
                          style: TextStyle(
                            color: Colors.grey
                          )
                        )
                      ]
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
