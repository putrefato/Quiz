import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/avatar.dart';
import '../models/usuario.dart';
import '../services/servico_avatar.dart';

class TelaAvatar extends StatefulWidget {
  final Usuario usuario;

  const TelaAvatar({Key? key, required this.usuario}) : super(key: key);

  @override
  _TelaAvatarState createState() => _TelaAvatarState();
}

class _TelaAvatarState extends State<TelaAvatar> {
  late AvatarUsuario _avatarAtual;
  final List<Color> _coresFundo = [
    Color(0xFF6A5AE0),
    Color(0xFFFD6E87),
    Color(0xFF4CAF50),
    Color(0xFF2196F3),
    Color(0xFFFF9800),
    Color(0xFF9C27B0),
    Color(0xFF607D8B),
  ];
  int _categoriaSelecionada = 0;
  final List<String> _categorias = ['Rosto', 'Cabelo', 'Roupa', 'Acessório', 'Fundo'];

  @override
  void initState() {
    super.initState();
    _avatarAtual = ServicoAvatar.criarAvatarPadrao(widget.usuario.id!);
  }

  void _selecionarItem(ItemAvatar item) {
    if (!item.desbloqueado) {
      _mostrarDialogoCompra(item);
      return;
    }

    setState(() {
      switch (item.tipo) {
        case 'rosto':
          _avatarAtual = AvatarUsuario(
            usuarioId: _avatarAtual.usuarioId,
            rosto: item.icone,
            cabelo: _avatarAtual.cabelo,
            roupa: _avatarAtual.roupa,
            acessorio: _avatarAtual.acessorio,
            corFundo: _avatarAtual.corFundo,
          );
          break;
        case 'cabelo':
          _avatarAtual = AvatarUsuario(
            usuarioId: _avatarAtual.usuarioId,
            rosto: _avatarAtual.rosto,
            cabelo: item.icone,
            roupa: _avatarAtual.roupa,
            acessorio: _avatarAtual.acessorio,
            corFundo: _avatarAtual.corFundo,
          );
          break;
        case 'roupa':
          _avatarAtual = AvatarUsuario(
            usuarioId: _avatarAtual.usuarioId,
            rosto: _avatarAtual.rosto,
            cabelo: _avatarAtual.cabelo,
            roupa: item.icone,
            acessorio: _avatarAtual.acessorio,
            corFundo: _avatarAtual.corFundo,
          );
          break;
        case 'acessorio':
          _avatarAtual = AvatarUsuario(
            usuarioId: _avatarAtual.usuarioId,
            rosto: _avatarAtual.rosto,
            cabelo: _avatarAtual.cabelo,
            roupa: _avatarAtual.roupa,
            acessorio: item.icone,
            corFundo: _avatarAtual.corFundo,
          );
          break;
      }
    });
  }

  void _selecionarCorFundo(Color cor) {
    setState(() {
      _avatarAtual = AvatarUsuario(
        usuarioId: _avatarAtual.usuarioId,
        rosto: _avatarAtual.rosto,
        cabelo: _avatarAtual.cabelo,
        roupa: _avatarAtual.roupa,
        acessorio: _avatarAtual.acessorio,
        corFundo: '#${cor.value.toRadixString(16).padLeft(8, '0').substring(2)}',
      );
    });
  }

  void _mostrarDialogoCompra(ItemAvatar item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Comprar Item', style: GoogleFonts.poppins()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(item.icone, style: TextStyle(fontSize: 48)),
            SizedBox(height: 12),
            Text(item.nome, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Text('Preço: ${item.preco} moedas', style: GoogleFonts.poppins()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () {
              if (ServicoAvatar.comprarItem(item, 1000)) {
                setState(() {});
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Item comprado com sucesso!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Moedas insuficientes!'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6A5AE0),
            ),
            child: Text('Comprar', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewAvatar() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Color(int.parse(_avatarAtual.corFundo.replaceFirst('#', '0xFF'))),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _avatarAtual.rosto,
              style: TextStyle(fontSize: 40),
            ),
            Text(
              _avatarAtual.cabelo,
              style: TextStyle(fontSize: 30),
            ),
            Text(
              _avatarAtual.roupa,
              style: TextStyle(fontSize: 25),
            ),
            if (_avatarAtual.acessorio.isNotEmpty)
              Text(
                _avatarAtual.acessorio,
                style: TextStyle(fontSize: 20),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildListaItens() {
    List<ItemAvatar> itens = [];

    switch (_categoriaSelecionada) {
      case 0: itens = ServicoAvatar.obterItensPorTipo('rosto'); break;
      case 1: itens = ServicoAvatar.obterItensPorTipo('cabelo'); break;
      case 2: itens = ServicoAvatar.obterItensPorTipo('roupa'); break;
      case 3: itens = ServicoAvatar.obterItensPorTipo('acessorio'); break;
      case 4: return _buildSelecaoCores();
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: itens.length,
      itemBuilder: (context, index) {
        final item = itens[index];
        return _buildItemAvatar(item);
      },
    );
  }

  Widget _buildSelecaoCores() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _coresFundo.length,
      itemBuilder: (context, index) {
        final cor = _coresFundo[index];
        final corHex = '#${cor.value.toRadixString(16).padLeft(8, '0').substring(2)}';
        final isSelecionada = _avatarAtual.corFundo == corHex;
        
        return GestureDetector(
          onTap: () => _selecionarCorFundo(cor),
          child: Container(
            decoration: BoxDecoration(
              color: cor,
              shape: BoxShape.circle,
              border: isSelecionada ? Border.all(color: Colors.white, width: 3) : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildItemAvatar(ItemAvatar item) {
    final isSelecionado = _isItemSelecionado(item);
    
    return GestureDetector(
      onTap: () => _selecionarItem(item),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
          border: isSelecionado ? Border.all(color: Color(0xFF6A5AE0), width: 2) : null,
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                item.icone,
                style: TextStyle(fontSize: 24),
              ),
            ),
            if (!item.desbloqueado)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock, color: Colors.white, size: 20),
                      if (item.preco > 0)
                        Text(
                          '${item.preco}',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool _isItemSelecionado(ItemAvatar item) {
    switch (item.tipo) {
      case 'rosto': return _avatarAtual.rosto == item.icone;
      case 'cabelo': return _avatarAtual.cabelo == item.icone;
      case 'roupa': return _avatarAtual.roupa == item.icone;
      case 'acessorio': return _avatarAtual.acessorio == item.icone;
      default: return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personalizar Avatar', style: GoogleFonts.poppins()),
        backgroundColor: Color(0xFF6A5AE0),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7F7F7), Color(0xFFE8E8E8)],
          ),
        ),
        child: Column(
          children: [
            // Preview do Avatar
            Container(
              padding: EdgeInsets.all(20),
              child: _buildPreviewAvatar(),
            ),

            // Categorias
            Container(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categorias.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: TextButton(
                      onPressed: () => setState(() => _categoriaSelecionada = index),
                      style: TextButton.styleFrom(
                        backgroundColor: _categoriaSelecionada == index
                            ? Color(0xFF6A5AE0)
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _categorias[index],
                        style: GoogleFonts.poppins(
                          color: _categoriaSelecionada == index
                              ? Colors.white
                              : Color(0xFF6A5AE0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Lista de Itens
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: _buildListaItens(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}