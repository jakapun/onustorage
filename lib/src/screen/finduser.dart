import 'package:flutter/material.dart';
import 'package:onu_storage/src/screen/finduser_two.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class FindUsers extends StatefulWidget {
  @override
  _FindUsersState createState() => _FindUsersState();
}

class _FindUsersState extends State<FindUsers> {

  // explicit
  final formKey = GlobalKey<FormState>();
  String name, radiovalue = '',token = '';
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

  Widget showhpage() {
    return Column(
      children: <Widget>[
        Text(
          'ค้นรายละเอียด User',
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
            // "Serial",
            "เลขวงจร",
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
          labelText: 'รหัสพนักงาน/ชื่อ :',
          helperText: 'รหัสพนักงาน/ชื่อ',
          hintText: 'พิมพ์ รหัสพนักงาน/ชื่อ',
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
              if (name.isEmpty) {
                myAlert('Have Space', 'Please Fill Data');
              } else {
                // check name,detail
                radiovalue = 'Serial/CircuitID';
                print('radio = $radiovalue, circuitid = $name');
                var addChildrenRoute = MaterialPageRoute( //condition: radiovalue, datafind: name.toUpperCase()
                builder: (BuildContext context) => FindUsersTwo(datafind: name));
                Navigator.of(context).push(addChildrenRoute);
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
    // return Form(
    //   key: formKey,
    //   child: ListView(
    //     padding: EdgeInsets.only(
    //       bottom: 50.0,
    //       right: 10.0,
    //       left: 10.0,
    //     ),
    //     children: <Widget>[
    //       showhpage(),
    //       SizedBox(
    //         height: 10.0,
    //       ),         
    //       // radiocheck1(),
    //       SizedBox(
    //         height: 10.0,
    //       ),
    //       nameText(),
          
    //       SizedBox(
    //         height: 10.0,
    //       ),
    //       uploadValueButton(),
    //     ],
    //   ),

    // );
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: Text('ค้นข้อมูล USER ในระบบ'),
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
            width: 400.0,
            height: 700.0,
            child: Column(
              children: <Widget>[
                SizedBox(
            height: 10.0,
          ),
          nameText(),
          
          SizedBox(
            height: 10.0,
          ),
          uploadValueButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}