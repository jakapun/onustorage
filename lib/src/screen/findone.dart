

import 'package:flutter/material.dart';
import 'package:onu_storage/src/screen/findone_two.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class FindOne extends StatefulWidget {


  @override
  _FindOneState createState() => _FindOneState();
}


class _FindOneState extends State<FindOne> {

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
              if (name.isEmpty) {
                myAlert('Have Space', 'Please Fill Data');
              } else {
                // check name,detail
                radiovalue = 'Serial/CircuitID';
                print('radio = $radiovalue, circuitid = $name');
                var addChildrenRoute = MaterialPageRoute( //condition: radiovalue, datafind: name.toUpperCase()
                builder: (BuildContext context) => OnuModel(condition: radiovalue, datafind: name.toUpperCase()));
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
          // radiocheck1(),
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

    );
  }

}