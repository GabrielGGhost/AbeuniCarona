import 'dart:io';

import 'package:abeuni_carona/Constants/DbData.dart';
import 'package:abeuni_carona/Entity/eUser.dart';
import 'package:abeuni_carona/Entity/eVehicle.dart';
import 'package:abeuni_carona/Styles/MyStyles.dart';
import 'package:abeuni_carona/Util/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:abeuni_carona/Constants/cStyle.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:abeuni_carona/Constants/cRoutes.dart';

class RegisterUserPicture extends StatefulWidget {
  eUser? u;
  RegisterUserPicture(this.u);

  @override
  _RegisterUserPictureState createState() => _RegisterUserPictureState();
}

class _RegisterUserPictureState extends State<RegisterUserPicture> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  XFile? _image;

  void _choosePicture(cameraPick) async {
    final image;
    final ImagePicker picker = ImagePicker();
    if (cameraPick == ImageSource.camera) {
      image = await picker.pickImage(source: ImageSource.camera);
    } else {
      image = await picker.pickImage(source: ImageSource.gallery);
    }

    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Foto do usuário",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RawMaterialButton(
                  onPressed: () {
                    _choosePicture(ImageSource.camera);
                  },
                  elevation: 2.0,
                  fillColor: APP_BAR_BACKGROUND_COLOR,
                  child: Icon(
                    Icons.camera_alt,
                    size: 35.0,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(15.0),
                  shape: CircleBorder(),
                ),
                RawMaterialButton(
                  onPressed: () {
                    _choosePicture(ImageSource.gallery);
                  },
                  elevation: 2.0,
                  fillColor: APP_BAR_BACKGROUND_COLOR,
                  child: Icon(
                    Icons.collections_sharp,
                    size: 35.0,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(15.0),
                  shape: CircleBorder(),
                )
              ],
            ),
            _image != null
                ? Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(cStyles.PADDING_DEFAULT_SCREEN),
                        child: Image.file(File(_image!.path)),
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
                            "Continuar",
                            style: (TextStyle(
                                color: APP_WHITE_FONT, fontSize: 20)),
                          ),
                          onPressed: () {
                            saveUser(user);
                          },
                        ),
                      )
                    ],
                  )
                : Container()
          ],
        ),
      )),
    );
  }

  void saveUser(eUser? user) {
    user!.file = this._image!;
    try {
      Navigator.pushNamed(
        context,
          cRoutes.REGISTER_USER_PASSWORD,
          arguments: user
      );

    } catch (e) {
      Utils.showToast(
          AppLocalizations.of(context)!.erroAoAtualizar, APP_ERROR_BACKGROUND);
    }
  }

  void insert(eUser? user) {
    db.collection(DbData.TABLE_USER).add(user!.toMap());
  }

  bool checkFields() {
    return true;
  }

  void goToPhones() {}
}
