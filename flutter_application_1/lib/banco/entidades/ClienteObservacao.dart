import 'Cliente.dart';
import 'Servico.dart';
import 'Agendamento.dart';

class ClienteObservacao {
  int? id_observacao;
  Cliente cliente;
  DateTime dtCadastro;
  Agendamento? agendamento;

  ClienteObservacao({
    this.id_observacao,
    required this.cliente,
    required this.dtCadastro,
    this.agendamento,
  });

  factory ClienteObservacao.fromMap(Map<String, dynamic> map) {
    return ClienteObservacao(
      id_observacao: map['id_observacao'] as int?,
      cliente: Cliente(
        id: map['cliente_id'] as int,
        nome: map['cliente_nome'] as String,
        sobrenome: map['cliente_sobrenome'] as String,
        celular: map['cliente_celular'] as String,
      ),
      dtCadastro: DateTime.fromMillisecondsSinceEpoch(map['dtCadastro'] as int),
      agendamento: Agendamento(
        id: map['id_agendamento'] as int,
        cliente: Cliente.fromMap(map['cliente'] as Map<String, dynamic>),
        diaAgendamento: map['dia_agendamento'],
        horaAgendada: map['hora_agendada'] as String,
        tipoServico: Servico.fromMap(
          map['tipo_servico'] as Map<String, dynamic>,
        ),
        status: map['agendamento_status'] as String,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_observacao': id_observacao,
      'cliente_id': cliente.id,
      'dtCadastro': dtCadastro.millisecondsSinceEpoch,
      'agendamento_id': agendamento?.id,
    };
  }

  // @override
  // String toString() {
  //   return 'Agendamento(id: $id_observacao, cliente: ${cliente.nome}, dia: $dtCadastro, hora: $horaAgendada, serviço: ${tipoServico.nome}, status: $status)';
  // }
}
