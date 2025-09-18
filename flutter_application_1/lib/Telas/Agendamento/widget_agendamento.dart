import 'package:flutter/material.dart';

class WidgetInicial extends StatefulWidget {
  WidgetInicial({key}) : super(key: key);

  @override
  State<WidgetInicial> createState() => _WidgetClienteState();
}

class _WidgetClienteState extends State<WidgetInicial> {
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
