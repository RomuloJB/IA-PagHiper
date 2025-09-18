import 'package:flutter/material.dart';

class FooterButton extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const FooterButton({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color.fromARGB(255, 233, 233, 233),
      // type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Agendamentos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.attach_money),
          label: 'Financeiro',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          label: 'Vendas',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.orange,
      onTap: onItemTapped,
    );
  }
}
