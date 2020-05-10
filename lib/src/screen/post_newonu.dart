import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:location/location.dart';
import 'package:onu_storage/src/screen/lastsubmit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:grouped_buttons/grouped_buttons.dart';


class StampOut extends StatefulWidget {
 
  // lastqrtxt: qrCodeString, sdtype: result['dtype'], sdname: result['dname'], sdmodel: result['dmodel']
  final String lastqrtxt, sdtype, sdname, sdmodel;

  StampOut({
    Key key,
    @required this.lastqrtxt, this.sdtype, this.sdname, this.sdmodel,
  }) : super(key: key);

  @override
  _StampOutState createState() => _StampOutState();
}

class _StampOutState extends State<StampOut> {
  // Explicit
  
  final formKey = GlobalKey<FormState>();
  String qrCodeString = '', tempprv, temprela, token = '', tempuid = '', radiovalue, name, tempcs = '', firsta;
  String  getlastqr = '', getdtype = '', getdname = '', getdmodel = '';
  double lat = 0, lng = 0;
  bool _isButtonDisabled = false;
  SharedPreferences prefs;

  // method

  @override
  void initState() {
    // เริ่มทำงานตรงนี้ก่อนที่อื่น
    super.initState();
    setState(() {
      getlastqr = widget.lastqrtxt;
      getdtype = widget.sdtype;
      getdname = widget.sdname;
      getdmodel = widget.sdmodel;
    });
    _isButtonDisabled = true;
    findLatLng();
  }

