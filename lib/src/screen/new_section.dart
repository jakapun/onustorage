import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewSection extends StatefulWidget {
  @override
  _NewSectionState createState() => _NewSectionState();
}

class _NewSectionState extends State<NewSection> {
  // Explicit
  final formKey = GlobalKey<FormState>();
  String nameString1, nameString2, abbrOString, abbrTString, _mySelection;
  // FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final String url =
      "http://8a7a0833c6dc.sn.mynetname.net:8099/api_v2/getprovince";

  List data = List(); //edited line

  Future<String> getSWData() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      data = resBody;
    });

    print(resBody);

    return "Sucess";
  }

  @override
  void initState() {
    super.initState();
    this.getSWData();
  }

  // Method
  Widget nameText1() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'ชื่อเต็ม ส่วนงาน :',
        labelStyle: TextStyle(color: Colors.pink[400]),
        helperText: 'ชื่อส่วนงาน',
        helperStyle: TextStyle(color: Colors.pink[400]),
        icon: Icon(
          Icons.face,
          size: 36.0,
          color: Colors.pink[400],
        ),
      ),
      validator: (String value) {
        if ((value.isEmpty) || (value.length <= 8)) {
          return 'พิมพ์ชื่อ ส่วนงาน';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        nameString1 = value;
      },
    );
  }

  Widget nameText2() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'ชื่อเต็ม ศูนย์ที่สังกัด :',
        labelStyle: TextStyle(color: Colors.orange[600]),
        helperText: 'ชื่อศูนย์',
        helperStyle: TextStyle(color: Colors.orange[600]),
        icon: Icon(
          Icons.assignment_ind,
          size: 36.0,
          color: Colors.orange[600],
        ),
      ),
      validator: (String value) {
        if ((value.isEmpty) || (value.length <= 8)) {
          return 'พิมพ์ชื่อ ศูนย์';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        nameString2 = value;
      },
    );
  }

  Widget abbrOneText() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'ตัวย่อส่วนงาน :',
        labelStyle: TextStyle(color: Colors.blue),
        helperText: 'ตัวย่อส่วน',
        helperStyle: TextStyle(color: Colors.blue),
        icon: Icon(
          Icons.email,
          size: 36.0,
          color: Colors.blue,
        ),
      ),
      validator: (String value) {
        if (value.length <= 3) {
          return 'พิมพ์ ตัวย่อส่วน';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        abbrOString = value;
      },
    );
  }

  Widget abbrTwoText() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'ตัวย่อศูนย์ ที่สังกัด :',
        labelStyle: TextStyle(color: Colors.green),
        helperText: 'ตัวย่อศูนย์',
        helperStyle: TextStyle(color: Colors.green),
        icon: Icon(
          Icons.lock,
          size: 36.0,
          color: Colors.green,
        ),
      ),
      validator: (String value) {
        if (value.length <= 3) {
          return 'พิมพ์ ตัวย่อศูนย์';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        abbrTString = value;
      },
    );
  }

  Widget dropdownButton() {
    return DropdownButton(
      icon: Icon(Icons.arrow_drop_down),
      hint: Text('กรุณาเลือก จังหวัด'),
      iconSize: 36,
      elevation: 26,
      style: TextStyle(
        color: Colors.deepPurple,
        fontSize: 18.0,
      ),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      items: data.map((item) {
        return new DropdownMenuItem(
          child: new Text(item['province']),
          value: item['EN'],
        );
      }).toList(),
      onChanged: (newVal) {
        setState(() {
          _mySelection = newVal;
        });
      },
      value: _mySelection,
    );
  }

  Widget uploadButton() {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      onPressed: () {
        print('Upload');
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          print(
              'Name1 = $nameString1, Name2 = $nameString2, abbrone = $abbrOString, abbrtwo = $abbrTString, dropdown = $_mySelection');
          register();
        }
      },
    );
  }

  Future<void> register() async {
    // http://8a7a08360daf.sn.mynetname.net:2528/api/getprovince";
    String urlpost = "http://8a7a0833c6dc.sn.mynetname.net:8099/api_v2/adddivis";

    var body = {
      "Name1": nameString1.trim(),
      "abbrone": abbrOString.trim(),
      "Name2": nameString2.trim(),
      "abbrtwo": abbrTString.trim(),
      "dropdown": _mySelection
    };
    //setUpDisplayName();
    // var response = await get(urlString);
    var response = await http.post(urlpost, body: body);

    if (response.statusCode == 200) {
      print(response.statusCode);
      var result = json.decode(response.body);
      // print('result = $result');

      if (result.toString() == 'null') {
        myAlert('Not Insert', 'No Create in my Database');
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

  Future<void> setUpDisplayName() async {
    // await firebaseAuth.currentUser().then((response) {
    //   UserUpdateInfo updateInfo = UserUpdateInfo();
    //   updateInfo.displayName = nameString;
    //   response.updateProfile(updateInfo);

    // var serviceRoute =
    //     MaterialPageRoute(builder: (BuildContext context) => ;
    // Navigator.of(context)
    //     .pushAndRemoveUntil(serviceRoute, (Route<dynamic> route) => false);
    
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
        title: Text('สร้างข้อมูล ศูนย์ ใต้ส่วนงาน'),
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
                nameText1(),
                nameText2(),
                abbrOneText(),
                abbrTwoText(),
                dropdownButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
