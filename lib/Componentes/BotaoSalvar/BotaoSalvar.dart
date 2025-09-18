import 'package:flutter/material.dart';

class Botaosalvar extends StatelessWidget {
  final String? rotulo;
  final Future<void> Function()? onPressed;

  const Botaosalvar({required this.rotulo, required this.onPressed, super.key});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        onPressed!();
      },
      label: Text(
        this.rotulo!,
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
      icon: Icon(Icons.add),
      style: ElevatedButton.styleFrom(
        fixedSize: Size(100, 50),
        iconColor: Colors.white,
        backgroundColor: Colors.amber,
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.vertical()),
      ),
    );
  }
}
