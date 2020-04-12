import 'package:flutter/material.dart';
import 'package:onu_storage/src/widget/clone_userinfo.dart';

class Mysuccess extends StatefulWidget {

  final String successtxt;

  Mysuccess({
    Key key,
    @required this.successtxt,
  }) : super(key: key);

  @override
  _MysuccessState createState() => _MysuccessState();
}

class _MysuccessState extends State<Mysuccess> {

  String txtisshow = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      txtisshow = widget.successtxt;
    });
  }

  Widget goBackButton() {
    return OutlineButton(
      borderSide: BorderSide(color: Colors.green.shade900),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      color: Colors.green[900],
      child: Text(
        '<-- Main',
        style: TextStyle(color: Colors.green.shade900),
      ),
      onPressed: () {
        // MaterialPageRoute materialPageRoute = MaterialPageRoute(
        //           builder: (BuildContext context) => DefaultHome());
        //       Navigator.of(context).pushAndRemoveUntil(
        //           materialPageRoute, (Route<dynamic> route) => false);
        MaterialPageRoute materialPageRoute = MaterialPageRoute(
                  builder: (BuildContext context) => CloneUser());
              Navigator.of(context).pushAndRemoveUntil(
                  materialPageRoute, (Route<dynamic> route) => false);
      },
    );
  }

  Widget showText() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        '$txtisshow \r\n กรุณากด (ปุ่ม <-- Main) \r\n เพื่อทำงานต่อ',
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }

  Widget myButton() {
    return Container(
      alignment: Alignment.center,
      width: 220.0,
      child: Column(
        children: <Widget>[
          goBackButton(),
          // singInButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                showText(),
                myButton(),
              ],
            ),
          ),
        ),
      ),
    );
    // return Container(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       showText(),
    //     ],
    //   ),
    // );
  }
}