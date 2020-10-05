import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:onu_storage/models/newonu_model.dart';
import 'package:onu_storage/src/utility/my_constant.dart';
// String urlString = '${MyConstant().urltoServerApi}';

class FindDetNOnu extends StatefulWidget {
  final String datafind;

  FindDetNOnu({
    Key key,
    @required this.datafind,
  }) : super(key: key);

  @override
  _FindDetNOnuState createState() => _FindDetNOnuState();
}

class _FindDetNOnuState extends State<FindDetNOnu> {
  String name;
  List<NonuModel> nonusModels = [];

  @override
  void initState() {
    super.initState();
    readAllData();
  }

  Future<void> readAllData() async {
    // String urlString = 'http://8a7a0833c6dc.sn.mynetname.net:8099/api_v2/findnewonui';
    String urlString = '${MyConstant().urltoServerApi}/findnewonui';

    var body = {
      "nonucondi": widget.datafind,
    };
    // headers: {HttpHeaders.authorizationHeader: "JWT $token"},
    var response = await http.post(urlString, body: body);
    // letterID Serial mac Status CounterService Circuit
    var result = json.decode(response.body);
    print('result = $result');
    myAlert('Show', result);
    
    if (response.body.length < 10) {
      myAlert('No Data', 'ไม่พบ ข้อมูล ที่ต้องการค้นหา');
    } else {
      for (var myNonuModel in result) {
        NonuModel nonuModel = NonuModel.fromJSON(myNonuModel);
        setState(() {
          nonusModels.add(nonuModel);
        });
      }
    }
  }

  // letterID = parseJSON['letterID'];
  //   serial = parseJSON['Serial'];
  //   mac = parseJSON['mac'];
  //   status = parseJSON['Status'];
  //   counterService = parseJSON['CounterService'];
  //   circuit = parseJSON['Circuit'];

  // ////////////////////
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

  Widget showLetterID(int index) {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        nonusModels[index].letterID,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  Widget showSerial(int index) {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        nonusModels[index].serial,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  Widget showMac(int index) {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        nonusModels[index].mac,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  Widget showStatus(int index) {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        nonusModels[index].status,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  Widget showCounterService(int index) {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        (nonusModels[index].counterService == null)
            ? 'no CounterService'
            : nonusModels[index].counterService,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  Widget showCircuit(int index) {
    return Container(
      alignment: Alignment.topLeft,
      //((lat.toString().isEmpty) || (_isButtonDisabled == false)) ? showTextnull() : uploadValueButton(),
      child: Text(
        (nonusModels[index].circuit == null)
            ? 'no Circuit ID'
            : nonusModels[index].circuit,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  // ////////////////////

  Widget sLetterID(int index) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width * 0.5,
      // height: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        children: <Widget>[
          showLetterID(index),
        ],
      ),
    );
  }

  Widget sSerial(int index) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width * 0.5,
      // height: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        children: <Widget>[
          showSerial(index),
        ],
      ),
    );
  }

  Widget sMac(int index) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width * 0.5,
      // height: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        children: <Widget>[
          showMac(index),
        ],
      ),
    );
  }

  Widget sStatus(int index) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width * 0.5,
      // height: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        children: <Widget>[
          showStatus(index),
        ],
      ),
    );
  }

  Widget sCounterService(int index) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width * 0.5,
      // height: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        children: <Widget>[
          //((lat.toString().isEmpty) || (_isButtonDisabled == false)) ? showTextnull() : uploadValueButton(),
          showCounterService(index),
        ],
      ),
    );
  }

  Widget sCircuit(int index) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width * 0.5,
      // height: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        children: <Widget>[
          showCircuit(index),
        ],
      ),
    );
  }

  // ////////////////////

  Widget showDtailNOnu() {
    return ListView.builder(
      itemCount: nonusModels.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          child: Container(
            decoration: index % 2 == 0
                ? BoxDecoration(color: Colors.orange.shade100)
                : BoxDecoration(color: Colors.orange.shade300),
            child: Column(
              children: <Widget>[
                sLetterID(index),
                sSerial(index),
                sMac(index),
                sStatus(index),
                sCounterService(index),
                sCircuit(index),
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
          title: Text('รายละเอียด ONU(NEW)'),
          // actions: <Widget>[uploadButton()],
        ),
        body: Form(
          child: showDtailNOnu(),
        )

        // return showUserList();
        );
  }
}
