import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:http/http.dart' as http;
import 'package:onu_storage/src/screen/lastsubmit.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grouped_buttons/grouped_buttons.dart';


class PickupOnu extends StatefulWidget {

  PickupOnu() : super();

  @override
  _PickupOnuState createState() => _PickupOnuState();
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

      
      // <ion-item>
      //         <ion-label floating>ยี่ห้อ onu/accesspoint</ion-label>
      //         <ion-select ngModel name="brand">
      //           <ion-option value="onu_huawei">onu_huawei</ion-option>
      //           <ion-option value="onu_fiberHome">onu_fiberHome</ion-option>
      //           <ion-option value="onu_forth">onu_forth</ion-option>
      //           <ion-option value="onu_zhone">onu_zhone</ion-option>
      //           <ion-option value="onu_zte">onu_zte</ion-option>
      //           <ion-option value="onu_other">onu_อื่นๆ</ion-option>
      //           <ion-option value="ap_dlink">ap_dlink</ion-option>
      //           <ion-option value="ap_tplink">ap_tplink</ion-option>
      //           <ion-option value="ap_zyxel">ap_zyxel</ion-option>
      //           <ion-option value="ap-toto-link">ap_toto-link</ion-option>
      //           <ion-option value="ap_other">ap_อื่นๆ</ion-option>
      //         </ion-select>
      //       </ion-item>
      //       <ion-item>
      //         <ion-label floating>รุ่น onu/accesspoint</ion-label>
      //         <ion-input ngModel name="model" type="text" pattern="^[a-zA-Z0-9_-]+$"></ion-input>
      //     </ion-item>

    ];
  }
}

class _PickupOnuState extends State<PickupOnu> {

  // explicit
  File file;
  double lat, lng;
  bool imageBool = false;
  bool _isButtonDisabled = true;

  final formKey = GlobalKey<FormState>();
  String name, detail, code, urlPicture, contactnum, textscan, qrCodeString = '', model1 ='', firsta = '';
  String tempprv, temprela, tempcs, token = '', tempuid = '', radiovalue = '', _mySelection = '';
  List<Company> _companies = Company.getCompanies();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  Company _selectedCompany;
  SharedPreferences prefs;

  final String url = "http://8a7a0833c6dc.sn.mynetname.net:8099/api_v2/getmodel_concat";


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

  // method
  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;
    // เริ่มทำงานตรงนี้ก่อนที่อื่น
    super.initState();
    findLatLng();
    createCode();
    this.getSWData();
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

  Future<void> sendinonusec() async {
             
              // circuitj: req.body.circuitj,
              // cpeid: req.body.onuid,
              // laststatus: req.body.chgmind,
              // province: req.body.province,
              // stamptime: utc,
              // typecpe: req.body.brand,
              // onuap: o_a[0],
              // ymonth: rpstr2,
              // userlast: req.body.uid,
              // dprovince: req.body.dprovince

              //     circuitj: req.body.circuitj,  $name
              //     onuid: req.body.onuid, $qrCodeString
              //     namei: req.body.namei, $detail
              //     latitude: req.body.latitude, $lat
              //     longitude: req.body.longitude, $lng
              //     userlast: req.body.uid, $tempuid
              //     gpath: req.body.gpath,
              //     laststatus: req.body.chgmind, _selectedCompany.name
              //     province: req.body.province, tempprv
              //     logintime: utc,
              //     model: req.body.model,
              //     brand: req.body.brand,
              //     chgmind: req.body.chgmind, _selectedCompany.name
              //     ymonth: rpstr2,
              //     dprovince: req.body.dprovince, , temprela
//radio = $radiovalue, model = $model1, circuitid = $name, namef = $detail, contactnumber = $contactnum,
// onuid = $qrCodeString, dropdownstatic = ${_selectedCompany.name} , lat = $lat, lng = $lng, urlPicture = $urlPicture
      //radio = เก็บคืน, model = zl660hj, circuitid = 1234J1234, namef = pop chokechone, contactnumber = 04323525389,
      //onuid = 1234567890, dropdownstatic = ap_dlink , lat = 16.4426949, lng = 102.8344221, urlPicture = code7950
    print('call post inonusec');
    
    String urlpost = "http://8a7a0833c6dc.sn.mynetname.net:8099/api_v2/inonusec";
    
    var body = {

      "circuitj": name.toUpperCase(),
      "onuid": qrCodeString.trim(),
      // "namei": detail.trim(),
      "latitude": lat.toString(),
      "longitude": lng.toString(),
      "userlast": tempuid,
      // "gpath": 
      "laststatus": radiovalue,
      "province": tempprv.trim(),
      "cservice": tempcs.trim(),
      "model": model1.toString(),
      "brand": _selectedCompany.name,
      "chgmind": radiovalue,
      // "dprovince":
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
            "เก็บคืน",
            "ขอใช้ต่อ",
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
        children: <Widget>[cameraButton(), scanButton()],
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
          'เก็บคืน ONU/อื่นๆ',
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

  Widget dropdownButton() {
    return DropdownButton(
      icon: Icon(Icons.arrow_downward),
      hint: Text('เลือก ประเภท ยี่ห้อ รุ่น'),
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
          child: new Text(item['allname2']),
          //value: item['EN'],
          value: item['allname'],
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
            if (imageBool) {
              formKey.currentState.save();
              // if ((name.isEmpty) || (qrCodeString.isEmpty) || (detail.isNotEmpty)) {
              if ((qrCodeString.isEmpty) && (name.length > 5)) {
                myAlert('Have Space', 'Please Fill Data');
              } else {
                // check name,detail
                urlPicture = code;
                print(
                    'radio = $radiovalue, model = $model1, circuitid = $name, namef = $detail, contactnumber = $contactnum, onuid = $qrCodeString, dropdownstatic = ${_selectedCompany.name} , lat = $lat, lng = $lng, urlPicture = $urlPicture');
  // radio = เก็บคืน, model = zl660hj, circuitid = 1234J1234, namef = pop chokechone, contactnumber = 04323525389,
 // onuid = 1234567890, dropdownstatic = ap_dlink , lat = 16.4426949, lng = 102.8344221, urlPicture = code7950
                sendinonusec();
              }
            } else {
              myAlert(
                  'No Choose Image', 'Please Choose Image From Camera/Gallery');
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
      child: Container(
          alignment: Alignment.topCenter,
          // padding: EdgeInsets.only(top: 60.0),
      child: ListView(
        // alignment: Alignment.topCenter,
        // padding: EdgeInsets.only(top: 60.0),      
        padding: EdgeInsets.only(
          // bottom: 50.0,
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
          SizedBox(
            height: 10.0,
          ),
          //dropdownstatic(),
          dropdownButton(),
          SizedBox(
            height: 10.0,
          ),
          modeltext(),
          nameText(),
          SizedBox(
            height: 10.0,
          ),
          // detailText(),
          // contactText(),
          radiocheck1(),
          SizedBox(
            height: 10.0,
          ),
          (lat.toString().isNotEmpty) ? uploadValueButton() : showtxt(),
        ],
      ),
      ),
    );
  }
}