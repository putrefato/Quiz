class ItemAvatar {
  final int id;
  final String nome;
  final String tipo; // 'rosto', 'cabelo', 'roupa', 'acessorio'
  final String icone;
  final int preco;
  final bool desbloqueado;

  ItemAvatar({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.icone,
    required this.preco,
    this.desbloqueado = false,
  });
}

class AvatarUsuario {
  final int usuarioId;
  final String rosto;
  final String cabelo;
  final String roupa;
  final String acessorio;
  final String corFundo;

  AvatarUsuario({
    required this.usuarioId,
    this.rosto = '😊',
    this.cabelo = '👦',
    this.roupa = '👕',
    this.acessorio = '',
    this.corFundo = '#6A5AE0',
  });

  String get avatarCompleto => '$rosto$cabelo$roupa$acessorio';
}