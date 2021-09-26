import 'package:abeuni_carona/Entity/eVehicle.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';

class RideRegister_2 extends StatefulWidget {
  const RideRegister_2({Key? key}) : super(key: key);

  @override
  _RideRegister_2State createState() => _RideRegister_2State();
}

class _RideRegister_2State extends State<RideRegister_2> {

  List<eVehicle> _myVehicles = eVehicle.getVehicles();
  List<eVehicle> _myBorrowedVehicles = eVehicle.getVehicles();
  bool _myVehiclesOpened = false;
  bool _borrowedVehiclesOpened = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de evento"),
        backgroundColor: APP_BAR_BACKGROUND_COLOR,
      ),
      body: _myVehicles != null && _myVehicles.length > 0 ||
          _myBorrowedVehicles != null && _myBorrowedVehicles.length > 0
          ?
      SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(cStyles.PADDING_DEFAULT_SCREEN),
            child: Column(
              children: [
                _myVehicles != null && _myVehicles.length > 0 ?
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
                    itemCount: _myVehicles.length,
                    itemBuilder: (_, index){
                      eVehicle vehicle = _myVehicles[index];
                      return Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.pushNamed(
                                context,
                                cRoutes.REGISTER_RIDE3
                              );
                            },
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
                          )
                      );
                    }
                ) : Container(),
                _myBorrowedVehicles != null && _myBorrowedVehicles.length > 0 ?
                GestureDetector(
                  onTap: (){
                    setState(() => _borrowedVehiclesOpened = !_borrowedVehiclesOpened);
                  },
                  child:Card(
                    color: Colors.white,
                    child:  Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Text(
                            "Veículos emprestados",
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Spacer(),
                          _borrowedVehiclesOpened ? Icon(Icons.arrow_drop_up_rounded) : Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                ): Container(),
                _borrowedVehiclesOpened ?
                ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: _myBorrowedVehicles.length,
                    itemBuilder: (_, index){

                      eVehicle vehicle = _myBorrowedVehicles[index];

                      return Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.pushNamed(
                                context,
                                cRoutes.REGISTER_RIDE3
                              );
                            },
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
                        )
                      );
                    }
                ) : Container(),
              ],
            ),
          )
      ) : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Não há veículos\ncadastrados ou disponíveis!\nRegistre um para programar\numa carona ",
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
