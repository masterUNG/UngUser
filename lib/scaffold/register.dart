import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unguser/utility/normal_dialog.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Field
  File file;
  String name, user, password;
  final formKey = GlobalKey<FormState>();
  String nameImage;

  // Method
  Widget nameForm() {
    Color color = Colors.purple;
    return Container(
      width: 250.0,
      child: TextFormField(
        onSaved: (String string) {
          name = string.trim();
        },
        decoration: InputDecoration(
          icon: Icon(
            Icons.face,
            size: 36.0,
            color: color,
          ),
          labelText: 'Display Name :',
          labelStyle: TextStyle(color: color),
          helperText: 'Type Your Name in Blank',
          helperStyle: TextStyle(color: color),
          hintText: 'English Only',
        ),
      ),
    );
  }

  Widget userForm() {
    Color color = Colors.green;
    return Container(
      width: 250.0,
      child: TextFormField(
        onSaved: (String string) {
          user = string.trim();
        },
        decoration: InputDecoration(
          icon: Icon(
            Icons.account_circle,
            size: 36.0,
            color: color,
          ),
          labelText: 'User :',
          labelStyle: TextStyle(color: color),
          helperText: 'Type Your User in Blank',
          helperStyle: TextStyle(color: color),
          hintText: 'English Only',
        ),
      ),
    );
  }

  Widget passwordForm() {
    Color color = Colors.blue;
    return Container(
      width: 250.0,
      child: TextFormField(
        onSaved: (String string) {
          password = string.trim();
        },
        decoration: InputDecoration(
          icon: Icon(
            Icons.lock,
            size: 36.0,
            color: color,
          ),
          labelText: 'Password :',
          labelStyle: TextStyle(color: color),
          helperText: 'Type Your Password in Blank',
          helperStyle: TextStyle(color: color),
          hintText: 'English Only',
        ),
      ),
    );
  }

  Widget cameraButton() {
    return OutlineButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      icon: Icon(Icons.add_a_photo),
      label: Text('Camera'),
      onPressed: () {
        cameraThread();
      },
    );
  }

  Future<void> cameraThread() async {
    var cameraFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 800.0,
      maxHeight: 480.0,
    );

    setState(() {
      file = cameraFile;
    });
  }

  Widget galleryButton() {
    return OutlineButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      icon: Icon(Icons.add_photo_alternate),
      label: Text('Gallery'),
      onPressed: () {
        galleryThread();
      },
    );
  }

  Future<void> galleryThread() async {
    var galleryFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800.0,
      maxHeight: 480.0,
    );

    setState(() {
      file = galleryFile;
    });
  }

  Widget showButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        cameraButton(),
        SizedBox(
          width: 5.0,
        ),
        galleryButton(),
      ],
    );
  }

  Widget avatarImage() {
    return Container(
      height: 200.0,
      child: file == null ? Image.asset('images/avatar.png') : Image.file(file),
    );
  }

  Widget registerButton() {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      onPressed: () {
        formKey.currentState.save();

        if (file == null) {
          normalDialog(
              context, 'Non Choose Avatar', 'Please Choose Camera or Gallery');
        } else if (name.isEmpty || user.isEmpty || password.isEmpty) {
          normalDialog(context, 'Have Space', 'Please Fill All Every Blank');
        } else {
          uploadImageToServer();
        }
      },
    );
  }

  Future<void> uploadImageToServer() async {
    Random random = Random();
    int number = random.nextInt(10000);
    nameImage = 'avatar$number.jpg';
    print('nameImage = $nameImage');
    String url = 'https://www.androidthai.in.th/bow/saveFileUng.php';
    try {
      Map<String, dynamic> map = Map();
      map['file'] = UploadFileInfo(file, nameImage);
      FormData formData = FormData.from(map);
      Response response = await Dio().post(url, data: formData);
      print('response = $response');
      uploadMySQL();
    } catch (e) {}
  }

  Future<void> uploadMySQL() async {

    String avatar = 'https://www.androidthai.in.th/bow/Upload/$nameImage';

    String url = 'https://www.androidthai.in.th/bow/addUserMaster.php?isAdd=true&Name=$name&User=$user&Password=$password&Avatar=$avatar';

    Response response = await Dio().get(url);
    print('response = $response');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[registerButton()],
        title: Text('Register'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(30.0),
          children: <Widget>[
            avatarImage(),
            showButton(),
            nameForm(),
            userForm(),
            passwordForm(),
          ],
        ),
      ),
    );
  }
}
