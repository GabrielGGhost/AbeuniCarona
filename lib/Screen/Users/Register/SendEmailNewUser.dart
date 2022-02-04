import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';

class SendEmailNewUser extends StatefulWidget {
  const SendEmailNewUser({Key? key}) : super(key: key);

  @override
  _SendEmailNewUserState createState() => _SendEmailNewUserState();
}

class _SendEmailNewUserState extends State<SendEmailNewUser> {

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  Timer? timer;

  @override
  void initState() {

    user = auth.currentUser;
    user!.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerifyed();
    });

    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
    user = auth.currentUser;

    if(!user!.emailVerified){
      user!.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            "Um e-mail de verificação foi enviado para ${user!.email} o e-mail informado.\nAo validar o e-mail, você será levado para a tela de login.\n NÃO sair desta tela, se sair sem validar o e-mail seu cadastro será cancelado."
          )
        ],
      ),
    );
  }

  Future<void> checkEmailVerifyed() async {
    user = auth.currentUser;
    await user!.reload();

    if(user!.emailVerified){
      timer!.cancel();
      Navigator.pushNamed(
          context,
          cRoutes.LOGIN
      );
    }
  }
}
