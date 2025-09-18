import 'package:flutter/material.dart';

class Observacao extends StatefulWidget {
  const Observacao({super.key});

  @override
  State<Observacao> createState() => _ObservacaoState();
}

class _ObservacaoState extends State<Observacao> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Observação'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Observação',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Aqui você pode adicionar observações sobre o cliente.',
              style: TextStyle(fontSize: 16),
            ),
            // Adicione mais widgets conforme necessário
          ],
        ),
      ),
    );
  }
}
