import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DelUser extends StatefulWidget {
  @override
  _DelUserState createState() => _DelUserState();
}

class _DelUserState extends State<DelUser> {

  final formKey = GlobalKey<FormState>();
  String emailString;

  @override
  void initState() {
    super.initState();
  }

  Future<void> postdeluser() async {
    // http://8a7a08360daf.sn.mynetname.net:2528/api/getprovince";
    String urlpost = "http://8a7a0833c6dc.sn.mynetname.net:8099/api_v2/deleteuseronu";
    var body = {
      "username": emailString.trim()
    };
    //setUpDisplayName();
    // var response = await get(urlString);
    var response = await http.post(urlpost, body: body);

    if (response.statusCode == 200) {
      print(response.statusCode);
      var result = json.decode(response.body);
      // print('result = $result');

      if (result.toString() == 'null') {
        myAlert('Not Insert/Delete', 'No In my Database');
      } else {
        if (result['status']) {
          String getmessage = result['message'];
          myAlert('OK', '$getmessage');
        } else {
          myAlert('Not OK', 'message = Null');
        }
      }
    } else {
      //check respond = 200
      myAlert('Error', response.statusCode.toString());
    }
  }

  Widget uploadButton() {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      onPressed: () {
        print('Upload');
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          print('Email = $emailString');
          _onShowCondition();
        }
      },
    );
  }

  Widget emailText() {
    return TextFormField(
      // keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'รหัส พนง.TOT/OS ที่จะลบ :',
        labelStyle: TextStyle(color: Colors.blue),
        helperText: 'TOT Employee Id/OS Id',
        helperStyle: TextStyle(color: Colors.blue),
        icon: Icon(
          Icons.email,
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

  Future<bool> _onShowCondition() {
    return showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text('Supervisor ต้องการลบ \r\n User ที่ทำรายการ จากระบบ ?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('No',
                      style: TextStyle(fontSize: 17.0, color: Colors.red[800])),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                    child: Text('Yes',
                        style: TextStyle(fontSize: 17.0, color: Colors.blue)),
                    onPressed: () {
                    postdeluser();
                    Navigator.pop(context, true);
                    })
              ],
            ));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: Text('ลบ User'),
        actions: <Widget>[uploadButton()],
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}