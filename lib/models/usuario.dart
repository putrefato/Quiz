class Usuario {
  final int? id;
  final String nomeUsuario;
  final String email;
  final String hashSenha;
  final DateTime dataCriacao;

  Usuario({this.id, required this.nomeUsuario, required this.email, required this.hashSenha, required this.dataCriacao});

  Map<String, dynamic> paraMapa() {
    return {
      'id': id,
      'nome_usuario': nomeUsuario,
      'email': email,
      'hash_senha': hashSenha,
      'data_criacao': dataCriacao.millisecondsSinceEpoch,
    };
  }

  factory Usuario.deMapa(Map<String, dynamic> mapa) {
    return Usuario(
      id: mapa['id'],
      nomeUsuario: mapa['nome_usuario'],
      email: mapa['email'],
      hashSenha: mapa['hash_senha'],
      dataCriacao: DateTime.fromMillisecondsSinceEpoch(mapa['data_criacao']),
    );
  }
}