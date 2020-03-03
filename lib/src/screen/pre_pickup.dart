import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:onu_storage/src/screen/post_ionu.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Prepick extends StatefulWidget {
  @override
  _PrepickState createState() => _PrepickState();
}

class _PrepickState extends State<Prepick> {

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String qrCodeString = '', tempprv, temprela, token = '', tempuid = '';
  bool _isButtonDisabled = true;
  SharedPreferences prefs;

  
  @override
  void initState() {
    // เริ่มทำงานตรงนี้ก่อนที่อื่น
    super.initState();
    getsharepref();
  }

  Future<void> getsharepref() async {

    prefs = await SharedPreferences.getInstance();
    // await prefs.setString('srelate', result['relate']);
    // await prefs.setString('sfulln', result['fulln']);
    tempprv = prefs.getString('sprv');
    temprela = prefs.getString('srelate');
    token = prefs.getString('stoken');
    tempuid = prefs.getString('suid');

  }

  Widget showTextOne() {
    return Text(
      'เช็ค Barcode Serial ONU',
      style: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          color: Colors.brown[800],
          fontFamily: 'PermanentMarker'),
    );
  }

  Widget showText() {
    return Container(
      alignment: Alignment.center,
      child: SelectableText(
        '$qrCodeString',
        style: TextStyle(fontSize: 24.0),
        textAlign: TextAlign.center,
      ),
    );
  }

  // SelectableText('$qrCodeString',
  //         style: TextStyle(fontSize: 20.0),
  //         textAlign: TextAlign.center,),

  Widget showButton() {
    return RaisedButton.icon(
      icon: Icon(Icons.android),
      label: Text('กด Scan SerialONU'),
      onPressed: () {
        qrProcess();
        // print('lat = $lat, lng = $lng, qrtxt = $qrCodeString');
      },
    );
  }

  Future<void> qrProcess() async {
    try {
      String codeString = await BarcodeScanner.scan();

      if (codeString.length != 0) {
        setState(() {
          qrCodeString = codeString;
        });
        // myShowSnackBar('$codeString');
        // print('lat = $lat, lng = $lng, qrtxt = $qrCodeString');
      }
    } catch (e) {}
  }

  void myShowSnackBar(String messageString) {
    SnackBar snackBar = SnackBar(
      content: Text(messageString),
      backgroundColor: Colors.green[700],
      duration: Duration(seconds: 15),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
        textColor: Colors.orange,
      ),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Widget mySizeBox() {
    return SizedBox(
      width: 8.0,
      height: 100.0,
    );
  }

  Widget mySizeBoxH() {
    return SizedBox(
      height: 15.0,
    );
  }

  Widget uploadValueButton() {
    // return IconButton(
    //   icon: Icon(Icons.cloud_upload),
    //   onPressed: () {},
    // );
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center, // จัดตำแหน่ง FloatingActionButton
      children: <Widget>[
        FloatingActionButton(
          tooltip: 'กดเพื่อ Forward ข้อมูล',
          child: Icon(Icons.cloud_upload),
          onPressed: () {
            if (qrCodeString.isEmpty) {
              myAlert('มีข้อผิดพลาด',
                  'กรุณาเปิดการใช้ Location และแสกน \r\n Barcode/QRcode อีกรอบ \r\n ก่อนกด Upload');
            } else {
              print('qrtxt = $qrCodeString');
              // prechkninstall
              sendchkonu();
              // var addChildrenRoute = MaterialPageRoute(
              // builder: (BuildContext context) => StampOut(lastqrtxt: qrCodeString));
              // Navigator.of(context).push(addChildrenRoute);
            }
          },
        ),
      ],
    );
  }

  Widget showTextnull() {
    return Container(
      alignment: Alignment.center,
      child: SelectableText(
        // '$qrCodeString',
        'serial onu ไม่มี/เคยใช้งาน \r\n จะไม่มีปุ่ม upload เพื่อทำรายการ',
        style: TextStyle(fontSize: 24.0, color: Colors.red[700]),
      ),
    );
  }

  void myAlert(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future<void> sendchkonu() async {
    // addgroup

    String urlpost = "http://8a7a0833c6dc.sn.mynetname.net:8099/api_v2/prechkninstall"; //req.body.onuid
    //req.body.onuid
    var body = {
      "onuid": qrCodeString.trim(),
      // "qrtext": qrCodeString.trim()
    };
    
    var response = await http.post(urlpost, headers: {HttpHeaders.authorizationHeader: "JWT $token"}, body: body);

    if (response.statusCode == 200) {
      print(response.statusCode);
      var result = json.decode(response.body);

      if (result.toString() == 'null') {
        myAlert('Not Stampin', 'No Stampin,put data in my Database');
      } else {
        if (_isButtonDisabled == true){
        setState(() {
          _isButtonDisabled = false;
        });
        }else{
          print('_isButtonDisabled = false');
        }
        if ((result['status']) && (result['success'])) {
          // String getmessage = result['message2'];

          // result['dtype']
          // result['dname']
          // result['dmodel']

           
          var addChildrenRoute = MaterialPageRoute(
          builder: (BuildContext context) => Postinstall(lastqrtxt: qrCodeString, sdtype: result['dtype'], sdname: result['dname'], sdmodel: result['dmodel'] ));
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
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          showTextOne(),
           //mySizeBox(),
          showButton(),
          mySizeBoxH(),
          showText(),
          mySizeBoxH(),
          uploadValueButton(),
          // (_isButtonDisabled == false) ? showTextnull() : uploadValueButton(),
        ],
      ),
    );
  }
}