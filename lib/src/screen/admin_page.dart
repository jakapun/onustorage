import 'package:flutter/material.dart';
import 'package:onu_storage/src/screen/add_newsoon.dart';
import 'package:onu_storage/src/screen/delete_user.dart';
import 'package:onu_storage/src/screen/finduser.dart';
import 'package:onu_storage/src/screen/new_section.dart';
import 'package:onu_storage/src/screen/relate_id.dart';
import 'package:onu_storage/src/screen/set_privilege.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {

  double mySize = 100.0;
  // FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  String emailString = '', passwordString = '', getuname, temps;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Widget currentWidget;
  int temppriv = 0;
  SharedPreferences prefs;

  // Method

  @override
  void initState() {
    super.initState();
    checkStatus();
  }

  Future<void> checkStatus() async {
    // moveToService();
    prefs = await SharedPreferences.getInstance();
    setState(() {
      getuname = prefs.getString('suid');
      temps = prefs.getString('srelate');
      // temppriv = prefs.getInt('spriv');
      temppriv = (prefs.getInt('spriv') ?? 0);
    });
  }

  void moveToService() {
    // var serviceRoute =
    //     MaterialPageRoute(builder: (BuildContext context) => MyHome());
    // Navigator.of(context)
    //     .pushAndRemoveUntil(serviceRoute, (Route<dynamic> route) => false);
  }

  Widget mySizeBox() {
    return SizedBox(
      width: 8.0,
    );
  }

  Widget mySizeBoxH() {
    return SizedBox(
      height: 25.0,
    );
  }

  Widget singUpButton() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      color: Colors.green[900],
      child: Text(
        'สร้างข้อมูล ศูนย์/ส่วน',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        print('You Click SingUp');

        // Create Route
        // var registerRoute =
        //     MaterialPageRoute(builder: (BuildContext context) => Myservice());
        // Navigator.of(context).push(registerRoute);

        // Navigator.of(context).pop();
        // setState(() {
        //   currentWidget = NewSection();
        // });

        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) => NewSection());
        Navigator.of(context).push(materialPageRoute);
      },
    );
  }

  Widget singInButton() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      color: Colors.green[900],
      child: Text(
        'ผูก รหัสพนักงาน',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        // formKey.currentState.save();
        // checkAuthen();
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) => RelateId());
        Navigator.of(context).push(materialPageRoute);
      },
    );
  }

  Widget findUButton() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      color: Colors.green[900],
      child: Text(
        'ค้น USER',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        // formKey.currentState.save();
        // checkAuthen();
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) => FindUsers());
        Navigator.of(context).push(materialPageRoute);
      },
    );
  }

  
  Future<void> checkAuthen() async {
    print('email = $emailString, password = $passwordString');
    // await firebaseAuth
    //     .signInWithEmailAndPassword(
    //         email: emailString, password: passwordString)
    //     .then((response) {
    //   print('Authen Success');
    //   moveToService();
    // }).catchError((response) {
    //   String errorString = response.message;
    //   print('error = $errorString');
    //   myShowSnackBar(errorString);
    // });
  }

  Widget freeButton() {
    return OutlineButton(
      borderSide: BorderSide(color: Colors.green.shade900),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      color: Colors.green[900],
      child: Text(
        'กำหนดสิทธิ user',
        style: TextStyle(color: Colors.green.shade900),
      ),
      onPressed: () {
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) => SetPriv());
        Navigator.of(context).push(materialPageRoute);
      },
    );
  }

  Widget freeButton3() {
    return OutlineButton(
      borderSide: BorderSide(color: Colors.green.shade900),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      color: Colors.green[900],
      child: Text(
        'ลบ user',
        style: TextStyle(color: Colors.green.shade900),
      ),
      onPressed: () {
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) => DelUser());
        Navigator.of(context).push(materialPageRoute);
      },
    );
  }

  Widget createSoon() {
    return OutlineButton(
      borderSide: BorderSide(color: Colors.green.shade900),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      color: Colors.green[900],
      child: Text(
        'สร้างศูนย์...',
        style: TextStyle(color: Colors.green.shade900),
      ),
      onPressed: () {
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) => AddSoon());
        Navigator.of(context).push(materialPageRoute);
      },
    );
  }

  Widget freeButton2() {
    return OutlineButton(
      borderSide: BorderSide(color: Colors.green.shade900),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      color: Colors.green[900],
      child: Text(
        '',
        style: TextStyle(color: Colors.green.shade900),
      ),
      onPressed: () {
        print(temppriv.toString());
      },
    );
  }

  Widget myButton() {
    return Container(
      width: 220.0,
      child: Column(
        children: <Widget>[
          // singInButton(),
          // singInButton(),
          Row(
            children: <Widget>[
              Expanded(
                // child: singInButton(),
                child: (temppriv >=12) ? singInButton() : freeButton2(),
              ),
              mySizeBox(),
              Expanded(
                // child: singUpButton(),
                child: (temppriv >=12) ? findUButton() : freeButton2(),
              ),
            ],
          ),
          mySizeBoxH(),
          Row(
            children: <Widget>[
              Expanded(
                // child: freeButton2(),
                child: (temppriv >=12) ? createSoon() : freeButton2(),
              ),
              mySizeBox(),
              Expanded(
                // (temppriv == 4) ? menuAdmin() : mySizeBoxH(),
                child: (temppriv >=12) ? freeButton() : freeButton2(),
              ),
            ],
          ),
          mySizeBoxH(),
          Row(
            children: <Widget>[
              Expanded(
                child: freeButton2(),
              ),
              mySizeBox(),
              Expanded(
                // (temppriv == 4) ? menuAdmin() : mySizeBoxH(),
                child: (temppriv >=12) ? freeButton3() : freeButton2(),
              ),
            ],
          ),
        ],
      ),
      // child: Row(
      //   children: <Widget>[
      //     Expanded(
      //       child: singInButton(),
      //     ),
      //     mySizeBox(),
      //     Expanded(
      //       child: singUpButton(),
      //     ),
      //   ],
      // ),
    );
  }

  Widget passwordText() {
    return Container(
      width: 220.0,
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Password :',
          hintText: 'More 6 Charactor',
        ),
        onSaved: (String value) {
          passwordString = value;
        },
      ),
    );
  }

  Widget emailText() {
    return Container(
      width: 220.0,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'Email :',
          hintText: 'you@email.com',
        ),
        onSaved: (String value) {
          emailString = value;
        },
      ),
    );
  }

  Widget showLogo() {
    return Container(
      width: mySize,
      height: mySize,
      child: Image.asset(
        'images/logo.png',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget showText() {
    return Text(
      'Sup/Admin',
      style: TextStyle(
          fontSize: 45.0,
          fontWeight: FontWeight.bold,
          color: Colors.brown[800],
          fontFamily: 'PermanentMarker'),
    );
  }

  void myShowSnackBar(String messageString) {
    SnackBar snackBar = SnackBar(
      content: Text(messageString),
      backgroundColor: Colors.green[700],
      duration: Duration(seconds: 8),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
        textColor: Colors.orange,
      ),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: true,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [Colors.white, Colors.green.shade900],
              radius: 1.2,
            ),
          ),
          alignment: Alignment.center,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // showLogo(),
                showText(),
                mySizeBoxH(),
                myButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}