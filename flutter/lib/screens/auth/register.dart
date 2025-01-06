import 'package:flutter/material.dart';
import './login.dart' as login;
import '../../services/register.dart';
import '../home/home.dart' as hom;

import 'valid.dart' as logic;

import 'package:logger/logger.dart';


var logger = Logger(printer: PrettyPrinter());

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const RegisterWidget();
  }
}

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? _errorMessage;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final userData = RegisterUserData(
        email: _emailController.text, phone: _phoneController.text,
        password: _passwordController.text, first: "_firstController.text"
      );
      String? response = await registerUser(userData);
      if (response != null) {
        logger.e('Ошибка: $response');
        setState(() => _errorMessage = response);
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => hom.HomePage()));
        logger.i('Регистрация прошла успешно');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Регистрация', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Телефон', 
                      border: OutlineInputBorder()
                    ),
                    keyboardType: TextInputType.phone,
                    validator: logic.Validator.validatePhoneNumber
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Электронная почта', 
                      border: OutlineInputBorder()
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: logic.Validator.validateEmail
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Пароль', 
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible 
                          ? Icons.visibility 
                          : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                    validator: logic.Validator.validatePassword
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Подтвердите пароль', 
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible 
                          ? Icons.visibility
                          : Icons.visibility_off
                        ),
                        onPressed: () {
                          setState(
                          () {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          });
                        }
                      ),
                    ),
                    obscureText: !_isConfirmPasswordVisible,
                    validator: (value) => logic.Validator.validateConfirmPassword(value, _passwordController),
                  ),
                  const SizedBox(height: 24),
                  if (_errorMessage != null) Text(_errorMessage!, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16)),
                    child: const Text('Зарегистрироваться'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Уже зарегистрированы?', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 3),
                      TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => login.LoginPage())),
                        child: const Text('Войти', style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
