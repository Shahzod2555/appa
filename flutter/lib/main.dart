import 'package:flutter/material.dart';
import './screens/auth/register.dart' as auth_register;
import './screens/auth/login.dart' as auth_login;
import './screens/home/home.dart' as hom;


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fast Delivery',
      initialRoute: "/register",
      themeMode: ThemeMode.dark,
      routes: {
        "/": (context) => hom.HomePage(),
        "/register": (context) => auth_register.RegisterPage(),
        "/login": (context) => auth_login.LoginPage(),
      },
    );
  }
}
