import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:onu_storage/src/app.dart';
import 'package:onu_storage/src/default_home2.dart';
import 'package:onu_storage/src/screen/clean_onu.dart';
import 'package:onu_storage/src/screen/delwSerial.dart';
import 'package:onu_storage/src/screen/findone.dart';
import 'package:onu_storage/src/screen/import_onu.dart';
import 'package:onu_storage/src/screen/only_web.dart';
import 'package:onu_storage/src/screen/pickup_onu.dart';
import 'package:onu_storage/src/screen/pre_getonu.dart';
import 'package:onu_storage/src/screen/pre_pickup.dart';
import 'package:onu_storage/src/screen/register.dart';
import 'package:onu_storage/src/screen/reused_onu.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:imei_plugin/imei_plugin.dart';

class Cloneuser2 extends StatefulWidget {
  final String username, password;

  Cloneuser2({
    Key key,
    @required this.username,
    this.password,
  }) : super(key: key);

  @override
  _Cloneuser2State createState() => _Cloneuser2State();
}

class _Cloneuser2State extends State<Cloneuser2> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var uid = '';
  var picurl = '';
  String nameString = '', nameShow = '';
  Widget myWidget = DefaultHome2();
  int privilege = 0;
  String temps = '';
  SharedPreferences prefs;

  // File file;
  // String name = 'Ebiwayo'; // ข้อความ
  // int age = 25; // เลขจำนวนเต็ม หรือเลขฐานอื่นๆ
  // double weight = 48.5;  // เลขทศนิยม ใน dart จะไม่มีข้อมูลรูปแบบ float
  // bool graduated = true;  // ข้อมูล Boolean

  @override
  void initState() {
    super.initState();
    // nameString = widget.userProfile.displayName;
    // picurl = widget.userProfile.pictureUrl;
    // getlineid = widget.userProfile.userId;
    nameShow = widget.username;
    // initPlatformState();
  }

  // Future<void> initPlatformState() async {
  //   String platformImei;

  //   try {
  //     platformImei = await ImeiPlugin.getImei( shouldShowRequestPermissionRationale: false );
  //   } on PlatformException {
  //     platformImei = 'Failed to get platform version.';
  //   }

  //   if (!mounted) return;

  //   setState(() {
  //     _platformImei = platformImei;
  //     // widget.chkline
  //   });
  // }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text('$nameShow \r\n ต้องการ ออกจากระบบ หริอไม่?',
                  style: TextStyle(fontSize: 17.0, color: Colors.blue[700])),
              actions: <Widget>[
                FlatButton(
                  child: Text('No',
                      style: TextStyle(fontSize: 17.0, color: Colors.black)),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                    child: Text('Yes',
                        style:
                            TextStyle(fontSize: 17.0, color: Colors.red[800])),
                    onPressed: () {
                      clearSharePreferance(context);
                      // widget.onSignOutPressed();
                      // Navigator.pop(context, true);
                    })
              ],
            ));
  }

  void myShowSnackBar(String messageString) {
    SnackBar snackBar = SnackBar(
      content: Text(messageString),
      backgroundColor: Colors.green[700],
      duration: Duration(seconds: 15),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
        textColor: Colors.orange,
      ),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<void> checkAuthen() async {
    /*
    str1.toLowerCase(); // lorem
    str1.toUpperCase(); // LOREM
    "   $str2  ".trim(); // 'Lorem ipsum'
    str3.split('\n'); // ['Multi', 'Line', 'Lorem Lorem ipsum'];
    str2.replaceAll('e', 'é'); // Lorém

    101.109.115.27:2500/api/flutterget/User=123456
    */
    // uid: user.fname, prv: user.province, priv: user.privilege

    String urlString =
        'http://8a7a0833c6dc.sn.mynetname.net:8099/api_v2/signin';

    var body = {
      "username": widget.username.trim(),
      "password": widget.password.trim(),
      "deviceid": widget.username.trim()
    };

    // var response = await get(urlString);
    var response = await post(urlString, body: body);
    print(response.statusCode);
    print(widget.username.trim());
    print(widget.password.trim());

    if (response.statusCode == 200) {
      print(response.statusCode);
      var result = json.decode(response.body);
      // print('result = $result');
      print(result['status']);
      if (result.toString() == 'null') {
        myAlert('User False', 'No Username in my Database');
      } else {
        if (result['status']) {
          
          String token = result['token'];
          token = token.split(' ').last;
          // print(token);
          if (token.isNotEmpty) {
            prefs = await SharedPreferences.getInstance();
            await prefs.setString('stoken', token);
            //  read value from store_preference
            //  uid: user.fname, prv: user.province, priv: user.privilege
            await prefs.setString('suid', result['uid']);
            await prefs.setString('sprv', result['prv']);
            await prefs.setInt(
                'spriv', result['priv']); //store preference Integer
            await prefs.setString('srelate', result['relate']);
            await prefs.setString('scouters', result['cs']);

            setState(() {
              privilege = prefs.getInt('spriv');
              temps = prefs.getString('srelate');
            });
          } else {
            myAlert('Respond Fail', 'Backend Not Reply,Session empty');
          }
        } else {
          // print(result['error']);
          myAlert('Error', response.statusCode.toString());
        }
      } // End else result.toString() != 'null'
    } else {
      myAlert('Error->Backend error', response.statusCode.toString());
    }
  }

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

  Widget showText() {
    return Text(
      'ตรวจสอบสิทธิ User ในรูป \r\n กดปุ่ม Check ถ้าไม่มี\r\n สิทธิ ให้ยืม Android เพื่อน\r\n เลือกเมนูลงทะเบียน',
      style: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
          color: Colors.brown[800],
          fontFamily: 'PermanentMarker'),
    );
  }

  Widget showTextndef() {
    return Text(
      'User register เรียบร้อย \r\n แต่ยังไม่กำหนดศูนย์ \r\n กรุณาติดต่อ Admin',
      style: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
          color: Colors.brown[800],
          fontFamily: 'PermanentMarker'),
    );
  }

  Widget mySizeBox() {
    return SizedBox(
      width: 8.0,
    );
  }

  //height: 200

  Widget mySizeBoxH() {
    return SizedBox(
      height: 20.0,
    );
  }

  Widget myButton() {
    return Container(
      width: 220.0,
      child: Row(
        children: <Widget>[
          Expanded(
            child: signInButton(),
          ),
          // mySizeBox(),
          // Expanded(
          //   child: signOutButton(),
          // ),
        ],
      ),
    );
  }

  Widget signInButton() {
    return OutlineButton(
        borderSide: BorderSide(color: Colors.green.shade900),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Text(
          'check',
          style: TextStyle(color: Colors.green.shade900),
        ),
        onPressed: () {
          checkAuthen();
        });
  }

  Widget signOutButton() {
    return OutlineButton(
      borderSide: BorderSide(color: Colors.green.shade900),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Text(
        '',
        style: TextStyle(color: Colors.green.shade900),
      ),
      // onPressed: widget.onSignOutPressed,
      onPressed: () {
        print('You Click SignOut');
      },
    );
  }

  Widget myHome() {
    return Scaffold(
      appBar: AppBar(
        title: Text('InApp success: $nameString'),
        centerTitle: true,
      ),
      body: Center(
        child: (picurl.isNotEmpty)
            ? Image.network(picurl, width: 200, height: 200)
            : Icon(Icons.person),
        // child: Text('Login by $nameString'),
      ),
    );
  }

  Widget myHome2() {
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                (picurl.isNotEmpty)
                    ? Image.network(picurl, fit: BoxFit.cover
                        // width: 200,
                        // height: 200
                        )
                    : Icon(Icons.person),
                (temps == 'xxx') ? showTextndef() : showText(),
                mySizeBoxH(),
                // (privilege < 1) ? mySizeBoxH() : myButton(),
                myButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myDrawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'images/drawer1.png'), // https://pixabay.com/th/photos/phuket-unseen-unseen-phuket-plant-3664495/
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: <Widget>[
          Text(
            'Login: $nameShow',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.brown[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget listShowUser() {
    return ListTile(
      leading: Icon(
        Icons.group_add,
        size: 36.0,
        color: Colors.green[400],
      ),
      title: Text(
        'ลงทะเบียน User',
        style: TextStyle(fontSize: 18.0),
      ),
      // on tap == on click
      onTap: () {
        // Navigator.of(context).pop();
        var registerRoute =
            MaterialPageRoute(builder: (BuildContext context) => Register());
        Navigator.of(context).push(registerRoute);
        setState(() {
          // myWidget = Register();
          // Navigator.of(context).pop();
        });
      },
    ); // https://material.io/resources/icons/?style=baseline
  }

  Widget menuFormPage() {
    return ListTile(
      leading: Icon(
        Icons.filter_1,
        size: 36.0,
        color: Colors.green[400],
      ),
      title: Text(
        'นำเข้า ONU',
        style: TextStyle(fontSize: 18.0),
      ),
      // on tap == on click
      onTap: () {
        Navigator.of(context).pop();
        setState(() {
          // myWidget = Register();
          // Navigator.of(context).pop();
        });
      },
    ); // https://material.io/resources/icons/?style=baseline
  }

  Widget menuListViewPage() {
    return ListTile(
      leading: Icon(
        Icons.filter_2,
        size: 36.0,
        color: Colors.red,
      ),
      title: Text(
        'จ่าย ONU',
        style: TextStyle(fontSize: 18.0),
      ),
      // on tap == on click
      onTap: () {
        Navigator.of(context).pop();
        setState(() {
          myWidget = ImportOnu();
          // Navigator.of(context).pop();
        });
      },
    ); // https://material.io/resources/icons/?style=baseline
  }

  Widget formonlyweb() {
    return ListTile(
      leading: Icon(
        Icons.account_box,
        size: 36.0,
        color: Colors.pink[300],
      ),
      title: Text(
        'ลงทะเบียน user \'ใช้บน web และบางเคส\'',
        style: TextStyle(fontSize: 18.0),
      ),
      // on tap == on click
      onTap: () {
        Navigator.of(context).pop();
        setState(() {
          myWidget = OnlyWeb();
          // Navigator.of(context).pop();
        });
      },
    ); // https://material.io/resources/icons/?style=baseline
  }

  Widget csZerodot5() {
    return ListTile(
      leading: Icon(
        Icons.filter_3,
        size: 36.0,
        color: Colors.yellow[700],
      ),
      title: Text(
        'รับโอนย้าย ONU เข้า สนง.',
        style: TextStyle(fontSize: 18.0),
      ),
      // on tap == on click
      onTap: () {
        Navigator.of(context).pop();
        setState(() {
          myWidget = PreGetOnu();
          // Navigator.of(context).pop();
        });
      },
    ); // https://material.io/resources/icons/?style=baseline
  }

  Widget delCPEcus() {
    return ListTile(
      leading: Icon(
        Icons.block,
        size: 36.0,
        color: Colors.orange,
      ),
      title: Text(
        'ลบข้อมูล ONU/อุปกรณ์ที่เก็บ',
        style: TextStyle(fontSize: 18.0),
      ),
      // on tap == on click
      onTap: () {
        Navigator.of(context).pop();
        setState(() {
          myWidget = DelWserial();
          // Navigator.of(context).pop();
        });
      },
    ); // https://material.io/resources/icons/?style=baseline
  }

  Widget menuInstallOnu() {
    return ListTile(
      leading: Icon(
        Icons.filter_4,
        size: 36.0,
        color: Colors.brown[400],
      ),
      title: Text(
        'ติดตั้ง ONU (NEW)',
        style: TextStyle(fontSize: 18.0),
      ),
      // on tap == on click
      onTap: () {
        Navigator.of(context).pop();
        setState(() {
          // myWidget = InstallOnu();
          myWidget = Prepick();
          // Navigator.of(context).pop();
        });
      },
    ); // https://material.io/resources/icons/?style=baseline
  }

  Widget menuPickupOnu() {
    return ListTile(
      leading: Icon(
        Icons.filter_5,
        size: 36.0,
        color: Colors.blue,
      ),
      title: Text(
        'เก็บคืน ONU',
        style: TextStyle(fontSize: 18.0),
      ),
      // on tap == on click
      onTap: () {
        setState(() {
          myWidget = PickupOnu();
          // myWidget = PickupOnu();
          Navigator.of(context).pop();
        });
      },
    ); // https://material.io/resources/icons/?style=baseline
  }

  Widget menuCleanOnu() {
    return ListTile(
      leading: Icon(
        Icons.filter_6,
        size: 36.0,
        color: Colors.cyan,
      ),
      title: Text(
        'ตรวจสอบ/ทำความสะอาด ONU',
        style: TextStyle(fontSize: 18.0),
      ),
      // on tap == on click
      onTap: () {
        Navigator.of(context).pop();
        setState(() {
          myWidget = CleanOnu();
          // Navigator.of(context).pop();
        });
      },
    ); // https://material.io/resources/icons/?style=baseline
  }

  Widget menuReuseOnu() {
    return ListTile(
      leading: Icon(
        Icons.filter_7,
        size: 36.0,
        color: Colors.deepPurple,
      ),
      title: Text(
        'นำ ONU ที่ผ่านขั้นตอนที่6 มาใช้ใหม่',
        style: TextStyle(fontSize: 18.0),
      ),
      // on tap == on click
      onTap: () {
        Navigator.of(context).pop();
        setState(() {
          myWidget = ReusedOnu();
          // Navigator.of(context).pop();
        });
      },
    ); // https://material.io/resources/icons/?style=baseline
  }

  Widget menuLogout() {
    return ListTile(
      leading: Icon(
        // Icons.filter_8,
        Icons.highlight_off,
        size: 36.0,
        color: Colors.deepOrangeAccent,
      ),
      title: Text(
        'ออกจาก App',
        style: TextStyle(fontSize: 18.0),
      ),
      // on tap == on click
      onTap: () {
        // widget.onSignOutPressed();
        clearSharePreferance(context);
        // Navigator.of(context).pop();
      },
    ); // https://material.io/resources/icons/?style=baseline
  }

  //find_in_page

  Widget menuFindone() {
    return ListTile(
      leading: Icon(
        Icons.find_in_page,
        size: 36.0,
        color: Colors.indigoAccent,
      ),
      title: Text(
        'ดู สถานะล่าสุด อุปกรณ์',
        style: TextStyle(fontSize: 18.0),
      ),
      // on tap == on click
      onTap: () {
        Navigator.of(context).pop();
        setState(() {
          //condition: 'Serial', datafind: '4381J2393'
          // myWidget = OnuModel();
          myWidget = FindOne();
          // Navigator.of(context).pop();
        });
      },
    ); // https://material.io/resources/icons/?style=baseline
  }

  // clearSharePreferance(context);
  void clearSharePreferance(BuildContext context) async {
    // widget.onSignOutPressed();
    prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.clear();
      var backHomeRoute =
          MaterialPageRoute(builder: (BuildContext context) => App());
      Navigator.of(context)
          .pushAndRemoveUntil(backHomeRoute, (Route<dynamic> route) => false);
    });
  }

  Widget myDrawer() {
    if ((privilege > 0) && (temps != 'xxx')) {
      if (privilege == 6) {
        //Company(6, 'ผู้รับเหมา/ช่าง tot'),
        return Drawer(
            child: ListView(
          children: <Widget>[
            myDrawerHeader(),
            menuInstallOnu(),
            Divider(),
            menuReuseOnu(),
            Divider(),
            menuFindone(),
            Divider(),
            menuLogout(),
            Divider(),
            // showBack(),
          ],
        ));
      } else if (privilege == 8) {
        //Company(8, 'ศูนย์สนับสนุน การปฏิบัติการ'),
        return Drawer(
            child: ListView(
          children: <Widget>[
            myDrawerHeader(),
            menuPickupOnu(),
            Divider(),
            menuFindone(),
            Divider(),
            formonlyweb(),
            Divider(),
            menuLogout(),
            Divider(),
            // showBack(),
          ],
        ));
      } else if (privilege == 9) {
        //Company(3, 'เก็บคืน/ตรวจสอบ'),
        return Drawer(
            child: ListView(
          children: <Widget>[
            myDrawerHeader(),
            menuPickupOnu(),
            Divider(),
            menuCleanOnu(),
            Divider(),
            menuFindone(),
            Divider(),
            menuLogout(),
            Divider(),
            // showBack(),
          ],
        ));
      } else if (privilege == 10) {
        //Company(4, 'เก็บคืน/ตรวจสอบ/ ใช้ใหม่'),
        return Drawer(
            child: ListView(
          children: <Widget>[
            myDrawerHeader(),
            menuPickupOnu(),
            Divider(),
            menuCleanOnu(),
            Divider(),
            // csZerodot5(), // โอนย้าย onu
            // Divider(),
            menuReuseOnu(),
            Divider(),
            menuFindone(),
            Divider(),
            menuLogout(),
            Divider(),
            // showBack(),
          ],
        ));
      } else if (privilege == 11) {
        return Drawer(
            child: ListView(
          children: <Widget>[
            myDrawerHeader(),
            // menuFormPage(), // 'นำเข้า ONU',
            // Divider(),
            // menuListViewPage(),  // 'จ่าย ONU',
            // Divider(),
            csZerodot5(), // โอนย้าย onu
            Divider(),
            menuInstallOnu(),
            Divider(),
            menuPickupOnu(),
            Divider(),
            menuCleanOnu(),
            Divider(),
            // csZerodot5(), // โอนย้าย onu
            // Divider(),
            menuReuseOnu(),
            Divider(),
            menuFindone(),
            Divider(),
            formonlyweb(),
            Divider(),
            menuLogout(),
            Divider(),
            // showBack(),
          ],
        ));
      } else {
        return Drawer(
            child: ListView(
          children: <Widget>[
            myDrawerHeader(),
            // menuFormPage(), // 'นำเข้า ONU',
            // Divider(),
            // menuListViewPage(),  // 'จ่าย ONU',
            // Divider(),
            csZerodot5(), // โอนย้าย onu
            Divider(),
            menuInstallOnu(),
            Divider(),
            menuPickupOnu(),
            Divider(),
            menuCleanOnu(),
            Divider(),
            // csZerodot5(), // โอนย้าย onu
            // Divider(),
            menuReuseOnu(),
            Divider(),
            menuFindone(),
            Divider(),
            formonlyweb(),
            Divider(),
            delCPEcus(),
            Divider(),
            menuLogout(),
            Divider(),
            // showBack(),
          ],
        ));
      }
    } else if ((privilege > 0) && (temps == 'xxx')) {
      return Drawer(
        child: ListView(
          children: <Widget>[
            myDrawerHeader(),
            Divider(),
          ],
        ),
      );
    } else {
      return Drawer(
        child: ListView(
          children: <Widget>[
            myDrawerHeader(),
            listShowUser(),
            Divider(),
          ],
        ),
      );
    }
  }

  Widget showLogin() {
    return Container(
      alignment: Alignment.topLeft,
      child: ListTile(
        title: Text(
          '-> ONU Storage',
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          'Login by $nameString',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget uploadButton() {
    return IconButton(
      icon: Icon(Icons.exit_to_app),
      onPressed: () {
        print('test exit press');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: privilege == 0
            ? new Scaffold(
                // body: myHome2(),
                body: myHome2(),
                drawer: myDrawer(),
              )
            : new Scaffold(
                // call widget = myhome() in this page
                body: myWidget,
                // body: myHome(),
                drawer: myDrawer(),
              ));
  }
}
