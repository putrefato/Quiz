import '../models/avatar.dart';

class ServicoAvatar {
  static final List<ItemAvatar> itensAvatar = [
    // Rostos
    ItemAvatar(id: 1, nome: 'Sorriso', tipo: 'rosto', icone: '😊', preco: 0, desbloqueado: true),
    ItemAvatar(id: 2, nome: 'Risada', tipo: 'rosto', icone: '😄', preco: 50),
    ItemAvatar(id: 3, nome: 'Piscada', tipo: 'rosto', icone: '😉', preco: 75),
    ItemAvatar(id: 4, nome: 'Nerd', tipo: 'rosto', icone: '🤓', preco: 100),
    ItemAvatar(id: 5, nome: 'Rei', tipo: 'rosto', icone: '👑', preco: 200),

    // Cabelos
    ItemAvatar(id: 6, nome: 'Padrão', tipo: 'cabelo', icone: '👦', preco: 0, desbloqueado: true),
    ItemAvatar(id: 7, nome: 'Cabelo Longo', tipo: 'cabelo', icone: '👧', preco: 60),
    ItemAvatar(id: 8, nome: 'Cabelo Curto', tipo: 'cabelo', icone: '👨', preco: 40),
    ItemAvatar(id: 9, nome: 'Cabelo Colorido', tipo: 'cabelo', icone: '🧑‍🎤', preco: 120),
    ItemAvatar(id: 10, nome: 'Careca', tipo: 'cabelo', icone: '👩‍🦲', preco: 25),

    // Roupas
    ItemAvatar(id: 11, nome: 'Camiseta', tipo: 'roupa', icone: '👕', preco: 0, desbloqueado: true),
    ItemAvatar(id: 12, nome: 'Camisa Social', tipo: 'roupa', icone: '👔', preco: 80),
    ItemAvatar(id: 13, nome: 'Jaqueta', tipo: 'roupa', icone: '🧥', preco: 150),
    ItemAvatar(id: 14, nome: 'Vestido', tipo: 'roupa', icone: '👗', preco: 100),
    ItemAvatar(id: 15, nome: 'Uniforme', tipo: 'roupa', icone: '🥼', preco: 120),

    // Acessórios
    ItemAvatar(id: 16, nome: 'Óculos', tipo: 'acessorio', icone: '👓', preco: 70),
    ItemAvatar(id: 17, nome: 'Óculos Escuros', tipo: 'acessorio', icone: '🕶️', preco: 90),
    ItemAvatar(id: 18, nome: 'Chapéu', tipo: 'acessorio', icone: '🧢', preco: 60),
    ItemAvatar(id: 19, nome: 'Coroa', tipo: 'acessorio', icone: '👑', preco: 300),
    ItemAvatar(id: 20, nome: 'Máscara', tipo: 'acessorio', icone: '😷', preco: 40),
  ];

  static AvatarUsuario criarAvatarPadrao(int usuarioId) {
    return AvatarUsuario(usuarioId: usuarioId);
  }

  static List<ItemAvatar> obterItensPorTipo(String tipo) {
    return itensAvatar.where((item) => item.tipo == tipo).toList();
  }

  static List<ItemAvatar> obterItensDesbloqueados() {
    return itensAvatar.where((item) => item.desbloqueado).toList();
  }

  static bool comprarItem(ItemAvatar item, int moedasUsuario) {
    if (moedasUsuario >= item.preco && !item.desbloqueado) {
      item.desbloqueado = true;
      return true;
    }
    return false;
  }
}