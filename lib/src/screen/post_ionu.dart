import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:onu_storage/src/screen/lastsubmit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:grouped_buttons/grouped_buttons.dart';

class Postinstall extends StatefulWidget {

  final String lastqrtxt, sdtype, sdname, sdmodel, smac;

  Postinstall({
    Key key,
    @required this.lastqrtxt, this.sdtype, this.sdname, this.sdmodel, this.smac
  }) : super(key: key);

  @override
  _PostinstallState createState() => _PostinstallState();
}

class Company {
  int id;
  String name;

  Company(this.id, this.name);

  static List<Company> getCompanies() {
    return <Company>[
      Company(1, 'ONU_huawei'),
      Company(2, 'ONU_fiberHome'),
      Company(3, 'ONU_forth'),
      Company(4, 'ONU_zhone'),
      Company(5, 'ONU_zte'),
      Company(6, 'ONU_อื่นๆ'),
      Company(7, 'AP_dlink'),
      Company(8, 'AP_tplink'),
      Company(9, 'AP_zyxel'),
      Company(10, 'AP_toto-link'),
      Company(11, 'AP_อื่นๆ'),
      Company(12, 'SW_อื่นๆ'),

    ];
  }
}


class _PostinstallState extends State<Postinstall> {

  // explicit
  File file;
  double lat, lng;
  bool imageBool = false;
  bool _isButtonDisabled = true;

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String name, detail, code, urlPicture, contactnum, textscan, qrCodeString = '', model1 ='', firsta = '';
  String tempprv, temprela, tempcs, token = '', tempuid = '', radiovalue = '', tempmac = '';
  String  getlastqr = '', getdtype = '', getdname = '', getdmodel = '', getmac = '';
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
    setState(() {
      getlastqr = widget.lastqrtxt;
      getdtype = widget.sdtype;
      getdname = widget.sdname;
      getdmodel = widget.sdmodel;
      getmac = widget.smac;
    });
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
    // token = token.split(' ').last;
    var ab = (tempprv.split('-'));
    firsta = ab[0];
    temprela = prefs.getString('srelate');
    token = prefs.getString('stoken');
    tempuid = prefs.getString('suid');
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

  Future<void> sendnewonu() async {
    // addgroup

    String urlpost = "http://8a7a0833c6dc.sn.mynetname.net:8099/api_v2/newonuinstall";
    
    var body = {
      "chkuid": tempuid.trim(),
      "glati": lat.toString(),
      "glong": lng.toString(),
      "ndivision": temprela.trim(),
      "mactext": qrCodeString.trim(),
      "province": tempprv.trim(),
      "cservice": tempcs.trim(),
      "tinstall": radiovalue,
      "serial": getlastqr.trim(),
      "dtype": getdtype,
      "dname": getdname,
      "dmodel": getdmodel,
      "circuid": name.toUpperCase(),
    };
    
    var response = await http.post(urlpost, headers: {HttpHeaders.authorizationHeader: "JWT $token"}, body: body);

    if (response.statusCode == 200) {
      print(response.statusCode);
      var result = json.decode(response.body);

      if (result.toString() == 'null') {
        myAlert('Not Stampin', 'No Stampin,put data in my Database');
      } else {
        if (_isButtonDisabled == true){
        setState(() {
          _isButtonDisabled = false;
        });
        }else{
          print('_isButtonDisabled = false');
        }
        if ((result['status']) && (result['success'])) {
          String getmessage = result['message2'];
      
          var addChildrenRoute = MaterialPageRoute( //condition: radiovalue, datafind: name.toUpperCase()
          builder: (BuildContext context) => LastSubM(successtxt: getmessage));
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

  Widget radiocheck1() {
    return Container(
      width: 220.0,
      child: RadioButtonGroup(
          labels: [
            "Route Mode",
            "Bridge Mode",
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

  Widget modeltext() {
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
          labelText: 'รุ่นอุปกรณ์',
          helperText: 'Model',
          icon: Icon(
          Icons.email,
          size: 36.0,
          color: Colors.blue,
        ),
        ),
        onSaved: (String value) {
          model1 = value.trim();
        },
      ),
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
          tempmac = value.replaceAll('-', '');
          tempmac = tempmac.replaceAll(':', '');
          qrCodeString = tempmac.trim();
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
    // return IconButton(
    //   icon: Icon(
    //     Icons.crop_free,
    //     size: 48.0,
    //     color: Colors.green,
    //   ),
    //   onPressed: () {
    //     scanThread();
    //   },
    // ); // Iconbutton == Click
    return RaisedButton.icon(
      // icon: Icon(Icons.android),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      icon: Icon(Icons.crop_free),
      label: Text('สแกน MAC:'),
      onPressed: () {
        scanThread();
        // print('lat = $lat, lng = $lng, qrtxt = $qrCodeString');
      },
    );
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
          '',
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
            // if (imageBool) {
              formKey.currentState.save();
              // if ((name.isEmpty) || (qrCodeString.isEmpty) || (detail.isNotEmpty)) {
              if ((qrCodeString.isEmpty) || (getlastqr.isEmpty) || ( qrCodeString == getlastqr )) {
                myAlert('Barcode Problem', 'Macaddress/Gpon data not complete!');
              } else {
                
              getmac = getmac.replaceAll('-', '');
              getmac = getmac.replaceAll(':', '');

                if ((getmac == qrCodeString) && (name.length > 5)) {
                  // check name,detail
                urlPicture = code;
                // print('radio = $radiovalue, model = $model1, circuitid = $name, namef = $detail, contactnumber = $contactnum, onuid = $qrCodeString, dropdownstatic = ${_selectedCompany.name} , lat = $lat, lng = $lng, urlPicture = $urlPicture');
                print('circuidid = $name, mac = $qrCodeString, typei = $radiovalue, lat = $lat, lng = $lng, qrtxt = $getlastqr, prv = $tempprv, nvision = $temprela');
                sendnewonu();
                }else{
                  myAlert('MAC/ชื่อวงจร มีปัญหา', 'Macaddress ที่สแกนกับในระบบ \r\n $getmac != $qrCodeString \r\n มีปัญหา ติดต่อ admin');
                }
                
              }
            // } else {
            //   myAlert(
            //       'No Choose Image', 'Please Choose Image From Camera/Gallery');
            // }
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
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: true,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [Colors.white, Colors.green.shade900],
              radius: 1.2,
            ),
          ),
          alignment: Alignment.center,
          child: Form(
            key: formKey,
            child: ListView(
        padding: EdgeInsets.only(
          bottom: 50.0,
          right: 10.0,
          left: 10.0,
        ),
        children: <Widget>[
          showhpage(),
          showhpage(),
          // showImage(),
          SelectableText('ติดตั้ง ONU ใหม่',
          style: TextStyle(fontSize: 24.0),
          textAlign: TextAlign.center,),
          showhpage(),
          showButton(),
          SizedBox(
            height: 10.0,
          ),
          SelectableText('$qrCodeString',
          style: TextStyle(fontSize: 20.0),
          textAlign: TextAlign.center,),
          SizedBox(
            height: 10.0,
          ),
          //dropdownstatic(),
          SizedBox(
            height: 10.0,
          ),
          // modeltext(),
          nameText(),
          detailText(),
          contactText(),
          radiocheck1(),
          SizedBox(
            height: 10.0,
          ),
          (lat.toString().isNotEmpty) ? uploadValueButton() : showtxt(),
        ],
      ),

    ))));
  }
}