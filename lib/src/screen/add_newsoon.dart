import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AddSoon extends StatefulWidget {
  @override
  _AddSoonState createState() => _AddSoonState();
}

class Company {
  int id;
  String name;

  Company(this.id, this.name);

  static List<Company> getCompanies() {
    return <Company>[
      Company(1, 'ภน.2.1'),
      Company(2, 'ภน.2.2'),
    ];
  }
}

class _AddSoonState extends State<AddSoon> {

  // Explicit
  final formKey = GlobalKey<FormState>();
  String nameString1, nameString2, abbrOString, abbrTString, _mySelection, codeone, tempprv;
  // FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  List<Company> _companies = Company.getCompanies();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  Company _selectedCompany;
  SharedPreferences prefs;

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

  void createCode() {
    int randInt = Random().nextInt(10000);
    setState(() {
      codeone = '$randInt';
    });
    
  }

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;
    super.initState();
    this.getSWData();
    setUpDisplayName();
    createCode();
  }

  List<DropdownMenuItem<Company>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<Company>> items = List();
    for (Company company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Company selectedCompany) {
    setState(() {
      _selectedCompany = selectedCompany;
    });
  }

  // Method
  Widget nameText1() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'LocationName :',
        labelStyle: TextStyle(color: Colors.pink[400]),
        helperText: 'ชื่อเต็ม ศูนย์',
        helperStyle: TextStyle(color: Colors.pink[400]),
        icon: Icon(
          Icons.face,
          size: 36.0,
          color: Colors.pink[400],
        ),
      ),
      validator: (String value) {
        if ((value.isEmpty) || (value.length <= 8)) {
          return 'พิมพ์ชื่อเต็ม ศูนย์';
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
        labelText: 'LocationCode :',
        labelStyle: TextStyle(color: Colors.orange[600]),
        helperText: 'รหัส ประจำศูนย์',
        helperStyle: TextStyle(color: Colors.orange[600]),
        icon: Icon(
          Icons.assignment_ind,
          size: 36.0,
          color: Colors.orange[600],
        ),
      ),
      validator: (String value) {
        if ((value.isEmpty) || (value.length <= 8)) {
          return 'รหัส ประจำศูนย์';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        nameString2 = value;
      },
    );
  }

  Widget dropdownstatic() {
    return DropdownButton(
      icon: Icon(Icons.arrow_downward),
      iconSize: 36,
      elevation: 26,
      style: TextStyle(
        color: Colors.deepPurple,
        fontSize: 18.0,
      ),
      value: _selectedCompany,
      items: _dropdownMenuItems,
      onChanged: onChangeDropdownItem,
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
          child: new Text(item['itemC']),
          // child: new Text(item['provinceEN']),
          value: item['province'],
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
              'Name1 = $nameString1, Name2 = $codeone, dropdown = $_mySelection, Drop = ${_selectedCompany.name}, abbr =$tempprv');
          register();
        }
      },
    );
  }

  Future<void> register() async {
    // http://8a7a08360daf.sn.mynetname.net:2528/api/getprovince";
    String urlpost = "http://8a7a0833c6dc.sn.mynetname.net:8099/api_v2/addsoon";

    var ab = (tempprv.split('-'));
    String firsta = ab[0];

    var body = {
      "Name1": nameString1.trim(),
      "Name2": codeone,
      "dropdown": _mySelection,
      "fai": _selectedCompany.name,
      "abbr": firsta
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
          String getmessage = result['message'];
          myAlert('Not OK', '$getmessage');
        }
      }
    } else {
      //check respond = 200
      myAlert('Error', response.statusCode.toString());
    }
  }

  Future<void> setUpDisplayName() async {

    prefs = await SharedPreferences.getInstance();

    tempprv = prefs.getString('sprv');
    // await firebaseAuth.currentUser().then((response) {
    //   UserUpdateInfo updateInfo = UserUpdateInfo();
    //   updateInfo.displayName = nameString;
    //   response.updateProfile(updateInfo);

    // var serviceRoute =
    //     MaterialPageRoute(builder: (BuildContext context) => ;
    // Navigator.of(context)
    //     .pushAndRemoveUntil(serviceRoute, (Route<dynamic> route) => false);
    
  }

  Widget showText2() {
    return Text(
      'เลือก ฝ่ายที่สังกัด',
      style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.green[800],
          fontFamily: 'PermanentMarker'),
    );
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
                // nameText2(),
                dropdownButton(),
                showText2(),
                dropdownstatic(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}