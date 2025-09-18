import 'package:barber_shop/Banco/entidades/Agendamento.dart';
import 'package:barber_shop/Banco/entidades/Servico.dart';

List<Agendamento> agendamentos = [];
var servicos = <Servico>[
  Servico(id_servico: 1, nome: "Corte", preco: 30.0),
  Servico(id_servico: 2, nome: "Barba", preco: 20.0),
];
// var servicos = <Servico>[
//   Servico(id: 1, nome: "Corte", preco: 30.0),
//   Servico(id: 2, nome: "Barba", preco: 20.0),
//   Servico(id: 3, nome: "Corte + Barba", preco: 40.0),
//   Servico(id: 4, nome: "Corte + Barba + Lavagem", preco: 50.0),
//   Servico(id: 5, nome: "Corte + Barba + Lavagem + Hidratação", preco: 60.0),
//   Servico(
//     id: 6,
//     nome: "Corte + Barba + Lavagem + Hidratação + Massagem",
//     preco: 70.0,
//   ),
//   Servico(
//     id: 7,
//     nome:
//         "Corte + Barba + Lavagem + Hidratação + Massagem + Design de Sobrancelha",
//     preco: 80.0,
//   ),
//   Servico(
//     id: 8,
//     nome:
//         "Corte + Barba + Lavagem + Hidratação + Massagem + Design de Sobrancelha + Tomar café",
//     preco: 90.0,
//   ),
//   Servico(id: 9, nome: "Tomar café", preco: 40.0),
// ];

var clientes = [
  {"id": "1", "nome": "Cliente 1", "sobrenome": "1", "celular": "123456789"},
  {"id": "2", "nome": "Cliente 2", "sobrenome": "1", "celular": "987654321"},
  {"id": "3", "nome": "Cliente 3", "sobrenome": "1", "celular": "456789123"},
  {"id": "4", "nome": "Cliente 3", "sobrenome": "1", "celular": "456789123"},
  {"id": "5", "nome": "Cliente 3", "sobrenome": "1", "celular": "456789123"},
];
