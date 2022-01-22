class BodyParameter {

  String  loginAccount;
  String  thirdUserNo;
  String  thirdNickName;
  String  height;
  String  age;
  String  sex;
  String  mac;
  String  weight;
  String  impedance;

  BodyParameter(
    {
      this.loginAccount = '',
      this.thirdUserNo = '',
      this.thirdNickName = '',
      this.height = '',
      this.age = '',
      this.sex = '',
      this.mac = '',
      this.weight = '',
      this.impedance = '',
    }
  );

  Map<String, dynamic> toJson() {
    return {
      'loginAccount':   loginAccount,
      'thirdUserNo':    thirdUserNo,
      'thirdNickName':  thirdNickName,
      'height':         height,
      'age':            age,
      'sex':            sex,
      'mac':            mac,
      'weight':         weight,
      'impedance':      impedance,
    };
  }

}