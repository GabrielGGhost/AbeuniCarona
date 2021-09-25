import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class EventBaseRegister extends StatefulWidget {
  const EventBaseRegister({Key? key}) : super(key: key);

  @override
  _EventBaseRegisterState createState() => _EventBaseRegisterState();
}

class _EventBaseRegisterState extends State<EventBaseRegister> {

  bool? _active = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de evento"),
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
                      keyboardType: TextInputType.text,
                      decoration: textFieldDefaultDecoration("Nome do evento")
                  ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                    keyboardType: TextInputType.text,
                    maxLines: 5,
                    decoration: textFieldDefaultDecoration("Nome do evento")
                ),
              ),
              Row(
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            value: _active,
                            onChanged: (bool? value) {
                              setState(() {
                                _active = !_active!;
                              });
                            },
                          ),
                          RichText(
                            text: TextSpan(
                                text: "Evento Ativo",
                                style: TextStyle(
                                  color: _active! ? Colors.black : Colors.grey
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    setState(() {
                                      _active = !_active!;
                                    });
                                  }
                            ),
                          )
                        ],
                      )
                  ),
                ],
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
                    "Registrar evento base",
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
          ]
        )
      )
      )
    );
  }
}
