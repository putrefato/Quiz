class InventarioUsuario {
  final int usuarioId;
  final int itemId;
  final int quantidade;
  final DateTime dataCompra;

  InventarioUsuario({
    required this.usuarioId,
    required this.itemId,
    required this.quantidade,
    required this.dataCompra,
  });
}
