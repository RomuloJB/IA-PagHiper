import 'package:flutter/material.dart';

class Datainput extends StatefulWidget {
  final String rotulo;
  final DateTime? valor;
  final String mensagemErro;
  final bool eObrigatorio;
  final String? Function(DateTime?)? validador;
  final void Function(DateTime?) aoAlterar;

  const Datainput({
    super.key,
    required this.rotulo,
    this.valor,
    this.mensagemErro = 'Informe a data',
    this.eObrigatorio = false,
    this.validador,
    required this.aoAlterar,
  });

  @override
  State<Datainput> createState() => _DatainputState();
}

class _DatainputState extends State<Datainput> {
  DateTime? _dataSelecionada;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _dataSelecionada = widget.valor;
    _controller = TextEditingController(
      text:
          _dataSelecionada != null
              ? _dataSelecionada!.toLocal().toString().split(' ')[0]
              : 'Selecione uma data',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final hoje = DateTime.now();
    final data = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada ?? hoje,
      firstDate: DateTime(1900),
      lastDate: hoje,
    );
    if (data != null) {
      setState(() {
        _dataSelecionada = data;
        _controller.text = data.toLocal().toString().split(' ')[0];
      });
      widget.aoAlterar(data);
    }
  }

  String? _validarData(DateTime? data) {
    if (widget.validador != null) {
      return widget.validador!(data);
    }
    if (widget.eObrigatorio && data == null) {
      return widget.mensagemErro;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      initialValue: _dataSelecionada,
      validator: (val) => _validarData(_dataSelecionada),
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.rotulo),
            const SizedBox(height: 6),
            TextFormField(
              readOnly: true,
              controller: _controller,
              decoration: InputDecoration(
                errorText: field.errorText,
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              onTap: _selecionarData,
            ),
          ],
        );
      },
    );
  }
}
