class UsersModel {

  // Field
  String fullname, employeeid, passwordweb, counterservice, province, deviceid;
  int privilege;

  // Constructor
  UsersModel(this.fullname, this.employeeid, this.passwordweb, this.counterservice, this.province, this.deviceid, this.privilege);

  UsersModel.fromJSON(Map<String, dynamic> parseJSON){
    fullname = parseJSON['fullname'];
    employeeid = parseJSON['employeeid'];
    passwordweb = parseJSON['passwordweb'];
    counterservice = parseJSON['counterservice'];
    province = parseJSON['province'];
    deviceid = parseJSON['deviceid'];
    privilege = parseJSON['privilege'];
  }

//   username: {
//         type: String,
//         unique: true,
//         required: true,
//         trim: true
//     },
//   password: {
//         type: String,
//         required: true,
//         trim: true
//     },
//   fullname: {
//         type: String,
//         required: true,
//         trim: true
//     },
//   province: {
//         type: String,
//         required: true,
//         trim: true
//     },
//   fname: {
//         type: String
//     },
//   relateid: {
//         type: String,
//         default: 'xxx'
//     },
//   privilege: {
//         type: Number,
//         default: 1
//   },
//   deviceid:{
//         type: String
//   },
//   employeeid:{
//         type: String,
//         index: true,
//         required: true
//   },
//   passwordweb:{
//         type: String,
//         required: true
//   },
//   counterservice:{
//         type: String
//   }
// });


  
}