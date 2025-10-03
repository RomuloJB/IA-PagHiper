import 'package:flutter/material.dart';
import 'package:flutter_application_1/Componentes/BotaoFooter/widget_bottao_footer_navigation.dart';
import 'package:flutter_application_1/Componentes/Drawer/widget_drawer.dart';
import 'package:flutter_application_1/Telas/Agendamento/widget_agendamento.dart';

class WidgetMenu extends StatefulWidget {
  const WidgetMenu({super.key});

  @override
  State<WidgetMenu> createState() => _WidgetMenuState();
}

class _WidgetMenuState extends State<WidgetMenu> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [WidgetInicial()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0860DB),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        title: const Text("IA PagHiper"),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
          ),
        ],
      ),
      drawer: WidgetDrawer(),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: FooterButton(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
