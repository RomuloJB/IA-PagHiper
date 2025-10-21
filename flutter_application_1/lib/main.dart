import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/App.dart';
import 'package:flutter_application_1/Services/DatabaseService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.instance.database;
  runApp(const App());
}
