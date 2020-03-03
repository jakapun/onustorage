import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RelateId extends StatefulWidget {
  RelateId() : super();

  @override
  _RelateIdState createState() => _RelateIdState();
}

class Company {
  int id;
  String name;

  Company(this.id, this.name);

  static List<Company> getCompanies() {
    return <Company>[
      Company(1, 'Apple'),
      Company(2, 'Google'),
      Company(3, 'Samsung'),
      Company(4, 'Sony'),
      Company(5, 'LG'),
    ];
  }
}

class _RelateIdState extends State<RelateId> {
// Explicit
  final formKey = GlobalKey<FormState>();
  String nameString, emailString, passwordString, _mySelection, rstoreprv, _mySelectionCS;
  // FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  List<Company> _companies = Company.getCompanies();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  Company _selectedCompany;
  SharedPreferences prefs;

  List data = List(); //edited line
  List datacs = List(); //edited line

  Future<String> getSWData() async {
    prefs = await SharedPreferences.getInstance();
    String tempprv = prefs.getString('sprv');
    var ac = (tempprv.split('-'));
    String firstc = ac[0];
    String url =
        "http://8a7a0833c6dc.sn.mynetname.net:8099/api_v2/getdivisions/$firstc";
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      data = resBody;
    });

    print(resBody);

    return "Success";
  }

  Future<String> getCSData() async {
    prefs = await SharedPreferences.getInstance();
    String tempprv = prefs.getString('sprv');
    var ab = (tempprv.split('-'));
    String firsta = ab[0];
    // http://8a7a0833c6dc.sn.mynetname.net:8099/api_v2/getprovince_concat
    String urlcs =
        "http://8a7a0833c6dc.sn.mynetname.net:8099/api_v2/getcservice_concat/$firsta";
        
    var rescs = await http
        .get(Uri.encodeFull(urlcs), headers: {"Accept": "application/json"});
    var resBodycs = json.decode(rescs.body);

    setState(() {
      datacs = resBodycs;
    });

    print(resBodycs);

    return "Success CS";
  }

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;
    super.initState();
    this.getSWData();
    this.getCSData();
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
  Widget nameText() {
    return TextFormField(
      initialValue: '',
      decoration: InputDecoration(
        labelText: 'รหัสพนักงาน/OS :',
        labelStyle: TextStyle(color: Colors.pink[400]),
        helperText: 'Type Emplyee Id',
        helperStyle: TextStyle(color: Colors.pink[400]),
        icon: Icon(
          Icons.face,
          size: 36.0,
          color: Colors.pink[400],
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Type Emplyee Id';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        nameString = value.toUpperCase();
      },
    );
  }

  Widget emailText() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'อีเมล์ :',
        labelStyle: TextStyle(color: Colors.blue),
        helperText: 'Type you@email.com',
        helperStyle: TextStyle(color: Colors.blue),
        icon: Icon(
          Icons.email,
          size: 36.0,
          color: Colors.blue,
        ),
      ),
      validator: (String value) {
        if (!((value.contains('@')) && (value.contains('.')))) {
          return 'Type Email Format';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        emailString = value;
      },
    );
  }

  Widget passwordText() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'พาสเวิร์ด :',
        labelStyle: TextStyle(color: Colors.green),
        helperText: 'More 6 Charactor',
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

  Widget showDrow() {
    return Column(
      children: <Widget>[
        Text(
          'เลือก ชื่อศูนย์ที่สังกัด',
          style: TextStyle(fontSize: 18.0),
        ),
        // Text('เก็บคืน ONU')
      ],
    );
  }

  Widget dropdowncsButton() {
    return DropdownButton(
      icon: Icon(Icons.arrow_downward),
      hint: Text('กรุณาเลือก ศูนย์'),
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
      items: datacs.map((item) {
        return new DropdownMenuItem(
          child: new Text(item['LocationName']),
          value: item['itemC'].toString(),
        );
      }).toList(),
      onChanged: (newVal) {
        setState(() {
          _mySelectionCS = newVal;
        });
      },
      value: _mySelectionCS,
    );
  }

  Widget dropdownButton() {
    return DropdownButton(
      icon: Icon(Icons.arrow_downward),
      hint: Text('กรุณาเลือก ส่วน/ศูนย์'),
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
          child: new Text(item['sdivisiontwo']),
          value: item['sdivision'].toString(),
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

  Widget dropdownstatic() {
    return DropdownButton(
      value: _selectedCompany,
      items: _dropdownMenuItems,
      onChanged: onChangeDropdownItem,
    );
  }

  Widget uploadButton() {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      onPressed: () {
        print('Upload');
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          print('Name = $nameString, Drop1 = $_mySelection, Drop2 = $_mySelectionCS');
          register();
        }
      },
    );
  }

  Future<void> register() async {
    // addgroup
    String urlpost = "http://8a7a0833c6dc.sn.mynetname.net:8099/api_v2/addgroup";

    var body = {
                "idstaff": nameString.trim(), 
                // "ndivision": _mySelection.trim(),
                "csservice": _mySelectionCS.trim(),
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
          String getmessage = result['message2'];
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

   Widget mySizeBoxH() {
    return SizedBox(
      height: 25.0,
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
        title: Text('ผูก รหัสพนักงาน กับศูนย์'),
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
            width: 350.0,
            height: 700.0,
            child: Column(
              children: <Widget>[
                nameText(),
                // emailText(),
                // passwordText(),
                // dropdownButton(),
                mySizeBoxH(),
                showDrow(),
                dropdowncsButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
