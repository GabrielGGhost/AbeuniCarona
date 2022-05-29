import 'dart:io';

import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Entity/eUser.dart';
import 'package:abeuni_carona/Entity/eVehicle.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';
import 'package:abeuni_carona/Constants/cImages.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RegisterUserPassword extends StatefulWidget {
  eUser? u;
  RegisterUserPassword(this.u);

  @override
  _RegisterUserPasswordState createState() => _RegisterUserPasswordState();
}

class _RegisterUserPasswordState extends State<RegisterUserPassword> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  double? radiusBorder = 16;

  TextEditingController _passwordController = TextEditingController();

  FocusNode? _passowrdFocus;
  bool _hidePassword = true;

  @override
  void initState() {
    super.initState();

    _passowrdFocus = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _passowrdFocus!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    eUser? user = widget.u;

    return Scaffold(
      appBar: AppBar(
        title: Text("Imagem"),
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
                controller: _passwordController,
                obscureText: _hidePassword,
                focusNode: _passowrdFocus,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    hintText: "Senha" + AppLocalizations.of(context)!.obr,
                    filled: true,
                    suffixIcon: IconButton(
                      onPressed: () => {
                        setState(() {
                          print(_hidePassword);
                          _hidePassword = !_hidePassword;
                        })
                      },
                      icon: Icon(Icons.remove_red_eye),
                    ),
                    fillColor: APP_TEXT_FIELD_BACKGROUND,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(radiusBorder!))),
              ),
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
                  saveUser(user);
                },
              ),
            )
          ],
        ),
      )),
    );
  }

  void saveUser(eUser? user) {
    try {
      if (checkFields()) {
        insert(user!);
        Utils.showToast("Usuário registrado", APP_SUCCESS_BACKGROUND);
      }
    } catch (e) {
      Utils.showToast(
          AppLocalizations.of(context)!.erroAoAtualizar, APP_ERROR_BACKGROUND);
    }
  }

  void insert(eUser user) {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseStorage store = FirebaseStorage.instance;

    auth
        .createUserWithEmailAndPassword(
            email: user.email, password: _passwordController.text)
        .then((fireBaseUser) {
      FirebaseFirestore db = FirebaseFirestore.instance;
      db
          .collection(DbData.TABLE_USER)
          .doc(fireBaseUser.user!.uid)
          .set(user.toMap());
      Reference root = store.ref();
      Reference file = root
          .child(cImages.STORAGE_PATH)
          .child("${fireBaseUser.user!.uid}." + cImages.TYPE_JPG);

      UploadTask task = file.putFile(File(user.file.path));

      task.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            break;
          case TaskState.success:
            getUrlImage(taskSnapshot, fireBaseUser.user!.uid);
            break;
        }
      });

      Navigator.pushNamed(context, cRoutes.SEND_EMAIL_NEW_USER);
    }).catchError((error) {
      Utils.showAuthError(error.code, context);
    });
  }

  Future getUrlImage(TaskSnapshot taskSnapshot, userId) async {
    String url = await taskSnapshot.ref.getDownloadURL();

    FirebaseFirestore db = FirebaseFirestore.instance;

    Map<String, dynamic> data = {DbData.COLUMN_PICTURE_PATH: url};

    db.collection(DbData.TABLE_USER).doc(userId).update(data);
  }

  bool checkFields() {
    if (_passwordController.text.trim().length == 0) {
      Utils.showDialogBox("É necessário informar a senha do usuário", context);
      return false;
    }

    if (_passwordController.text.trim().length < 6) {
      Utils.showDialogBox(
          "A senha necessita de ao menos 6 caracteres", context);
      return false;
    }

    return true;
  }

  void goToPhones() {}
}
