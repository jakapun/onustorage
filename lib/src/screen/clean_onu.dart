import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:onu_storage/src/screen/my_success.dart';
import 'dart:convert';

class CleanOnu extends StatefulWidget {

  CleanOnu() : super();

  @override
  _CleanOnuState createState() => _CleanOnuState();
}

class Company {
  int id;
  String name;

  Company(this.id, this.name);

  static List<Company> getCompanies() {
    return <Company>[
      Company(1, 'พร้อมใช้งาน'),
      Company(2, 'เสียใช้งานไม่ได้'),
      
      // พร้อมใช้งาน
      // เสียใช้งานไม่ได้
    ];
  }
}

class _CleanOnuState extends State<CleanOnu> {

  // explicit
  File file;
  double lat, lng;
  bool imageBool = false, _isButtonDisabled = true;
  final formKey = GlobalKey<FormState>();
  String name, detail, code, urlPicture, contactnum, textscan, qrCodeString = '', radiovalue = '', firsta = '';
  String tempprv, temprela, tempcs, token = '', tempuid = '';
  List<Company> _companies = Company.getCompanies();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  Company _selectedCompany;
  SharedPreferences prefs;


  // method
  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;
    // เริ่มทำงานตรงนี้ก่อนที่อื่น
    super.initState();
    findLatLng();
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

  void createCode() {
    int randInt = Random().nextInt(10000);
    code = 'code$randInt';
  }

