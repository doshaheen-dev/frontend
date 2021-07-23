import 'package:http/http.dart' as http;

abstract class ApiServices {
  static String get baseUrl {
    //  return "http://ec2-65-2-69-222.ap-south-1.compute.amazonaws.com:3000/api";
    return "http://ec2-65-2-69-222.ap-south-1.compute.amazonaws.com:4000/api";
  }

  http.Client get client {
    return new http.Client();
  }
}
