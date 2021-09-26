import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:abeuni_carona/Entity/eEventBase.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class EventBaseRegister extends StatefulWidget {

  eEventBase? eventBase;
  EventBaseRegister(this.eventBase);

  @override
  _EventBaseRegisterState createState() => _EventBaseRegisterState();
}

class _EventBaseRegisterState extends State<EventBaseRegister> {

  bool? _active = true;
  TextEditingController _eventName = TextEditingController();
  TextEditingController _obsEvent = TextEditingController();

  @override
  Widget build(BuildContext context) {
    eEventBase? eventBase = widget.eventBase;

    String title = "Cadastro de evento base";
    String buttonText = "Registrar evento base";

    if(eventBase != null){
      _eventName.text = eventBase.eventName;
      _obsEvent.text = eventBase.obsEvent;
      _active = eventBase.active;
      title = "Alteração de evento base";
      buttonText = "Atualizar";
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
                      controller: _eventName,
                      keyboardType: TextInputType.text,
                      decoration: textFieldDefaultDecoration("Nome do evento")
                  ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                    controller: _obsEvent,
                    keyboardType: TextInputType.text,
                    maxLines: 5,
                    decoration: textFieldDefaultDecoration("Descrição do evento")
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
                    buttonText,
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
