import 'dart:convert';
import 'package:http/http.dart' as http;


void customerRegisterCustomer(String email, String phoneNumber, String password, String firstName) async {
  var response = await http.post(
    Uri.http('127.0.0.1:8000', 'auth/customer/register-customer'),
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "email": email,
      "phone_number": phoneNumber,
      "password": password,
      "first_name": firstName,
    }),
  );
  var res = JsonEncoder.withIndent('  ').convert(jsonDecode(response.body));
  if (response.statusCode == 200) {
    print(res);
  } else {
    print('Error: ${response.statusCode}');
    print(res);
  }
}

void customerLoginCustomer(String email, String password) async {
  var body = jsonEncode({
      "email": email,
      "password": password
  });
  var headers = {"Content-Type": "application/json"};
  var response = await http.post(Uri.http('127.0.0.1:8000', 'auth/customer/login-customer'), headers: headers, body: body);
  var res = JsonEncoder.withIndent('  ').convert(jsonDecode(response.body));
  if (response.statusCode == 200) {
    print(res);
  } else {
    print('Error: ${response.statusCode}');
    print(res);
  }
}

void customerGetCustomerAll() async {
  Uri url = Uri.http('127.0.0.1:8000', 'auth/customer/get-customer-all');
  var headers = {"Content-Type": "application/json"};
  var response = await http.get(url, headers: headers);
  var res = JsonEncoder.withIndent('  ').convert(jsonDecode(response.body));
  if (response.statusCode == 200) {
    print(res);
  } else {
    print('Error: ${response.statusCode}');
    print(res);
  }
}

void customerCurrentCustomer(String token) async {
  var response = await http.post(
    Uri.http('127.0.0.1:8000', 'auth/customer/current-customer'),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );
  var res = JsonEncoder.withIndent('  ').convert(jsonDecode(response.body));
  if (response.statusCode == 200) {
    print(res);
  } else {
    print('Error: ${response.statusCode}');
    print(res);
  }
}



void executorRegisterExecutor(String email, String phoneNumber, String password, String firstName) async {
  Uri url = Uri.http('127.0.0.1:8000', 'auth/executor/register-executor');
  var body = jsonEncode({
      "email": email,
      "phone_number": phoneNumber,
      "password": password,
      "first_name": firstName,
    });
  var response = await http.post(url, headers: {"Content-Type": "application/json"}, body: body);
  var res = JsonEncoder.withIndent('  ').convert(jsonDecode(response.body));
  if (response.statusCode == 200) {
    print(res);
  } else {
    print('Error: ${response.statusCode}');
    print(res);
  }
}

void executorLoginExecutor(String phoneNumber, String password) async {
  Uri url = Uri.http('127.0.0.1:8000', 'auth/executor/login-executor');
  var body = jsonEncode({
    "phone_number": phoneNumber,
    "password": password,
  });
  var response = await http.post(url, headers: {"Content-Type": "application/json"}, body: body);
  var res = JsonEncoder.withIndent('  ').convert(jsonDecode(response.body));
  if (response.statusCode == 200) {
    print(res);
  } else {
    print('Error: ${response.statusCode}');
    print(res);
  }
}

void executorGetExecutorAll() async {
  var response = await http.get(
  Uri.http('127.0.0.1:8000', 'auth/executor/get-executor-all'),
  headers: {"Content-Type": "application/json"},
  );
  var res = JsonEncoder.withIndent('  ').convert(jsonDecode(response.body));
  if (response.statusCode == 200) {
    print(res);
  } else {
    print('Error: ${response.statusCode}');
    print(res);
  }
}

void executorCurrentExecutor(String token) async {
    var response = await http.post(
    Uri.http('127.0.0.1:8000', 'auth/executor/current-executor'),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );
  var res = JsonEncoder.withIndent('  ').convert(jsonDecode(response.body));
  if (response.statusCode == 200) {
    print(res);
  } else {
    print('Error: ${response.statusCode}');
    print(res);
  }
}


void main() async {
  Future.delayed(Duration(seconds: 3), () => customerRegisterCustomer('test@example.com', '1234567890', 'password123', 'John Doe'));
  Future.delayed(Duration(seconds: 6), () => customerLoginCustomer('test@example.com', 'password123'));
  Future.delayed(Duration(seconds: 9), () => customerGetCustomerAll());
  Future.delayed(Duration(seconds: 12), () => customerCurrentCustomer('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJ0ZXN0QGV4YW1wbGUuY29tIiwicGhvbmVfbnVtYmVyIjoiMTIzNDU2Nzg5MCIsImZpcnN0X25hbWUiOiJKb2huIERvZSIsImxhc3RfbmFtZSI6bnVsbCwibWlkZGxlX25hbWUiOm51bGx9.lsu7fU0PkM6EnlreS0EbxqocD52MllzVSctT_W5pLeY'));
  Future.delayed(Duration(seconds: 15), () => executorRegisterExecutor('executor@example.com', '9876543210', 'executorpassword', 'Jane Smith'));
  Future.delayed(Duration(seconds: 18), () => executorLoginExecutor('9876543210', 'executorpassword'));
  Future.delayed(Duration(seconds: 21), () => executorGetExecutorAll());
  Future.delayed(Duration(seconds: 24), () => executorCurrentExecutor('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJleGVjdXRvckBleGFtcGxlLmNvbSIsInBob25lX251bWJlciI6Ijk4NzY1NDMyMTAiLCJmaXJzdF9uYW1lIjoiSmFuZSBTbWl0aCIsImxhc3RfbmFtZSI6bnVsbCwibWlkZGxlX25hbWUiOm51bGx9.czNALK2wd7dpUKAFDzGWd5cKU9apnrsUQUO7Tl4bYfw'));
}