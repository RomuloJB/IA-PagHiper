import 'package:flutter/material.dart';
import 'package:flutter_application_1/Routes/rotas.dart';

class WidgetDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 233, 233, 233),
      child: ListView(
        padding: EdgeInsets.zero,

        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF34302D)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFF34302D),
                  backgroundImage: ExactAssetImage('images/LogoAri.jpg'),
                  // backgroundImage: AssetImage('images/LogoAri.jpg'),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Leitor de Contrato Social",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pushNamed(Rotas.home);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_add_alt_1),
            title: const Text('Cadastro de cliente'),
            onTap: () {
              Navigator.of(context).pushNamed(Rotas.listagem_cliente);
            },
          ),
          ListTile(
            leading: const Icon(Icons.plus_one),
            title: const Text('Cadastro de serviço'),
            onTap: () {
              Navigator.of(context).pushNamed(Rotas.listagem_servico);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configurações'),
            onTap: () {
              Navigator.of(context).pushNamed(Rotas.configuracao);
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Grupo de Produto'),
            onTap: () {
              Navigator.of(context).pushNamed(Rotas.listagem_grupo_produto);
            },
          ),

          ListTile(
            leading: const Icon(Icons.production_quantity_limits),
            title: const Text('Produtos'),
            onTap: () {
              Navigator.of(context).pushNamed(Rotas.listagem_produto);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
