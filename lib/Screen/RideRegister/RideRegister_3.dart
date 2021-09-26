import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:flutter/material.dart';

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
              
            ],
          ),
        ),
      ),
    );
  }
}
