import 'package:flutter/material.dart';
import 'package:flutter_application_1/Routes/rotas.dart';
import 'package:flutter_application_1/Telas/Cadastro/WidgetCadastro.dart';
import 'package:flutter_application_1/Telas/Dashboard/WidgetDashboard.dart';
import 'package:flutter_application_1/Telas/Listagem/WidgetListagem.dart';
import 'package:flutter_application_1/Telas/Login/WidgetLogin.dart';
import 'package:flutter_application_1/Telas/Menu/WidgetMenu.dart';
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
      initialRoute: Rotas.home,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      home: WidgetLogin(),
      routes: {
        Rotas.login: (context) => const WidgetLogin(),
        Rotas.Upload: (context) => const NewContractScreen(),
        Rotas.dashboard: (context) => const WidgetDashboard(),
        Rotas.listagem: (context) => const WidgetListagem(),
        Rotas.cadastro: (context) => const WidgetCadastro(),
      },
    );
  }
}
