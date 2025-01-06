import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';


var logger = Logger(printer: PrettyPrinter());


class RegisterUserData {
  final String email;
  final String phone;
  final String password;
  final String first;
  
  RegisterUserData({
    required this.email,
    required this.phone,
    required this.first,
    required this.password
  });
}


Future<String?> registerUser(RegisterUserData userData) async {
  logger.i('Полученные данные: ${userData.email}, ${userData.phone}, ${userData.password}');

  var url = Uri.http('127.0.0.1:8000', '/auth/executor/register-executor');
  var body = convert.jsonEncode({
    'email': userData.email, 'phone_number': userData.phone,
    'password': userData.password, 'first_name': userData.first});

  var headers = {"Content-Type": "application/json"};

  try {
    var response = await http.post(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      logger.i('User стакими данными успешно зареган: ${userData.email}, ${userData.phone}, ${userData.password}');
      return null;
    } else {
      var responseData = convert.jsonDecode(response.body);
      var errorMessage = responseData['detail'] ?? 'Unknown error';
      logger.e('Не удалось успешно зарегистрироваться: ${response.statusCode} - $errorMessage');
      return errorMessage;
    }
  } on http.ClientException catch (e) {
    logger.e('сервера: $e');
    return 'Ошибка сервера: $e';
  }
}
