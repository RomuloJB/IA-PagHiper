import 'Cliente.dart';
import 'Servico.dart';

class Agendamento {
  int? id;
  Cliente cliente;
  DateTime diaAgendamento;
  String horaAgendada;
  Servico tipoServico;
  String status;

  Agendamento({
    this.id,
    required this.cliente,
    required this.diaAgendamento,
    required this.horaAgendada,
    required this.tipoServico,
    required this.status,
  });

  factory Agendamento.fromMap(Map<String, dynamic> map) {
    return Agendamento(
      id: map['id'] as int?,
      cliente: Cliente(
        id: map['cliente_id'] as int,
        nome: map['cliente_nome'] as String,
        sobrenome: map['cliente_sobrenome'] as String,
        celular: map['cliente_celular'] as String,
      ),
      diaAgendamento: DateTime.fromMillisecondsSinceEpoch(
        map['dia_agendamento'] as int,
      ),
      horaAgendada: map['hora_agendada'] as String,
      tipoServico: Servico(
        id_servico: map['servico_id'] as int,
        nome: map['servico_nome'] as String,
        preco: (map['servico_preco'] as num).toDouble(),
      ),
      status: map['status'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cliente_id': cliente.id,
      'dia_agendamento': diaAgendamento.millisecondsSinceEpoch,
      'hora_agendada': horaAgendada,
      'servico_id': tipoServico.id_servico,
      'status': status,
    };
  }

  @override
  String toString() {
    return 'Agendamento(id: $id, cliente: ${cliente.nome}, dia: $diaAgendamento, hora: $horaAgendada, serviço: ${tipoServico.nome}, status: $status)';
  }
}
