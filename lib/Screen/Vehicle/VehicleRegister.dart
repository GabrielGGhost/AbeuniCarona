import 'package:abeuni_carona/Entity/eVehicle.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';

class VehicleRegister extends StatefulWidget {
  eVehicle? vehicle;
  VehicleRegister(this.vehicle);

  @override
  _VehicleRegisterState createState() => _VehicleRegisterState();
}

class _VehicleRegisterState extends State<VehicleRegister> {

  bool? myCar = false;
  double? radiusBorder = 16;
  eVehicle? vehicle;

  TextEditingController _signControler = TextEditingController();
  TextEditingController _colorControler = TextEditingController();
  TextEditingController _modelControler = TextEditingController();
  TextEditingController _seatsControler = TextEditingController();
  TextEditingController _luggageControler = TextEditingController();
  @override
  Widget build(BuildContext context) {

    vehicle = widget.vehicle;
    String? title = "Registro de veículo";
    String? textButton = "Registrar veículo";
    if(vehicle != null){
      title = "Alteração de veículo";
      textButton = "Atualizar";
      _signControler.text = vehicle!.sign;
      _colorControler.text = vehicle!.color;
      _modelControler.text = vehicle!.model;
      _seatsControler.text = vehicle!.seats;
      _luggageControler.text = vehicle!.luggageSpaces;
      myCar = vehicle!.myCar;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
                  controller: _signControler,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Placa",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(radiusBorder!)
                      )
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _colorControler,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Cor",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(radiusBorder!)
                      )
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _modelControler,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Modelo",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(radiusBorder!)
                      )
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _seatsControler,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Vagas",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(radiusBorder!)
                      )
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _luggageControler,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Espaço para malas",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(radiusBorder!)
                      )
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      value: myCar,
                      onChanged: (bool? value) {
                        setState(() {
                          myCar = !myCar!;
                        });
                      },
                    ),
                    RichText(
                      text: TextSpan(
                          text: "Este é meu veículo",
                          style: TextStyle(
                              color: myCar! ? Colors.black : Colors.grey
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              setState(() {
                                myCar = !myCar!;
                              });
                            }
                      ),
                    )
                  ],
                )
              ),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.fromLTRB(28, 16, 28, 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)
                        )
                    ),
                    child: Text(
                      textButton,
                      style: (
                          TextStyle(
                              color: Colors.white, fontSize: 20
                          )
                      ),
                    ),
                    onPressed: (){
                    },
                  ),
              )
            ],
          ),
        )
      ),
    );
  }
}
