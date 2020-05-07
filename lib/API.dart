import 'dart:async';
import 'package:http/http.dart' as http;

class API {
  static Future getData() {
    var url = "https://5d55541936ad770014ccdf2d.mockapi.io/api/v1/paths";
    return http.get(url);
  }
}