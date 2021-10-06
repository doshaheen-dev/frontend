import 'package:http/http.dart' as http;

abstract class ApiServices {
  static String get baseUrl {
    return "$baseUrlEndpoint/api";
  }

  static String get baseUrlEndpoint {
    // return "http://ec2-65-2-69-222.ap-south-1.compute.amazonaws.com:3000";
    return "https://dev.amicorpcapital.com";
  }

  http.Client get client {
    return new http.Client();
  }
}
