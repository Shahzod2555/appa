import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';



class Validator {
  static String? validatePhoneNumber(String? value) {
    RegExp regExp = RegExp(r'^\+992\d{8,10}$|^\d{8,10}$');
    if (value == null || value.isEmpty) {
      return 'Пожалуйста, введите свой номер телефона';
    }
    if (!regExp.hasMatch(value)) {
      return 'Пожалуйста, введите действительный номер телефона';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Пожалуйста, введите свой адрес электронной почты';
    }
    if (!EmailValidator.validate(value)) {
      return 'Пожалуйста, введите действительный адрес электронной почты';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Пожалуйста, введите пароль';
    }

    if (value.length < 6) {
      return 'Пароль должен быть не менее 6 символов';
    }
    
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'Пароль должен содержать хотя бы одну цифру';
    }
    
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Пароль должен содержать хотя бы одну заглавную букву';
    }
    
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Пароль должен содержать хотя бы один спецсимвол';
    }

    return null;
  }


  static String? validateConfirmPassword(
    String? value, TextEditingController passwordController) {

    if (value == null || value.isEmpty) {
      return 'Пожалуйста, подтвердите ваш пароль';
    }

    if (value != passwordController.text) {
      return 'Пароли не совпадают';
    }
    return null;
  }

}
