import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:onu_storage/src/screen/lastsubmit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:grouped_buttons/grouped_buttons.dart';


class DelWserial extends StatefulWidget {
  @override
  _DelWserialState createState() => _DelWserialState();
}

class _DelWserialState extends State<DelWserial> {

  // Explicit

  final formKey = GlobalKey<FormState>();
  String serialString = '', token = '', radiovalue = '';
  SharedPreferences prefs;
  bool imageBool = false, _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    readSharePrefer();
  }
 
  // Method

  Future<void> readSharePrefer() async {

    prefs = await SharedPreferences.getInstance();
    // var ab = (tempprv.split('-'));
    // firsta = ab[0];
    token = prefs.getString('stoken');
  }

  Widget serialText() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Serial :',
        labelStyle: TextStyle(color: Colors.brown),
        helperText: ' พิมพ์ serail number',
        helperStyle: TextStyle(color: Colors.brown),
        icon: Icon(
          Icons.border_outer,
          size: 36.0,
          color: Colors.blue,
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'กรุณาพิมพ์ Serial ของอุปกรณ์';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        serialString = value;
      },
    );
  }

  Widget showtxt() {
    return Column(
      children: <Widget>[
        Text(
          '',
          style: TextStyle(fontSize: 20.0),
        ),
        Text('เคยมีการกด ลบด้วย Serial')
      ],
    );
  }

  Widget radiocheck1() {
    return Container(
      width: 280.0,
      child: RadioButtonGroup(
          labels: [
            "ลบ Serial ONU(NEW)",
            "ลบ Serial ONU เก่าเก็บจากลูกค้า",
          ],
          disabled: [
            // "In Area"
          ],
          onChange: (String label, int index) => print("label: $label index: $index"),
          onSelected: (String label) => radiovalue = label,
        ),
      // onSaved: (String value) {
      //     passwordString = value;
      //   },
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
          tooltip: 'กดเพื่อจะลบข้อมูล ONU/อุปกรณ์',
          child: Icon(
            Icons.cloud_upload,
            size: 40.0,
          ),

          onPressed: () {
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
              if (serialString.length < 8) {
                myAlert('มีข้อผิดพลาด',
                    'ไม่มีข้อมูล Serial หรือสั้นเกินไป\r\n ของ Device \r\n ที่ต้องการลบ');
              } else {
                print('Serial อุปกรณ์ = $serialString ,radiovalue = $radiovalue');
                senddelwserial();
              }
            }
          },
        ),
      ],
    );
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

  Future<void> senddelwserial() async {
             
          // cpeid: req.body.onuid,
          // laststatus: req.body.cstatus,
          // userlast: req.body.uid,

    print('call post senddelwserial -> /api_v2/delwserial');

    String urlpost = "http://8a7a0833c6dc.sn.mynetname.net:8099/api_v2/delwserial";
    
    var body = {

      "serialid": serialString.trim(),
      "condition": radiovalue.trim(),
    };
    
    var response = await http.post(urlpost, headers: {HttpHeaders.authorizationHeader: "JWT $token"}, body: body);

    if (response.statusCode == 200) {
      print(response.statusCode);
      var result = json.decode(response.body);
      // print('result = $result');

      if (result.toString() == 'null') {
        myAlert('Not Success', 'No ,put data in my Database');
      } else {
        if (_isButtonDisabled == true){
        setState(() {
          _isButtonDisabled = false; // disable ปุ่ม
        });
        }else{
          print('_isButtonDisabled = false');
        }
        if ((result['status']) && (result['success'])) {
          
          // String getmessage = ' บันทึกข้อมูล เก็บคืน/ขอใช้ต่อ OK';
          String getmessage = result['message2'];
          print('$getmessage');
          var addChildrenRoute = MaterialPageRoute( //condition: radiovalue, datafind: name.toUpperCase()
          builder: (BuildContext context) => LastSubM(successtxt: getmessage));
          Navigator.of(context).push(addChildrenRoute);

        } else {
          String getmessage = result['message2'];
          myAlert('Not OK', '$getmessage');
        }
      }
    } else {
      //check respond = 200
      myAlert('Error', response.statusCode.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: Text('ลบข้อมูล ONU/อุปกรณ์'),
        // actions: <Widget>[uploadButton()],
      ),
      body: Form(
        key: formKey,
        child: Container(
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage('images/bg.png'),
          //     fit: BoxFit.cover,
          //   ),
          // ),
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
                SizedBox(
                  height: 10.0,
                ),
                radiocheck1(),
                SizedBox(
                  height: 10.0,
                ),
                serialText(),
                SizedBox(
                  height: 10.0,
                ),
                // uploadValueButton(),    
                (_isButtonDisabled) ? uploadValueButton() : showtxt(),
              ],
            ),
          ),
        ),
      )
    );
  }
}