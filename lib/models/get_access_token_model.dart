class GetAccessToken {

  String  appid;
  String  secret;

  GetAccessToken(
    {
      this.appid = '',
      this.secret = '',
    }
  );

  Map<String, dynamic> toJson() {
    return {
      'appid':  appid,
      'secret': secret,
    };
  }

}