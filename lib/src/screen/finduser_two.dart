import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onu_storage/models/users_model.dart';



class FindUsersTwo extends StatefulWidget {

   final String datafind;

  FindUsersTwo({
    Key key,
    @required this.datafind,
  }) : super(key: key);

  @override
  _FindUsersTwoState createState() => _FindUsersTwoState();
}

class _FindUsersTwoState extends State<FindUsersTwo> {

  // Explicit
  String name;
  List<UsersModel> usersModels = [];

  @override
  void initState() {
    super.initState();
    readAllData();
  }

  Future<void> readAllData() async {
    String urlString = 'http://8a7a0833c6dc.sn.mynetname.net:8099/api_v2/findusercon';

    var body = {
      "fullemployee": widget.datafind,
    };
    // headers: {HttpHeaders.authorizationHeader: "JWT $token"}, 
    var response = await http.post(urlString, body: body);

    var result = json.decode(response.body);
    print('result = $result');

    for (var myUserModel in result) {
      UsersModel userModel = UsersModel.fromJSON(myUserModel);
      setState(() {
        usersModels.add(userModel);
      });
    }

  }

    // fullname = parseJSON['fullname'];
    // employeeid = parseJSON['employeeid'];
    // passwordweb = parseJSON['passwordweb'];
    // counterservice = parseJSON['counterservice'];
    // privilege = parseJSON['privilege'];
    // province = parseJSON['province'];
    // deviceid = parseJSON['deviceid'];

  // ////////////////////
  Widget showFullname(int index) {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        usersModels[index].fullname,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  Widget showPasswordweb(int index) {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        usersModels[index].passwordweb,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }
  
  Widget showCounterservice(int index) {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        usersModels[index].counterservice,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  Widget showProvince(int index) {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        usersModels[index].province,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  Widget showEmployeeid(int index) {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        usersModels[index].employeeid,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  Widget showDeviceid(int index) {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        usersModels[index].deviceid,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  Widget showPrivilege(int index) {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        usersModels[index].privilege.toString(),
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }
  // ////////////////////
  
  Widget sFullname(int index) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width * 0.5,
      // height: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        children: <Widget>[
          showFullname(index),
        ],
      ),
    );
  }

  Widget sPasswordweb(int index) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width * 0.5,
      // height: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        children: <Widget>[
          showPasswordweb(index),
        ],
      ),
    );
  }

  Widget sCounterservice(int index) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width * 0.5,
      // height: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        children: <Widget>[
          showCounterservice(index),
        ],
      ),
    );
  }

  Widget sProvince(int index) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width * 0.5,
      // height: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        children: <Widget>[
          showProvince(index),
        ],
      ),
    );
  }

  Widget sEmployeeid(int index) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width * 0.5,
      // height: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        children: <Widget>[
          showEmployeeid(index),
        ],
      ),
    );
  }

  Widget sDeviceid(int index) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width * 0.5,
      // height: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        children: <Widget>[
          showDeviceid(index),
        ],
      ),
    );
  }

  Widget sPrivilege(int index) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width * 0.5,
      // height: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        children: <Widget>[
          showPrivilege(index),
        ],
      ),
    );
  }

  // ////////////////////

  Widget showUserList() {
    return ListView.builder(
      itemCount: usersModels.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          child: Container(
            decoration: index % 2 == 0
                ? BoxDecoration(color: Colors.orange.shade100)
                : BoxDecoration(color: Colors.orange.shade300),
            child: Column(
              children: <Widget>[
                sFullname(index),
                // sPasswordweb(index),
                sCounterservice(index),
                sPrivilege(index),
                sProvince(index),
                sEmployeeid(index),
                // sDeviceid(index),
              ],
            ),
          ),
          onTap: () {
            print('You Click Index $index');
            // MaterialPageRoute materialPageRoute = MaterialPageRoute(
            //     builder: (BuildContext context) => DetailFood(
            //           foodModel: foodModels[index],
            //         ));
            // Navigator.of(context).push(materialPageRoute);
          },
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
        title: Text('รายละเอียด User'),
        // actions: <Widget>[uploadButton()],
      ),
      body: Form(
          child: showUserList(),
      )
      
    // return showUserList();
    );
  }
}