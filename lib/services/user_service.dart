import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobileapp/configs/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService{
  Future<String> login(String username, String password) async {
    var url = Uri.https(AppConfig.baseUrl, AppConfig.login);
    var payload = {
      "username": username,
      "password": password,
    };
    var response = await http.post(url, body: payload);
    if (response.statusCode == 201){
      var data = jsonDecode(response.body);
      print("Token : ${data['token']}");
      saveData(data['token']);
      return "success";
    } else {
      return "fail";
    }
  }
}

saveData(String token) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
}