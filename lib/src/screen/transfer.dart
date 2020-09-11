import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:onu_storage/src/screen/lastsubmit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:http/http.dart' as http;
// import 'package:onu_storage/src/utility/my_constant.dart';

class Transfer extends StatefulWidget {
  @override
  _TransferState createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  String name,
      detail,
      code,
      urlPicture,
      contactnum,
      textscan,
      qrCodeString = '',
      model1 = '',
      firsta = '';
  String tempprv, temprela, tempcs, token = '', tempuid = '', radiovalue = '';
  SharedPreferences prefs;
  double lat, lng;
  final formKey = GlobalKey<FormState>();
  File file;
  bool imageBool = false, _isButtonDisabled = true;

// method
  @override
  void initState() {
    // เริ่มทำงานตรงนี้ก่อนที่อื่น
    super.initState();
    findLatLng();
    //this.getSWData();
  }

  Future<void> findLatLng() async {
    prefs = await SharedPreferences.getInstance();

    tempprv = prefs.getString('sprv');
    var ab = (tempprv.split('-'));
    firsta = ab[0];
    temprela = prefs.getString('srelate');
    token = prefs.getString('stoken');
    tempuid = prefs.getString('suid');
    // await prefs.setString('sfulln', result['fullname']);
    tempcs = prefs.getString('scouters');

    var currentLocation = await findLocationData();

    if (currentLocation == null) {
      myAlert('Location Error', 'Please Open GPS&Allow use Location');
    } else {
      setState(() {
        lat = currentLocation.latitude;
        lng = currentLocation.longitude;
      });
    }
  }

  Future<LocationData> findLocationData() async {
    var location = Location();

    try {
      return await location.getLocation();
    } catch (e) {
      print('Error = $e');
      return null;
    }
  }

  Future<void> scanThread() async {
    try {
      String codeString = '';
      codeString = await BarcodeScanner.scan();

      if (codeString.length != 0) {
        setState(() {
          qrCodeString = codeString;
          print('$qrCodeString');
        });
        // myShowSnackBar('$codeString');
        // print('lat = $lat, lng = $lng, qrtxt = $qrCodeString');
      }
    } catch (e) {}
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

  // Widget showImage() {
  //   return Container(
  //     margin: EdgeInsets.only(top: 50.0),
  //     height: 200.0,
  //     child: File == null ? Image.asset('images/pic.png') : Image.file(file),
  //   );
  // }

  Widget showTextOne() {
    return Text(
      'รับโอน ONU เข้า\r\n ONU ต้องผ่านการตรวจสอบแล้ว',
      style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.brown[800],
          fontFamily: 'PermanentMarker'),
    );
  }

  Widget showButton() {
    return Container(
      width: 200.0,
      // color: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        // children: <Widget>[cameraButton(), galleryButton()],
        children: <Widget>[scanButton()],
      ),
    );
  }

  Widget scanButton() {
    return IconButton(
      icon: Icon(
        Icons.crop_free,
        size: 48.0,
        color: Colors.green,
      ),
      onPressed: () {
        scanThread();
      },
    ); // Iconbutton == Click
  }

  Widget showButtonScan() {
    return RaisedButton.icon(
      icon: Icon(Icons.android),
      label: Text('กด Scan SerialONU'),
      onPressed: () {
        scanThread();
        // print('lat = $lat, lng = $lng, qrtxt = $qrCodeString');
      },
    );
  }

  Widget showhpage() {
    return Column(
      children: <Widget>[
        Text(
          'รับโอน ONU(ผ่านการตรวจ/พร้อมใช้)',
          style: TextStyle(fontSize: 22.0),
        ),
        // Text('เก็บคืน ONU')
      ],
    );
  }

  Widget uploadValueButton() {
    // return IconButton(
    //   icon: Icon(Icons.cloud_upload),
    //   onPressed: () {},
    // );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FloatingActionButton(
          child: Icon(Icons.cloud_upload),
          onPressed: () {
            formKey.currentState.save();
            if (qrCodeString.isEmpty) {
              myAlert('Have Not Value', 'Please Fill Data');
            } else {
              // check name,detail
              print(
                  'onuid = $qrCodeString, radio = $radiovalue, lat = $lat, lng = $lng');
              sendupstatustwo();
            }
          },
        ),
      ],
    );
  }

  Future<void> sendupstatustwo() async {
    // urlImage = '${MyConstant().urlImagePathShop}$string';
    // String urlAPI =
    //     '${MyConstant().urlAddUserShop}?isAdd=true&Name=$name&User=$user&Password=$password&UrlShop=$urlImage&Lat=$lat&Lng=$lng';
    //String url = MyConstant().urlSaveFile;
    // Random random = Random();
    // int i = random.nextInt(100000);
    // String nameFile = 'shop$i.jpg';

    // String urlcallapi = '${MyConstant().urltoServerApi}/transferonutwo';

    print('call post transfer onu');

    String urlpost =
        "http://8a7a0833c6dc.sn.mynetname.net:8099/api_v2/transferonutwo";

    var body = {
      "onuid": qrCodeString.trim(),
      "latitude": lat.toString(),
      "longitude": lng.toString(),
      "userlast": tempuid,
      // "gpath":
      "province": tempprv.trim(),
      "cservice": tempcs.trim(),
    };

    var response = await http.post(urlpost,
        headers: {HttpHeaders.authorizationHeader: "JWT $token"}, body: body);

    if (response.statusCode == 200) {
      print(response.statusCode);
      var result = json.decode(response.body);
      // print('result = $result');

      if (result.toString() == 'null') {
        myAlert('Not Success', 'No ,put data in my Database');
      } else {
        if (_isButtonDisabled == true) {
          setState(() {
            _isButtonDisabled = false; // disable ปุ่ม
          });
        } else {
          print('_isButtonDisabled = false');
        }
        if ((result['status']) && (result['success'])) {
          // String getmessage = ' บันทึกข้อมูล เก็บคืน/ขอใช้ต่อ OK';
          String getmessage = result['message2'];

          var addChildrenRoute = MaterialPageRoute(
              //condition: radiovalue, datafind: name.toUpperCase()
              builder: (BuildContext context) =>
                  LastSubM(successtxt: getmessage));
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
    //     return Form(
    //   key: formKey,

    //   child: ListView(
    //     padding: EdgeInsets.only(
    //       bottom: 50.0,
    //       right: 10.0,
    //       left: 10.0,
    //     ),
    //     children: <Widget>[
    //       SizedBox(
    //         height: 30.0,
    //       ),
    //       SizedBox(
    //         height: 20.0,
    //       ),
    //       showTextOne(),
    //       showButtonScan(),

    //       SizedBox(
    //         height: 10.0,
    //       ),
    //       SelectableText('$qrCodeString',
    //       style: TextStyle(fontSize: 20.0),
    //       textAlign: TextAlign.center,),

    //       SizedBox(
    //         height: 10.0,
    //       ),
    //       uploadValueButton(),
    //     ],
    //   ),

    // );

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          showTextOne(),
          //mySizeBox(),
          showButtonScan(),
          SizedBox(
            height: 10.0,
          ),
          SelectableText(
            '$qrCodeString',
            style: TextStyle(fontSize: 20.0),
            textAlign: TextAlign.center,
          ),

          SizedBox(
            height: 10.0,
          ),
          uploadValueButton(),
          // (_isButtonDisabled == false) ? showTextnull() : uploadValueButton(),
        ],
      ),
    );
  }
}
