class Configuracao {
  int? id_configuracao;
  bool? enviarMensagemWhats;
  int? tempoEnviarMensagem;
  bool? salvarObservacao;

  Configuracao({
    this.id_configuracao,
    required this.enviarMensagemWhats,
    required this.tempoEnviarMensagem,
    required this.salvarObservacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_configuracao': id_configuracao,
      'enviarMensagemWhats': enviarMensagemWhats,
      'tempoEnviarMensagem': tempoEnviarMensagem,
      'salvarObservacao': salvarObservacao,
    };
  }

  factory Configuracao.fromMap(Map<String, dynamic> map) {
    return Configuracao(
      id_configuracao: map['id_configuracao'],
      enviarMensagemWhats: map['enviarMensagemWhats'] == 1,
      tempoEnviarMensagem: map['tempoEnviarMensagem'],
      salvarObservacao: map['salvarObservacao'] == 1,
    );
  }
}
