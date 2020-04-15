class NonuModel {
  // // { "_id" : ObjectId("5e9047f0669fb407db3ee821"), "DeviceListID" : "list20200409034746211", "letterID" : "doc20200409034614010", "DeviceTypeName" : "ONU", "DeviceBrandName" : "ZTE", "DeviceModelName" : "ZXHN-F670L-OFTK", "Serial" : "ZTEGC8C7BBDB", "mac" : "C85A9FA1F5CA", "Status" : "ติดตั้งเรียบร้อย", "Province" : "SSK", "CounterService" : "ศูนย์บริการ ขุขันธ์", "Circuit" : "4567J7110", "CreatedDate" : ISODate("2020-04-08T17:22:04.221Z"), "CreatedBy" : "ชุติ​กาญจน์​ เสนา​ภ​ั​ก​ดิ์", "__v" : 0 }
               
  // Field
  String letterID, serial, mac, status, counterService, circuit;

  // Constructor
  NonuModel(this.letterID, this.serial, this.mac, this.status, this.counterService, this.circuit);

  NonuModel.fromJSON(Map<String, dynamic> parseJSON){
    letterID = parseJSON['letterID'];
    serial = parseJSON['Serial'];
    mac = parseJSON['mac'];
    status = parseJSON['Status'];
    counterService = parseJSON['CounterService'];
    circuit = parseJSON['Circuit'];
  }
  
}