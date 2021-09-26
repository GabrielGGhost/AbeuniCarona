import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';

class Permission extends StatefulWidget {

  @override
  _PermissionState createState() => _PermissionState();
}

class _PermissionState extends State<Permission> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Permissões"),
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
      ),
      body: true ? SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(cStyles.PADDING_DEFAULT_SCREEN),
            child: Column(
              children: [
                _myVehicles != null && _myVehicles!.length > 0 ?
                GestureDetector(
                  onTap: (){
                    setState(() => _myVehiclesOpened = !_myVehiclesOpened);
                  },
                  child:Card(
                    color: Colors.white,
                    child:  Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Text(
                            "Veículos próprios",
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Spacer(),
                          _myVehiclesOpened ? Icon(Icons.arrow_drop_up_rounded) : Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                ) : Container(),
                _myVehiclesOpened ?
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: _myVehicles!.length,
                    itemBuilder: (_, index){
                      eVehicle vehicle = _myVehicles![index];
                      return  Dismissible(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Card(
                            child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          vehicle.model,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18
                                          ),
                                        ),
                                        Text(" - "),
                                        Text(
                                          vehicle.sign,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Assentos",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Text(": "),
                                        Text(
                                          vehicle.seats,
                                          style: TextStyle(
                                              color: Colors.grey
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Malas",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Text(": "),
                                        Text(
                                          vehicle.luggageSpaces,
                                          style: TextStyle(
                                              color: Colors.grey
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                )
                            ),
                          ),
                        ),
                        confirmDismiss: (d) async {
                          if(d == DismissDirection.startToEnd) {
                            Navigator.pushNamed(
                                context,
                                cRoutes.VEHICLES_REGISTER,
                                arguments: vehicle
                            );
                            return false;
                          } else {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Confirmar exclusão"),
                                  content: Text("Tem certeza que deseja cancelar este carro?"),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () => Navigator.of(context).pop(true),
                                        child: Text("Tenho certeza")
                                    ),
                                    TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            "Cancelar",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        )
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        key: Key(vehicle.id),
                        background: Container(
                          color: Colors.green,
                          child: Icon(Icons.edit),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 15),
                          margin: EdgeInsets.only(bottom: 20),
                        ),
                        secondaryBackground: Container(
                          color: Colors.redAccent,
                          child: Icon(Icons.delete),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 15),
                          margin: EdgeInsets.only(bottom: 20),
                        ),
                      );
                    }
                ) : Container()
              ],
            ),
          )
      ) : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Não há usuários cadastrados ainda",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          )
      ),
    );
  }
}
