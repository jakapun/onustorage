

import 'package:flutter/material.dart';
import 'package:onu_storage/src/screen/find_detonunew.dart';
import 'package:onu_storage/src/screen/findone_two.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class FindOne extends StatefulWidget {


  @override
  _FindOneState createState() => _FindOneState();
}


class _FindOneState extends State<FindOne> {

  // explicit
  final formKey = GlobalKey<FormState>();
  String name, radiovalue = '',token = '', qrCodeString ='';
  SharedPreferences prefs;

  //method 
  @override
  void initState() {
    // เริ่มทำงานตรงนี้ก่อนที่อื่น
  super.initState();
  readToken();
  }

  Future<void> readToken() async {
  prefs = await SharedPreferences.getInstance();
  token = prefs.getString('stoken');
  print('$token');
  }

  Widget showScanButton() {
    return RaisedButton.icon(
      icon: Icon(Icons.android),
      label: Text('กด Scan Serial'),
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

  Widget showhpage() {
    return Column(
      children: <Widget>[
        Text(
          'ดูสถานะ ONU ล่าสุด',
          style: TextStyle(fontSize: 25.0),
        ),
        // Text('เก็บคืน ONU')
      ],
    );
  }

  Widget radiocheck1() {
    return Container(
      width: 220.0,
      child: RadioButtonGroup(
          labels: [
            "ONU(NEW)",
            "ONU เก่าเก็บใช้ใหม่",
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
          labelText: 'เลขวงจร/Serial :',
          helperText: 'CircuitId/Serial',
          hintText: 'พิมพ์เลขวงจร/Serial',
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

  Widget uploadValueButton() {
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FloatingActionButton(
          child: Icon(Icons.cloud_upload),
          onPressed: () {
            formKey.currentState.save();
              if ((name.isEmpty) && (qrCodeString.isEmpty)) {
                myAlert('มีข้อผิดพลาด', 'ไม่มีการพิมพ์ หรือการ scan');
              } else if ((name.isEmpty) && (qrCodeString.length > 6)) {
                name = qrCodeString;
                myAlert('App จะCopy', 'ข้อความที่ได้จากการสแกน \r\n มาเป็นเงื่อนไขในการค้น');
                if (radiovalue == 'ONU(NEW)'){
                 // { "_id" : ObjectId("5e9047f0669fb407db3ee821"), "DeviceListID" : "list20200409034746211", "letterID" : "doc20200409034614010", "DeviceTypeName" : "ONU", "DeviceBrandName" : "ZTE", "DeviceModelName" : "ZXHN-F670L-OFTK", "Serial" : "ZTEGC8C7BBDB", "mac" : "C85A9FA1F5CA", "Status" : "ติดตั้งเรียบร้อย", "Province" : "SSK", "CounterService" : "ศูนย์บริการ ขุขันธ์", "Circuit" : "4567J7110", "CreatedDate" : ISODate("2020-04-08T17:22:04.221Z"), "CreatedBy" : "ชุติ​กาญจน์​ เสนา​ภ​ั​ก​ดิ์", "__v" : 0 }
                print('radio = $radiovalue, circuitid = $name');
                var addChildrenRoute = MaterialPageRoute( //condition: radiovalue, datafind: name.toUpperCase()
                builder: (BuildContext context) => FindDetNOnu(datafind: name.toUpperCase()));
                Navigator.of(context).push(addChildrenRoute);
                
                }else{
                  print('radio = $radiovalue, circuitid = $name');
                var addChildrenRoute = MaterialPageRoute( //condition: radiovalue, datafind: name.toUpperCase()
                builder: (BuildContext context) => OnuModel(condition: radiovalue, datafind: name.toUpperCase()));
                Navigator.of(context).push(addChildrenRoute);
                }
              } else if((name.length > 6) && (qrCodeString.length > 6)){
                myAlert('App จะเลือก', 'ข้อความที่ได้จากการพิมพ์ \r\n มาเป็นเงื่อนไขในการค้น');
                if (radiovalue == 'ONU(NEW)'){
                 // { "_id" : ObjectId("5e9047f0669fb407db3ee821"), "DeviceListID" : "list20200409034746211", "letterID" : "doc20200409034614010", "DeviceTypeName" : "ONU", "DeviceBrandName" : "ZTE", "DeviceModelName" : "ZXHN-F670L-OFTK", "Serial" : "ZTEGC8C7BBDB", "mac" : "C85A9FA1F5CA", "Status" : "ติดตั้งเรียบร้อย", "Province" : "SSK", "CounterService" : "ศูนย์บริการ ขุขันธ์", "Circuit" : "4567J7110", "CreatedDate" : ISODate("2020-04-08T17:22:04.221Z"), "CreatedBy" : "ชุติ​กาญจน์​ เสนา​ภ​ั​ก​ดิ์", "__v" : 0 }
                print('radio = $radiovalue, circuitid = $name');
                var addChildrenRoute = MaterialPageRoute( //condition: radiovalue, datafind: name.toUpperCase()
                builder: (BuildContext context) => FindDetNOnu(datafind: name.toUpperCase()));
                Navigator.of(context).push(addChildrenRoute);
                
                }else{
                  print('radio = $radiovalue, circuitid = $name');
                var addChildrenRoute = MaterialPageRoute( //condition: radiovalue, datafind: name.toUpperCase()
                builder: (BuildContext context) => OnuModel(condition: radiovalue, datafind: name.toUpperCase()));
                Navigator.of(context).push(addChildrenRoute);
                }
              } else {
                // check name,detail
                if (radiovalue == 'ONU(NEW)'){
                 // { "_id" : ObjectId("5e9047f0669fb407db3ee821"), "DeviceListID" : "list20200409034746211", "letterID" : "doc20200409034614010", "DeviceTypeName" : "ONU", "DeviceBrandName" : "ZTE", "DeviceModelName" : "ZXHN-F670L-OFTK", "Serial" : "ZTEGC8C7BBDB", "mac" : "C85A9FA1F5CA", "Status" : "ติดตั้งเรียบร้อย", "Province" : "SSK", "CounterService" : "ศูนย์บริการ ขุขันธ์", "Circuit" : "4567J7110", "CreatedDate" : ISODate("2020-04-08T17:22:04.221Z"), "CreatedBy" : "ชุติ​กาญจน์​ เสนา​ภ​ั​ก​ดิ์", "__v" : 0 }
                print('radio = $radiovalue, circuitid = $name');
                var addChildrenRoute = MaterialPageRoute( //condition: radiovalue, datafind: name.toUpperCase()
                builder: (BuildContext context) => FindDetNOnu(datafind: name.toUpperCase()));
                Navigator.of(context).push(addChildrenRoute);
                
                }else{
                  print('radio = $radiovalue, circuitid = $name');
                var addChildrenRoute = MaterialPageRoute( //condition: radiovalue, datafind: name.toUpperCase()
                builder: (BuildContext context) => OnuModel(condition: radiovalue, datafind: name.toUpperCase()));
                Navigator.of(context).push(addChildrenRoute);
                }
                // chkonefindcon();
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
    return Form(
      key: formKey,
      child: ListView(
        padding: EdgeInsets.only(
          bottom: 50.0,
          right: 10.0,
          left: 10.0,
        ),
        children: <Widget>[
          showhpage(),
          SizedBox(
            height: 10.0,
          ),         
          radiocheck1(),
          SizedBox(
            height: 10.0,
          ),
          nameText(),
          showScanButton(),
          SizedBox(
            height: 5.0,
          ),
          SelectableText('$qrCodeString',
          style: TextStyle(fontSize: 18.0),
          textAlign: TextAlign.center,),
          SizedBox(
            height: 5.0,
          ),
          uploadValueButton(),
        ],
      ),

    );
  }

}