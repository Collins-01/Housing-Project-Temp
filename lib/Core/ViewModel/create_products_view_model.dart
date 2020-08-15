import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:housing_project/Constants/button_round_shape.dart';
import 'package:housing_project/Constants/custom_text_form_field.dart';
import 'package:housing_project/Constants/flutter_toast_messages.dart';
import 'package:housing_project/Core/Models/product_model.dart';
import 'package:housing_project/Core/Services/Notifiers/database_notifier.dart';
import 'package:housing_project/Utilities/loading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class CreateDocumentsViewModel extends StatefulWidget {
  @override
  _CreateDocumentsViewModelState createState() =>
      _CreateDocumentsViewModelState();
}

class _CreateDocumentsViewModelState extends State<CreateDocumentsViewModel> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  bool loading = false;
  File imageFile1;
  File imageFile2;
  File imageFile3;
  File imageFile4;
  String description;
  String price;
  String location;
  String imageUrl1;
  String imageUrl2;
  String imageUrl3;
  String imageUrl4;
  String phoneNo;
  String email;
  String state;
  String town;

  @override
  Widget build(BuildContext context) {
    print("hehbhf");
    var productProvider = Provider.of<DatabaseNotf>(context);

    DateTime now = new DateTime.now();
    DateFormat datestamp = new DateFormat("HH:mm");
    String timeStamp = datestamp.format(now).toString();

    print(timeStamp);
    return loading
        ? Loading()
        : Scaffold(
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Form(
                key: _key,
                child: ListView(
                  children: <Widget>[
                    Container(
                      height: 250,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.all(5),
                        physics: ScrollPhysics(),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(border: Border.all()),
                              width: 230,
                              height: 230,
                              // color: Colors.black,
                              child: _displayImage1(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(border: Border.all()),
                              width: 230,
                              height: 230,
                              // color: Colors.black,
                              child: _displayImage2(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                decoration: BoxDecoration(border: Border.all()),
                                width: 230,
                                height: 230,
                                // color: Colors.black,
                                child: _displayImage3()),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                decoration: BoxDecoration(border: Border.all()),
                                width: 230,
                                height: 230,
                                // color: Colors.black,
                                child: _displayImage4()),
                          ),
                        ],
                      ),
                    ), // =====================Build Description Field=================
                    CustomTextFormField(
                      hintText: "PLease Enter Your Description Here",
                      validator: (val) => val.isEmpty || val.length > 350
                          ? "Please he Description Placeholder musn't be empty"
                          : null,
                      onSaved: (String val) => description = val,
                    ),

                    // ======================Build Email Text Field==========
                    CustomTextFormField(
                      hintText: "*Required!!,Email Address",
                      validator: (String val) {
                        Pattern pattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regex = new RegExp(pattern);
                        return val.isEmpty || !regex.hasMatch(val)
                            ? "PLEASE ENTER A VALID EMAIL ADDRESS"
                            : null;
                      },
                      onSaved: (String val) => email = val,
                    ),
                    // ===================Build Price Text Field==========
                    CustomTextFormField(
                      hintText: "Price is required!!",
                      validator: (val) => val.isEmpty || val.length > 9
                          ? "Please he Price Placeholder musn't be empty"
                          : null,
                      onSaved: (String val) => price = val,
                    ),
                    // =========================user Phone No===============
                    CustomTextFormField(
                      hintText: "Phone Number is required!!",
                      validator: (val) =>
                          val.isEmpty || val.length > 15 || val.length < 15
                              ? "Please enter a valid phoneNo"
                              : null,
                      onSaved: (String val) => phoneNo = val,
                    ),
                    // ==============Build State Text Field========
                    CustomTextFormField(
                      hintText: "Please a State where the item is!!",
                      validator: (val) => val.isEmpty ||
                              val.length > 12 ||
                              !val.startsWith(RegExp(r'[A-Z]'))
                          ? "Please Enter a State in your Country  Stating with Camel Case"
                          : null,
                      onSaved: (String val) => state = val,
                    ),
                    // =======================Building Town Field==============
                    CustomTextFormField(
                      hintText: "Please enter a Town or LGA in that Area!!",
                      validator: (val) => val.isEmpty ||
                              val.length > 12 ||
                              !val.startsWith(RegExp(r'[A-Z]'))
                          ? "Please Enter a Town in your State,Starting with Camel case"
                          : null,
                      onSaved: (String val) => town = val,
                    ),

                    // ================Building a Submit Button==================
                    Container(
                      margin: EdgeInsets.all(17),
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        shape: buttonRoundShape(),
                        onPressed: () async {
                          if (_key.currentState.validate() &&
                              imageFile1 != null &&
                              imageFile2 != null &&
                              imageFile3 != null &&
                              imageFile4 != null) {
                            _key.currentState.save();
                            setState(() {
                              loading = true;
                            });
                            await uploadFile1().then(
                              (file2) => uploadFile2().then(
                                (file3) => uploadFile3().then(
                                  (file4) => uploadFile4().then((upload) async {
                                    await productProvider
                                        .addProduct(Product(
                                      description: description,
                                      email: email,
                                      imageUrl1: imageUrl1,
                                      imageUrl2: imageUrl2,
                                      imageUrl3: imageUrl3,
                                      imageUrl4: imageUrl4,
                                      phoneNo: phoneNo,
                                      price: price,
                                      state: state,
                                      town: town,
                                      timeStamp: timeStamp,
                                    ))
                                        .whenComplete(() {
                                      print("Uploading Was successfull");
                                      Navigator.of(context).pop();
                                      ToastMessages().showToast(
                                          "Bravo!!!,Upload Was Successful");
                                    });
                                  }),
                                ),
                              ),
                            );
                          } else {
                            setState(() => loading = false);
                            ToastMessages().showToast(
                                "Please Make Sure All Images are Selected,and the Form is valid");
                            return;
                          }
                        },
                        child: Text(
                          "Create",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Future _pickImage(Future<File> pickImageFile, int imageNumber) async {
    File temporaryImageFile = await pickImageFile;
    switch (imageNumber) {
      case 1:
        setState(() => imageFile1 = temporaryImageFile);
        break;
      case 2:
        setState(() => imageFile2 = temporaryImageFile);
        break;
      case 3:
        setState(() => imageFile3 = temporaryImageFile);
        break;
      case 4:
        setState(() => imageFile4 = temporaryImageFile);
        break;
    }
  }

  // =================Display ImageFile 1==============
  Widget _displayImage1() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        imageFile1 != null
            ? Image.file(
                imageFile1,
                fit: BoxFit.contain,
              )
            : Container(),
        imageFile1 != null
            ? FlatButton(
                color: Colors.black.withOpacity(0.6),
                onPressed: () {
                  _pickImage(
                      // ignore: deprecated_member_use
                      ImagePicker.pickImage(source: ImageSource.gallery),
                      1);
                },
                child: Text(
                  "Change Image",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : FlatButton(
                color: Colors.black.withOpacity(0.6),
                onPressed: () {
                  _pickImage(
                      // ignore: deprecated_member_use
                      ImagePicker.pickImage(source: ImageSource.gallery),
                      1);
                },
                child: Text(
                  "select Image",
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ],
    );
  }
  // ========================Display ImageFile 2===================

  Widget _displayImage2() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        imageFile2 != null
            ? Image.file(
                imageFile2,
                fit: BoxFit.contain,
              )
            : Container(),
        imageFile2 != null
            ? FlatButton(
                color: Colors.black.withOpacity(0.6),
                onPressed: () {
                  _pickImage(
                      // ignore: deprecated_member_use
                      ImagePicker.pickImage(source: ImageSource.gallery),
                      2);
                },
                child: Text(
                  "Change Image",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : FlatButton(
                color: Colors.black.withOpacity(0.6),
                onPressed: () {
                  _pickImage(
                      // ignore: deprecated_member_use
                      ImagePicker.pickImage(source: ImageSource.gallery),
                      2);
                },
                child: Text(
                  "select Image",
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ],
    );
  }
  // =============Display ImageFile 3================

  Widget _displayImage3() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        imageFile3 != null
            ? Image.file(
                imageFile3,
                fit: BoxFit.contain,
              )
            : Container(),
        imageFile3 != null
            ? FlatButton(
                color: Colors.black.withOpacity(0.6),
                onPressed: () {
                  _pickImage(
                      // ignore: deprecated_member_use
                      ImagePicker.pickImage(source: ImageSource.gallery),
                      3);
                },
                child: Text(
                  "Change Image",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : FlatButton(
                color: Colors.black.withOpacity(0.6),
                onPressed: () {
                  _pickImage(
                      // ignore: deprecated_member_use
                      ImagePicker.pickImage(source: ImageSource.gallery),
                      3);
                },
                child: Text(
                  "select Image",
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ],
    );
  }
  // ========================Display ImageFile 4=============

  Widget _displayImage4() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        imageFile4 != null
            ? Image.file(
                imageFile4,
                fit: BoxFit.contain,
              )
            : Container(),
        imageFile4 != null
            ? FlatButton(
                color: Colors.black.withOpacity(0.6),
                onPressed: () {
                  _pickImage(
                      // ignore: deprecated_member_use
                      ImagePicker.pickImage(source: ImageSource.gallery),
                      4);
                },
                child: Text(
                  "Change Image",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : FlatButton(
                color: Colors.black.withOpacity(0.6),
                onPressed: () {
                  _pickImage(
                      // ignore: deprecated_member_use
                      ImagePicker.pickImage(source: ImageSource.gallery),
                      4);
                },
                child: Text(
                  "select Image",
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ],
    );
  }

  Future uploadFile1() async {
    var fileExtension = path.extension(imageFile1.path);
    var uuid = Uuid().v4();
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('Images/$uuid$fileExtension');
    StorageUploadTask uploadTask = storageReference.putFile(imageFile1);
    await uploadTask.onComplete;
    print("Image Uploaded");
    await storageReference
        .getDownloadURL()
        .then((getDownloadUrl) => setState(() {
              imageUrl1 = getDownloadUrl;
            }));
  }

  Future uploadFile2() async {
    var fileExtension = path.extension(imageFile2.path);
    var uuid = Uuid().v4();
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('Images/$uuid$fileExtension');
    StorageUploadTask uploadTask = storageReference.putFile(imageFile2);
    await uploadTask.onComplete;
    print("Image Uploaded");
    await storageReference
        .getDownloadURL()
        .then((getDownloadUrl) => setState(() {
              imageUrl2 = getDownloadUrl;
            }));
  }

  Future uploadFile3() async {
    var fileExtension = path.extension(imageFile3.path);
    var uuid = Uuid().v4();
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('Images/$uuid$fileExtension');
    StorageUploadTask uploadTask = storageReference.putFile(imageFile3);
    await uploadTask.onComplete;
    print("Image Uploaded");
    await storageReference
        .getDownloadURL()
        .then((getDownloadUrl) => setState(() {
              imageUrl3 = getDownloadUrl;
            }));
  }

  Future uploadFile4() async {
    var fileExtension = path.extension(imageFile4.path);
    var uuid = Uuid().v4();
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('Images/$uuid$fileExtension');
    StorageUploadTask uploadTask = storageReference.putFile(imageFile4);
    await uploadTask.onComplete;
    print("Image Uploaded");
    await storageReference
        .getDownloadURL()
        .then((getDownloadUrl) => setState(() {
              imageUrl4 = getDownloadUrl;
            }));
  }
}
