import 'package:flutter/material.dart';

class LastSubM extends StatefulWidget {

  final String successtxt;

  LastSubM({
    Key key,
    @required this.successtxt,
  }) : super(key: key);

  @override
  _LastSubMState createState() => _LastSubMState();
}

class _LastSubMState extends State<LastSubM> {

  final formKey = GlobalKey<FormState>();
  String txtisshow = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      txtisshow = widget.successtxt;
    });
  }

  Widget showText() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        '$txtisshow \r\n กรุณากด (ปุ่ม <-- ที่มุมซ้ายจอ) \r\n เพื่อทำงานต่อ \r\n จากนั้นเลือก ปัดซ้าย-> ขวาเลือกเมนู',
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: Text('สถานะการทำรายการ ล่าสุด'),
        // actions: <Widget>[uploadButton()],
      ),
      body: Form(
        key: formKey,
        child: Container(
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage('images/bg.png'),
          //     fit: BoxFit.cover,
          //   ),
          // ),
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
                // nameTextf(),
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