  Future<void> findLatLng() async {

    prefs = await SharedPreferences.getInstance();

    tempprv = prefs.getString('sprv');
    var ab = (tempprv.split('-'));
    firsta = ab[0];
    temprela = prefs.getString('srelate');
    token = prefs.getString('stoken');
    tempuid = prefs.getString('suid');
    // await prefs.setString('sfulln', result['fullname']);
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

  Future<LocationData> findLocationData() async {
    var location = Location();

    try {
      return await location.getLocation();
    } catch (e) {
      print('Error = $e');
      return null;
    }
  }

  Widget radiocheck1() {
    return Container(
      width: 220.0,
      child: RadioButtonGroup(
          labels: [
            "พร้อมใช้งาน",
            "เสียใช้งานไม่ได้",
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



  Widget detailText() {
    return Container(
      margin: EdgeInsets.only(left: 50.0, right: 50.0),
      child: TextFormField(
        // keyboardType: TextInputType.multiline,
        // maxLines: 4,
        style: new TextStyle(
                color: Colors.red,
                fontSize: 20.0,
              ),
        decoration: InputDecoration(
          labelText: 'ชื่อ นามสกุลลูกค้า:',
          helperText: 'Text Your Detail First-last name',
          hintText: 'ชื่อ - นามสกุล',
          icon: Icon(
          Icons.lock,
          size: 36.0,
          color: Colors.green,
        ),
        ),
        onSaved: (String value) {
          detail = value.trim();
        },
      ),
    );
  }

  Widget contactText() {
    return Container(
      margin: EdgeInsets.only(left: 50.0, right: 50.0),
      child: TextFormField(
        // keyboardType: TextInputType.multiline,
        // maxLines: 4,
      keyboardType: TextInputType.number,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        style: new TextStyle(
                color: Colors.red,
                fontSize: 20.0,
              ),
        decoration: InputDecoration(
          labelText: 'เบอร์ติดต่อลูกค้า:',
          helperText: 'Text Your Detail Contact Number',
          hintText: 'เบอร์โทรศัพท์',
          icon: Icon(
          Icons.face,
          size: 36.0,
          color: Colors.pink[400],
        ),
        ),
        onSaved: (String value) {
          contactnum = value.trim();
        },
      ),
    );
  }

  Widget scantext() {
    return Container(
      margin: EdgeInsets.only(left: 50.0, right: 50.0),
      child: TextFormField(
        autofocus: true,
        initialValue: '$qrCodeString',
        style: new TextStyle(
                color: Colors.red,
                fontSize: 20.0,
              ),
        decoration: InputDecoration(
          labelText: 'QR/Barcode:',
          helperText: 'Text Your Display Code',
          hintText: '',
          icon: Icon(
          Icons.crop_free,
          size: 36.0,
          color: Colors.black,
        ),
        ),
        onSaved: (String value) {
          // textscan = value.trim();
          qrCodeString = value.trim();
          print(qrCodeString);
        },
      ),
    );
  }

  Widget dropdownstatic() {
    return DropdownButton(
      
      icon: Icon(Icons.arrow_downward),
      hint: Text('กรุณาเลือก'),
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

  Widget showImage() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      height: 200.0,
      child: file == null ? Image.asset('images/pic.png') : Image.file(file),
    );
  }

  Widget showButton() {
    return Container(
      width: 200.0,
      // color: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        // children: <Widget>[cameraButton(), galleryButton()],
        children: <Widget>[scanButton()],
      ),
    );
  }

  Widget cameraButton() {
    return IconButton(
      icon: Icon(
        Icons.add_a_photo,
        size: 48.0,
        color: Colors.pink.shade300,
      ),
      onPressed: () {
        cameraThread();
      },
    ); // Iconbutton == Click
  }

  // thread
  Future<void> cameraThread() async {
    var imageObject = await ImagePicker.pickImage(
        source: ImageSource.camera, maxWidth: 1200.0, maxHeight: 1200.0);
    setState(() {
      file = imageObject;
      imageBool = true;
    });
  }

  Future<void> scanThread() async {
    try {
      String codeString = '';
      codeString = await BarcodeScanner.scan();

      if (codeString.length != 0) {
        setState(() {
          qrCodeString = codeString;
          print('$qrCodeString');
        });
        // myShowSnackBar('$codeString');
        // print('lat = $lat, lng = $lng, qrtxt = $qrCodeString');
      }
    } catch (e) {}
  }

  Widget galleryButton() {
    return IconButton(
      icon: Icon(
        Icons.add_photo_alternate,
        size: 48.0,
        color: Colors.green,
      ),
      onPressed: () {
        galleryThread();
      },
    ); // Iconbutton == Click
  }

  Widget scanButton() {
    return IconButton(
      icon: Icon(
        Icons.crop_free,
        size: 48.0,
        color: Colors.green,
      ),
      onPressed: () {
        scanThread();
      },
    ); // Iconbutton == Click
  }

  Future<void> galleryThread() async {
    var imageObject = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = imageObject;
      imageBool = true;
    });
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

  Widget showtxt() {
    return Column(
      children: <Widget>[
        Text(
          '',
          style: TextStyle(fontSize: 20.0),
        ),
        Text('$qrCodeString')
      ],
    );
  }

  Widget showhpage() {
    return Column(
      children: <Widget>[
        Text(
          'ทำความสะอาด ONU/อื่นๆ',
          style: TextStyle(fontSize: 25.0),
        ),
        // Text('เก็บคืน ONU')
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

  Widget uploadValueButton() {
    // return IconButton(
    //   icon: Icon(Icons.cloud_upload),
    //   onPressed: () {},
    // );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FloatingActionButton(
          child: Icon(Icons.cloud_upload),
          onPressed: () {

              formKey.currentState.save();
              if (qrCodeString.isEmpty) {
                myAlert('Have Not Value', 'Please Fill Data');
              } else {
                // check name,detail
                print('onuid = $qrCodeString, radio = $radiovalue, lat = $lat, lng = $lng');
                sendupstatustwo();
              }
          },
        ),
      ],
    );
  }

  Future<void> sendupstatustwo() async {
             
          // cpeid: req.body.onuid,
          // laststatus: req.body.cstatus,
          // userlast: req.body.uid,

    print('call post upstatustwo');

    String urlpost = "http://8a7a0833c6dc.sn.mynetname.net:8099/api_v2/upstatustwo";
    
    var body = {

      "onuid": qrCodeString.trim(),
      "latitude": lat.toString(),
      "longitude": lng.toString(),
      "userlast": tempuid,
      // "gpath": 
      "laststatus": radiovalue,
      "province": tempprv.trim(),
      "cservice": tempcs.trim(),
    };
    
    var response = await http.post(urlpost, headers: {HttpHeaders.authorizationHeader: "JWT $token"}, body: body);

    if (response.statusCode == 200) {
      print(response.statusCode);
      var result = json.decode(response.body);
      // print('result = $result');

      if (result.toString() == 'null') {
        myAlert('Not Success', 'No ,put data in my Database');
      } else {
        if (_isButtonDisabled == true){
        setState(() {
          _isButtonDisabled = false; // disable ปุ่ม
        });
        }else{
          print('_isButtonDisabled = false');
        }
        if ((result['status']) && (result['success'])) {
          
          // String getmessage = ' บันทึกข้อมูล เก็บคืน/ขอใช้ต่อ OK';
          String getmessage = result['message2'];
          
          var addChildrenRoute = MaterialPageRoute(
              builder: (BuildContext context) => Mysuccess(successtxt: getmessage));
          Navigator.of(context).push(addChildrenRoute);

        } else {
          String getmessage = result['message2'];
          myAlert('Not OK', '$getmessage');
        }
      }
    } else {
      //check respond = 200
      myAlert('Error', response.statusCode.toString());
    }
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
          showImage(),
          showButton(),
          SizedBox(
            height: 10.0,
          ),
          SelectableText('$qrCodeString',
          style: TextStyle(fontSize: 20.0),
          textAlign: TextAlign.center,),

          // nameText(),
          // detailText(),
          // contactText(),
          // SizedBox(
          //   height: 10.0,
          // ),
          
          SizedBox(
            height: 10.0,
          ),
          radiocheck1(),
          SizedBox(
            height: 10.0,
          ),
          uploadValueButton(),
        ],
      ),

    );
  }
}