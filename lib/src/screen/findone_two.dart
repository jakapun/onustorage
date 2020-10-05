// import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onu_storage/models/onusec_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onu_storage/src/utility/my_constant.dart';
// String urlString = '${MyConstant().urltoServerApi}';

class OnuModel extends StatefulWidget {
  final String condition, datafind;

  OnuModel({
    Key key,
    @required this.condition,
    this.datafind,
  }) : super(key: key);

  @override
  _OnuModelState createState() => _OnuModelState();
}

class _OnuModelState extends State<OnuModel> {
  // Explicit
  String name, radiovalue = '', token = '';
  SharedPreferences prefs;
  List<OnusecModel> onuModels = [];

  // Method
  @override
  void initState() {
    super.initState();
    readAllData();
    // readToken();
    // finddata = widget.condition;
    // circuit = widget.datafind;
    // print('$finddata');
    // print('$circuit');
  }

  Future<void> readToken() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('stoken');
    print('$token');
  }

  Future<void> readAllData() async {
    // String urlString = 'http://8a7a0833c6dc.sn.mynetname.net:8099/api_v2/findonecon';
    String urlString = '${MyConstant().urltoServerApi}/findonecon';

    var body = {
      // "circuitn": name.toUpperCase(),
      // "condition": radiovalue,
      "circuitn": widget.datafind,
      "condition": widget.condition,
      // "circuitn": '4381J2393',
      // "condition": 'Serial',
    };
    // headers: {HttpHeaders.authorizationHeader: "JWT $token"},
    var response = await http.post(urlString, body: body);

    var result = json.decode(response.body);
    print('result = $result');
    myAlert('Show', result);

    // if (result.toString() == 'null') {
    if (response.body.length < 10) {
      myAlert('No Data', 'ไม่พบ ข้อมูล ที่ต้องการค้นหา');
    } else {
      for (var myOnuModel in result) {
        OnusecModel onuModel = OnusecModel.fromJSON(myOnuModel);
        setState(() {
          onuModels.add(onuModel);
        });
      }
    }
  }

  void myAlert(String titleString, String messageString) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: showTitleAlert(titleString),
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

  Widget showTitleAlert(String title) {
    return ListTile(
      leading: Icon(
        Icons.add_alert,
        size: 36.0,
        color: Colors.red,
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 24.0, color: Colors.red.shade800),
      ),
    );
  }

  Widget showCircuit(int index) {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        onuModels[index].circuitj,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  Widget showOnuID(int index) {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        onuModels[index].onuid,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  // laststatus = parseJSON['laststatus'];
  // chgmind = parseJSON['chgmind'];
  // afterclean = parseJSON['afterclean'];
  // reustatus = parseJSON['reustatus'];

  Widget showLaststa(int index) {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        onuModels[index].laststatus,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  Widget showChgmind(int index) {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        onuModels[index].chgmind,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  Widget showAfterCln(int index) {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        onuModels[index].afterclean,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  Widget showReuse(int index) {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        onuModels[index].reustatus,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  Widget showLogintime(int index) {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        onuModels[index].logintime,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  // Widget showDetail(int index) {
  //   String detailShot = onuModels[index].onuid;
  //   if (detailShot.length > 50) {
  //     detailShot = detailShot.substring(0, 50);
  //     detailShot = '$detailShot ...';
  //   }
  //   return Text(detailShot);
  // }

  Widget showText(int index) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width * 0.5,
      // height: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        children: <Widget>[
          showCircuit(index),
          // showOnuID(index),
          // showLaststa(index),
          // showChgmind(index),
          // showAfterCln(index),
          // showReuse(index),
        ],
      ),
    );
  }

  Widget showOnu(int index) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width * 0.5,
      // height: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        children: <Widget>[
          showOnuID(index),
          // showLaststa(index),
          // showChgmind(index),
          // showAfterCln(index),
          // showReuse(index),
        ],
      ),
    );
  }

  Widget showLast(int index) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width * 0.5,
      // height: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        children: <Widget>[
          showLaststa(index),
          // showChgmind(index),
          // showAfterCln(index),
          // showReuse(index),
        ],
      ),
    );
  }

  Widget showChgmid(int index) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width * 0.5,
      // height: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        children: <Widget>[
          showChgmind(index),
          // showAfterCln(index),
          // showReuse(index),
        ],
      ),
    );
  }

  Widget showAfCln(int index) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width * 0.5,
      // height: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        children: <Widget>[
          showAfterCln(index),
          // showReuse(index),
        ],
      ),
    );
  }

  Widget showReused(int index) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width * 0.5,
      // height: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        children: <Widget>[
          showReuse(index),
        ],
      ),
    );
  }

  Widget showlogintimee(int index) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width * 0.5,
      // height: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        children: <Widget>[
          showLogintime(index),
        ],
      ),
    );
  }

  Widget showOnuList() {
    return ListView.builder(
      itemCount: onuModels.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          child: Container(
            decoration: index % 2 == 0
                ? BoxDecoration(color: Colors.orange.shade100)
                : BoxDecoration(color: Colors.orange.shade300),
            child: Column(
              children: <Widget>[
                showText(index),
                showOnu(index),
                showChgmid(index),
                showLast(index),
                // showAfCln(index),
                showReused(index),
                showlogintimee(index),
              ],
            ),
          ),
          onTap: () {
            print('You Click Index $index');
            // MaterialPageRoute materialPageRoute = MaterialPageRoute(
            //     builder: (BuildContext context) => DetailFood(
            //           foodModel: foodModels[index],
            //         ));
            // Navigator.of(context).push(materialPageRoute);
          },
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
          title: Text('รายละเอียด ONU'),
          // actions: <Widget>[uploadButton()],
        ),
        body: Form(
          child: showOnuList(),
        )

        // return showOnuList();
        );
  }
}