  Widget showTextOne() {
    return Text(
      'ติดตั้ง ONU ใหม่(ไม่เคยใช้)',
      style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.brown[800],
          fontFamily: 'PermanentMarker'),
    );
  }

  Widget showText() {
    return Container(
      alignment: Alignment.center,
      child: SelectableText(
        // '$qrCodeString',
        '$lat',
        style: TextStyle(fontSize: 24.0),
      ),
    );
  }

  Widget showButton() {
    return RaisedButton.icon(
      // icon: Icon(Icons.android),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      icon: Icon(Icons.crop_free),
      label: Text('สแกน MAC:'),
      onPressed: () {
        qrProcess();
        // print('lat = $lat, lng = $lng, qrtxt = $qrCodeString');
      },
    );
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

  Future<void> findLatLng() async {

    prefs = await SharedPreferences.getInstance();
    // await prefs.setString('srelate', result['relate']);
    // await prefs.setString('sfulln', result['fulln']);
    tempprv = prefs.getString('sprv');
    var ab = (tempprv.split('-'));
    firsta = ab[0];
    temprela = prefs.getString('srelate');
    token = prefs.getString('stoken');
    tempuid = prefs.getString('suid');
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

  Future<void> sendstampout() async {
    // addgroup

    String urlpost = "http://8a7a0833c6dc.sn.mynetname.net:8099/api_v2/newonuinstall";
    
    var body = {
      "chkuid": tempuid.trim(),
      "glati": lat.toString(),
      "glong": lng.toString(),
      "ndivision": temprela.trim(),
      "mactext": qrCodeString.trim(),
      "province": tempprv.trim(),
      "cservice": tempcs.trim(),
      "tinstall": radiovalue,
      "serial": getlastqr.trim(),
      "dtype": getdtype,
      "dname": getdname,
      "dmodel": getdmodel,
      "circuid": name.toUpperCase(),
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
          String getmessage = result['message'];
      
          var addChildrenRoute = MaterialPageRoute( //condition: radiovalue, datafind: name.toUpperCase()
          builder: (BuildContext context) => LastSubM(successtxt: getmessage));
          Navigator.of(context).push(addChildrenRoute);

        } else {
          String getmessage = result['message'];
          myAlert('Not OK', '$getmessage');
        }
      }
    } else {
      //check respond = 200
      myAlert('Error', response.statusCode.toString());
    }
  }

  // void myShowSnackBar(String messageString) {
  //   SnackBar snackBar = SnackBar(
  //     content: Text(messageString),
  //     backgroundColor: Colors.green[700],
  //     duration: Duration(seconds: 15),
  //     action: SnackBarAction(
  //       label: 'Close',
  //       onPressed: () {},
  //       textColor: Colors.orange,
  //     ),
  //   );
  //   scaffoldKey.currentState.showSnackBar(snackBar);
  // }


  Widget radiocheck1() {
    return Container(
      width: 220.0,
      child: RadioButtonGroup(
          labels: [
            "Route Mode",
            "Bridge Mode",
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

  Widget nameText() {
    return Container(
      margin: EdgeInsets.only(left: 50.0, right: 50.0),
      child: TextFormField(
        autofocus: true,
        initialValue: '',
        style: new TextStyle(
                color: Colors.red,
                fontSize: 20.0,
              ),
        decoration: InputDecoration(
          labelText: 'เลขวงจร:',
          helperText: 'Text Your Display CircuitId',
          hintText: 'กรุณาพิมพ์เลขวงจร',
          icon: Icon(
          Icons.email,
          size: 36.0,
          color: Colors.blue,
        ),
        ),
        onSaved: (String value) {
          name = value.trim();
        },
      ),
    );
  }

  Widget showLat() {
    return Column(
      children: <Widget>[
        Text(
          'Latitude',
          style: TextStyle(fontSize: 20.0),
        ),
        Text('$lat')
      ],
    );
  }

  Widget showLng() {
    return Column(
      children: <Widget>[
        Text(
          'Longitude',
          style: TextStyle(fontSize: 20.0),
        ),
        Text('$lng')
      ],
    );
  }

  Widget mySizeBox() {
    return SizedBox(
      width: 8.0,
      height: 100.0,
    );
  }

  Widget mySizeBoxH() {
    return SizedBox(
      height: 25.0,
    );
  }

  Widget showTextnull() {
    return Container(
      alignment: Alignment.center,
      child: SelectableText(
        // '$qrCodeString',
        'เคยกดบันทึกออกแล้ว \r\n จะไม่มีปุ่ม upload เพื่อทำรายการ',
        style: TextStyle(fontSize: 24.0, color: Colors.red[700]),
      ),
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
          elevation: 15.0,
          // foregroundColor: Colors.red[900],
          tooltip: 'กดเพื่อ Upload',
          child: Icon(Icons.cloud_upload, size: 40.0,),
          onPressed: () {
            formKey.currentState.save();
            if ((lat.toString().isEmpty) || (getlastqr.isEmpty) || (qrCodeString.isEmpty)) {
              myAlert('มีข้อผิดพลาด',
                  'กรุณาเปิดการใช้ Location/Scan Serial/MAC: \r\n ก่อนกด Upload');
            } else {
              print('circuidid = $name, mac = $qrCodeString, typei = $radiovalue, lat = $lat, lng = $lng, qrtxt = $getlastqr, prv = $tempprv, nvision = $temprela');
              //(_isButtonDisabled) ? sendstamp() : myShowSnackBar('User Press Button > 1 Click');
              sendstampout();
            }
          },
        ),
      ],
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


  @override
  Widget build(BuildContext context) {
    // return Form(
    //   key: formKey,

    //   child: ListView(
    //       padding: EdgeInsets.only(
    //       bottom: 50.0,
    //       right: 10.0,
    //       left: 10.0,
    //     ),
    //     children: <Widget>[
          
    //       mySizeBoxH(),
    //       showTextOne(),
    //       mySizeBoxH(),
    //       showButton(),
    //       SelectableText('$qrCodeString',
    //       style: TextStyle(fontSize: 18.0),
    //       textAlign: TextAlign.center,),
    //       mySizeBoxH(),
    //       nameText(),
    //       mySizeBoxH(),
    //       radiocheck1(),
    //       mySizeBoxH(),
    //       SelectableText('$getlastqr',
    //       style: TextStyle(fontSize: 18.0),
    //       textAlign: TextAlign.center,),
    //       mySizeBoxH(),
    //       showText(),
    //       mySizeBoxH(),
    //       // ((qrCodeString.isEmpty) || (lat.toString().isEmpty) || (_isButtonDisabled == false)) ? showTextnull() : uploadValueButton(),
    //       ((lat.toString().isEmpty) || (_isButtonDisabled == false)) ? showTextnull() : uploadValueButton(),
    //     ],
    //   ),
      
    // );
    return Form(
      key: formKey,

      child: ListView(
        padding: EdgeInsets.only(
          bottom: 50.0,
          right: 10.0,
          left: 10.0,
        ),
        children: <Widget>[
          showTextOne(),
          mySizeBoxH(),
          showButton(),
          SizedBox(
            height: 10.0,
          ),
          SelectableText('$qrCodeString',
          style: TextStyle(fontSize: 20.0),
          textAlign: TextAlign.center,),
          SizedBox(
            height: 10.0,
          ),
          SizedBox(
            height: 10.0,
          ),
          nameText(),
          radiocheck1(),
          SizedBox(
            height: 5.0,
          ),
          SelectableText('$lat,$lng',
          style: TextStyle(fontSize: 18.0, backgroundColor: Colors.orange[200], color: Colors.black),
          textAlign: TextAlign.center,),
          SizedBox(
            height: 5.0,
          ),
          ((lat.toString().isEmpty) || (_isButtonDisabled == false)) ? showTextnull() : uploadValueButton(),
        ],
      ),

    );
  }
}