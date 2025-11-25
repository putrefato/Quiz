import '../models/item_loja.dart';
import '../models/inventario_usuario.dart';
import 'servico_banco_dados.dart';

class ServicoLoja {
  final ServicoBancoDados _bancoDados = ServicoBancoDados();

  static final List<ItemLoja> itensLoja = [
    ItemLoja(
      id: 1,
      nome: 'Multiplicador de Pontos',
      descricao: 'Dobra os pontos ganhos por 1 hora',
      icone: '⚡',
      preco: 150,
      tipo: 'multiplicador',
      valor: 2,
    ),
    ItemLoja(
      id: 2,
      nome: 'Vida Extra',
      descricao: 'Adiciona uma vida extra',
      icone: '❤️',
      preco: 100,
      tipo: 'vida',
      valor: 1,
    ),
    ItemLoja(
      id: 3,
      nome: 'Pacote de Moedas',
      descricao: '50 moedas instantâneas',
      icone: '💰',
      preco: 80,
      tipo: 'moedas',
      valor: 50,
    ),
    ItemLoja(
      id: 4,
      nome: 'Skin Especial',
      descricao: 'Aparência exclusiva',
      icone: '🎨',
      preco: 200,
      tipo: 'skin',
      valor: 1,
    ),
  ];

  Future<bool> comprarItem(int usuarioId, int itemId, int moedasAtuais, int precoItem) async {
    final item = itensLoja.firstWhere((i) => i.id == itemId);

    if (moedasAtuais >= precoItem) {
      await _bancoDados.adicionarItemInventario(usuarioId, itemId);
      return true;
    }
    return false;
  }

  Future<List<InventarioUsuario>> obterInventario(int usuarioId) async {
    final resultados = await _bancoDados.obterInventario(usuarioId);

    return resultados.map((mapa) {
      return InventarioUsuario(
        usuarioId: mapa['usuario_id'],
        itemId: mapa['item_id'],
        quantidade: mapa['quantidade'],
        dataCompra: DateTime.fromMillisecondsSinceEpoch(mapa['data_compra']),
      );
    }).toList();
  }
}