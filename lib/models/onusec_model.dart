class OnusecModel {

  // Field
  String circuitj, onuid, laststatus, chgmind, afterclean, reustatus, logintime;

  // Constructor
  OnusecModel(this.circuitj, this.onuid, this.laststatus, this.chgmind, this.afterclean, this.reustatus, this.logintime);

  OnusecModel.fromJSON(Map<String, dynamic> parseJSON){
    circuitj = parseJSON['circuitj'];
    onuid = parseJSON['onuid'];
    laststatus = parseJSON['laststatus'];
    chgmind = parseJSON['chgmind'];
    afterclean = parseJSON['afterclean'];
    reustatus = parseJSON['reustatus'];
    logintime = parseJSON['logintime'];
  }


  
}