import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:onu_storage/src/screen/api_page.dart';
import 'package:onu_storage/src/utility/my_constant.dart';
// String urlString = '${MyConstant().urltoServerApi}';

class OnlyWeb extends StatefulWidget {
  @override
  _OnlyWebState createState() => _OnlyWebState();
}

class _OnlyWebState extends State<OnlyWeb> {

  // Explicit

  final formKey = GlobalKey<FormState>();
  String nameStringf,
      nameStringl,
      emailString,
      passwordString,
      _mySelection;
  // FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // 8a7a0833c6dc.sn.mynetname.net fttx200/200
  // final String url = "http://8a7a0833c6dc.sn.mynetname.net:8099/api_v2/getprovince_concat";
  final String url = '${MyConstant().urltoServerApi}/getprovince_concat';


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
  Widget nameTextf() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'ชื่อ :',
        labelStyle: TextStyle(color: Colors.orange),
        helperText: 'Type Firstname',
        helperStyle: TextStyle(color: Colors.orange),
        icon: Icon(
          Icons.face,
          size: 36.0,
          color: Colors.orange,
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Type Firstname';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        nameStringf = value;
      },
    );
  }

  Widget nameTextl() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'นามสกุล :',
        labelStyle: TextStyle(color: Colors.pink[400]),
        helperText: 'Type Lastname',
        helperStyle: TextStyle(color: Colors.pink[400]),
        icon: Icon(
          Icons.face,
          size: 36.0,
          color: Colors.pink[400],
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Type Lastname';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        nameStringl = value;
      },
    );
  }

  Widget emailText() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'รหัสพนักงาน/OS :',
        labelStyle: TextStyle(color: Colors.blue),
        helperText: 'TOT Employee Id',
        helperStyle: TextStyle(color: Colors.blue),
        icon: Icon(
          Icons.email,
          size: 36.0,
          color: Colors.blue,
        ),
      ),
      validator: (String value) {
        // if (!((value.contains('@')) && (value.contains('.')))) {
        if (value.length <= 5) {
          return 'Type Employee Id';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        emailString = value.toUpperCase();
      },
    );
  }

  Widget passwordText() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'พาสเวิร์ด :',
        labelStyle: TextStyle(color: Colors.green),
        helperText: 'More 6 digit',
        helperStyle: TextStyle(color: Colors.green),
        icon: Icon(
          Icons.lock,
          size: 36.0,
          color: Colors.green,
        ),
      ),
      validator: (String value) {
        if (value.length <= 5) {
          return 'Password Much More 6 Charactor';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        passwordString = value;
      },
    );
  }

  Widget dropdownButton() {
    return DropdownButton(
      icon: Icon(Icons.arrow_downward),
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
          //value: item['EN'],
          value: item['itemC'],
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

  // Widget uploadButton() {
  //   return IconButton(
  //     icon: Icon(Icons.cloud_upload),
  //     onPressed: () {
  //       print('Upload');
  //       if (formKey.currentState.validate()) {
  //         formKey.currentState.save();
  //         print(
  //             'Name = $nameString, Email = $emailString, Pass = $passwordString, Drop = $_mySelection');
  //         register();
  //       }
  //     },
  //   );
  // }

  Widget uploadValueButton() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center, // จัดตำแหน่ง FloatingActionButton
      children: <Widget>[
        FloatingActionButton(
          elevation: 15.0,
          // foregroundColor: Colors.green[900],
          tooltip: 'กดเพื่อ Regis User ใช้งานบน Web',
          child: Icon(
            Icons.cloud_upload,
            size: 40.0,
          ),

          onPressed: () {
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
              if (emailString.isEmpty) {
                myAlert('มีข้อผิดพลาด',
                    'ไม่มี Line UserId  \r\n ไม่มี DeviceId \r\n ที่ต้องใช้งาน');
              } else {
                print(
                    'namef = $nameStringf, namel = $nameStringl, totid = $emailString, passweb = $passwordString, dropdown = $_mySelection');
                _onShowCondition();
                // register();
              }
            }
          },
        ),
      ],
    );
  }

  Future<void> register() async {
    // http://8a7a08360daf.sn.mynetname.net:2528/api/getprovince";
    // String urlpost = "http://8a7a0833c6dc.sn.mynetname.net:8099/api_v2/signupweb";
    String urlpost = '${MyConstant().urltoServerApi}/signupweb';
    String fullname = '$nameStringf $nameStringl';
    var body = {
      "fullname": fullname,
      "province": _mySelection.trim(),
      "fname": nameStringf.trim(),
      "employeeid": emailString.trim(),
      "passwordweb": passwordString.trim()
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
          myAlert('OK', '$getmessage \r\n ถ้าลงทะเบียนครั้งแรก กรุณาติดต่อ \r\n Admin จังหวัดเพื่อกำหนด ศูนย์/สิทธิ');
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

    var serviceRoute =
        MaterialPageRoute(builder: (BuildContext context) => APIPage());
    Navigator.of(context)
        .pushAndRemoveUntil(serviceRoute, (Route<dynamic> route) => false);
    // });
  }

  Future<bool> _onShowCondition() {
    return showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text('ต้องการ RegisUser ใช้บน web \r\n username = $emailString \r\n password = $passwordString '),
              actions: <Widget>[
                FlatButton(
                  child: Text('No',
                      style: TextStyle(fontSize: 17.0, color: Colors.red[800])),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                    child: Text('Yes',
                        style: TextStyle(fontSize: 17.0, color: Colors.blue)),
                    onPressed: () {
                    register();
                    Navigator.pop(context, true);
                    })
              ],
            ));
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
        title: Text('ลงทะเบียน User เพื่อใช้บน web เท่านั้น'),
        // actions: <Widget>[uploadButton()],
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
                nameTextf(),
                nameTextl(),
                emailText(),
                passwordText(),
                dropdownButton(),
                uploadValueButton()
              ],
            ),
          ),
        ),
      ),
    );
  }
}