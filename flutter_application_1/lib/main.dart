import 'package:flutter/material.dart';
import 'package:flutter_application_1/Config/app.dart';
import 'package:flutter_application_1/Services/databaseService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.instance.database;
  runApp(const App());
}
