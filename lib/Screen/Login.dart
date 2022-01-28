import 'package:abeuni_carona/Util/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  FocusNode? _emailFocus;
  FocusNode? _passwordFocus;

  @override
  void initState() {
    super.initState();
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _emailFocus!.dispose();
    _passwordFocus!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        focusNode: _emailFocus,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            hintText: "Email" + AppLocalizations.of(context)!.obr,
                            filled: true,
                            fillColor: APP_TEXT_FIELD_BACKGROUND,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    APP_TEXT_EDIT_RADIUS_BORDER))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: TextField(
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        obscureText: true,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            hintText: "Email" + AppLocalizations.of(context)!.obr,
                            filled: true,
                            fillColor: APP_TEXT_FIELD_BACKGROUND,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    APP_TEXT_EDIT_RADIUS_BORDER))),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 12, right: 12),
                          child: Row(
                            children: [
                              GestureDetector(
                                child: Text(
                                  "Cadastrar-se",
                                  style: TextStyle(
                                      color: Colors.grey
                                  ),
                                ),
                                onTap: (){
                                  Navigator.pushNamed(context,
                                      cRoutes.REGISTER_USER);
                                },
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.all(20),
                        child: ElevatedButton(
                          style: TextButton.styleFrom(
                              backgroundColor: APP_BAR_BACKGROUND_COLOR,
                              padding: EdgeInsets.fromLTRB(28, 16, 28, 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          child: Text(
                            "Registrar",
                            style: (TextStyle(color: APP_WHITE_FONT, fontSize: 20)),
                          ),
                          onPressed: () {
                            login();
                          },
                        )),
                  ],
                ),
              )
            ]),
      ),
    );
  }

  void login() {
    if (checkFields()) {
      FirebaseAuth auth = FirebaseAuth.instance;

      auth
          .signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim())
          .then((value) {
        Navigator.pushReplacementNamed(context, cRoutes.INITIAL_ROUTE);
      }).catchError((error) {
        Utils.showAuthError(error.code, context);
      });
    }
  }

  bool checkFields() {
    if (_emailController.text.trim().length == 0) {
      Utils.showToast("Informe o email do usuário");
      return false;
    }

    if (_passwordController.text.trim().length == 0) {
      Utils.showToast("Informe a senha do usuário");
      return false;
    }

    return true;
  }
}
