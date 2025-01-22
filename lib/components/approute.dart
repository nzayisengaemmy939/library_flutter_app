import 'package:flutter/material.dart';
import 'package:university_library/pages/entrance_page.dart';
import 'package:university_library/pages/homepage.dart';
import 'package:university_library/pages/registerpage.dart';

class Approute {
  static const String home = "/home";
  static const String entrance = "/entrance";
  static const String register = '/register';
  static final Map<String, WidgetBuilder> routes = {
    home: (context) => const Homepage(),
    entrance: (context) => const EntrancePage(),
    register: (context) => RegistrationPage()
  };
}
