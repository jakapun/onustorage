import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onu_storage/src/widget/clone_userinfo2.dart';
//import 'package:imei_plugin/imei_plugin.dart';


class LoginPage extends StatefulWidget {


  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  final formKey = GlobalKey<FormState>();

  String emailString,
         passwordString;

  @override
  void initState() {
    super.initState();
    //checkAuthen();
  }

  void myAlert(String titleString, String messageString) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            titleString,
            style: TextStyle(color: Colors.red),
          ),
          content: Text(messageString),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Widget emailText() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'รหัสพนักงาน/OS :',
        labelStyle: TextStyle(color: Colors.blue),
        helperText: 'TOT Employee Id',
        helperStyle: TextStyle(color: Colors.blue),
        icon: Icon(
          Icons.account_circle,
          size: 36.0,
          color: Colors.blue,
        ),
      ),
      validator: (String value) {
        // if (!((value.contains('@')) && (value.contains('.')))) {
        if (value.length <= 5) {
          return 'Type Employee Id';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        emailString = value.toUpperCase();
      },
    );
  }

  Widget passwordText() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'พาสเวิร์ด :',
        labelStyle: TextStyle(color: Colors.green),
        helperText: 'More 6 digit',
        helperStyle: TextStyle(color: Colors.green),

        icon: Icon(
          Icons.lock,
          size: 36.0,
          color: Colors.green,
        ),
      ),
      validator: (String value) {
        if (value.length <= 5) {
          return 'Password Much More 6 Charactor';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        passwordString = value;
      },
      obscureText: true,
    );
  }

  Widget uploadValueButton() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center, // จัดตำแหน่ง FloatingActionButton
      children: <Widget>[
        FloatingActionButton(
          elevation: 15.0,
          // foregroundColor: Colors.green[900],
          tooltip: 'กดเพื่อ Login',
          child: Icon(
            Icons.cloud_upload,
            size: 40.0,
          ),

          onPressed: () {
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
              if ((emailString.length < 4) || (passwordString.length < 4)) {
                myAlert('มีข้อผิดพลาด',
                    'ไม่มี Username  \r\n ไม่มี Password \r\n ที่ต้องใช้งาน');
              } else {
                print(
                    'Username = $emailString, Password = $passwordString');
          var addChildrenRoute = MaterialPageRoute(  // -->post_ionu.dart
          builder: (BuildContext context) => Cloneuser2(username: emailString, password: passwordString));
          Navigator.of(context).push(addChildrenRoute);
              }
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: Text('ล๊อกอินด้วย User/Pass'),
        // actions: <Widget>[uploadButton()],
      ),
      body: Form(
        key: formKey,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 60.0),
          child: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.8),
            ),
            width: 300.0,
            height: 700.0,
            child: Column(
              children: <Widget>[
                emailText(),
                passwordText(),
                uploadValueButton()
              ],
            ),
          ),
        ),
      ),
    );
  }
}