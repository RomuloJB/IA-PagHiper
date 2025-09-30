import 'package:flutter/material.dart';
import 'package:flutter_application_1/Routes/rotas.dart';
import 'package:flutter_application_1/Telas/Dashboard/widget_dashboard.dart';
import 'package:flutter_application_1/Telas/Login/widget_login.dart';
import 'package:flutter_application_1/Telas/Menu/widget_menu.dart';
import 'package:flutter_application_1/Telas/NewContract/NewContract.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatelessWidget {
  const App({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IA PagHiper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF34302D),
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 216, 216, 216),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: Rotas.login, // <- agora inicia no login
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      home: NewContractScreen(),
      routes: {
        Rotas.login: (context) => const WidgetLogin(),
        Rotas.Upload: (context) => const NewContractScreen(),
        Rotas.dashboard: (context) => const WidgetDashboard(),
      },
    );
  }
}
