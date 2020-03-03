import 'package:flutter/material.dart';
import 'package:onu_storage/src/screen/admin_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DefaultHome extends StatefulWidget {

  // final String pic;

  // DefaultHome({
  //   Key key,
  //   @required this.pic,
  // }) : super(key: key);

  @override
  _DefaultHomeState createState() => _DefaultHomeState();
}

class _DefaultHomeState extends State<DefaultHome> {
  final formKey = GlobalKey<FormState>();
  SharedPreferences prefs;
  String getlinepic = '', temps = '';
  int getpriv = 0;

  // String piclocation = '';

  @override
  void initState() {
    super.initState();
    getsharevalue();
  }

  Future<void> getsharevalue() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      getlinepic = prefs.getString('slinepic');
      // await prefs.setInt('spriv', result['priv']); //store preference Integer
      getpriv = prefs.getInt('spriv');
      temps = prefs.getString('srelate');
      print('$getlinepic');
    });
  }

  Widget mySizeBox() {
    return SizedBox(
      width: 8.0,
    );
  }

  Widget showText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        (temps != 'xxx') 
        ? Text(
          'มีสิทธิใช้งาน ปัดที่ขอบจอด้านซ้าย \r\n เลือก ทำรายการตามเมนู',
          style: TextStyle(fontSize: 20.0, color: Colors.green.shade900),
        ) 
        : Text(
          ' User register เรียบร้อย \r\n แต่ยังไม่กำหนดศูนย์ที่สังกัด \r\n กรุณาติดต่อ Admin',
          style: TextStyle(fontSize: 20.0, color: Colors.green.shade900),
        )
      ],
    );
  }

  Future<void> _onBackPressed() async {
    print('press future _onBackPressed');
    // MaterialPageRoute materialPageRoute = MaterialPageRoute(builder: (BuildContext buildContext){return AdminPage();});
    //       Navigator.of(context).pushAndRemoveUntil(materialPageRoute, (Route<dynamic> route){return false;});

    var registerRoute =
        MaterialPageRoute(builder: (BuildContext context) => AdminPage());
        Navigator.of(context).push(registerRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[500],
      appBar: new AppBar(
            title: new Text("User Information"),
            centerTitle: true,
            backgroundColor: Colors.green.shade600,
            elevation: 0.0,
            leading: Padding( // --> Custom Back Button
                padding: const EdgeInsets.all(8.0),
                child: (getpriv >= 4) ? FloatingActionButton( // call admin icon
                  backgroundColor: Colors.green.shade600,
                  mini: true,
                  onPressed: this._onBackPressed,
                  child: Icon(Icons.person_add, color: Colors.black),

                ) : mySizeBox()
              ),
          ),
        body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [Colors.white, Colors.green.shade600],
              radius: 1.2,
            ),
          ),
          alignment: Alignment.center,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                (getlinepic.isNotEmpty) ?
          Image.network(
            getlinepic, 
            width: 200, 
            height: 180
          ) : Icon(Icons.person),
          SizedBox(
            height: 10.0,
          ),
          showText(),
              ],
            ),
          ),
        ),
      )

    );
  }
}