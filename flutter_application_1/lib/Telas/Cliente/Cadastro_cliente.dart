
import 'package:flutter/material.dart';

class WidgetCliente extends StatefulWidget {
  WidgetCliente({key}) : super(key: key);

  @override
  State<WidgetCliente> createState() => _WidgetClienteState();
}

class _WidgetClienteState extends State<WidgetCliente> {
  int? _id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_id != null ? 'Edição' : 'Cadastro'} de cliente'),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Text(""),
    );
  }
}
