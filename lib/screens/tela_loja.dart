import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/item_loja.dart';
import '../services/servico_loja.dart';
import '../models/usuario.dart';
import '../models/progresso_jogo.dart';
import '../services/servico_jogo.dart'; // MUDOU AQUI

class TelaLoja extends StatefulWidget {
  final Usuario usuario;

  const TelaLoja({Key? key, required this.usuario}) : super(key: key);

  @override
  _TelaLojaState createState() => _TelaLojaState();
}

class _TelaLojaState extends State<TelaLoja> {
  final ServicoLoja _servicoLoja = ServicoLoja();
  final ServicoJogo _servicoJogo = ServicoJogo(); // MUDOU AQUI
  ProgressoJogo? _progresso;
  int _moedas = 0;

  @override
  void initState() {
    super.initState();
    _carregarProgresso();
  }

  Future<void> _carregarProgresso() async {
    final progresso = await _servicoJogo.obterProgresso(widget.usuario.id!); // MUDOU AQUI
    setState(() {
      _progresso = progresso;
      _moedas = progresso?.moedas ?? 0;
    });
  }

  Future<void> _comprarItem(ItemLoja item) async {
    if (_moedas >= item.preco) {
      final sucesso = await _servicoLoja.comprarItem(
        widget.usuario.id!,
        item.id,
        _moedas,
        item.preco
      );

      if (sucesso && _progresso != null) {
        final novoProgresso = ProgressoJogo(
          id: _progresso!.id,
          usuarioId: _progresso!.usuarioId,
          nivel: _progresso!.nivel,
          pontuacao: _progresso!.pontuacao,
          moedas: _moedas - item.preco,
          ultimoSalvamento: DateTime.now(),
        );

        await _servicoJogo.salvarProgresso(novoProgresso); // MUDOU AQUI
        setState(() {
          _progresso = novoProgresso;
          _moedas = novoProgresso.moedas;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.nome} comprado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Moedas insuficientes!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ... resto do código permanece igual
  @override
  Widget build(BuildContext context) {
    final itens = ServicoLoja.itensLoja;

    return Scaffold(
      appBar: AppBar(
        title: Text('Loja', style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xFF6A5AE0),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7F7F7), Color(0xFFE8E8E8)],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF6A5AE0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.monetization_on, color: Colors.amber, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    '$_moedas Moedas',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: itens.length,
                  itemBuilder: (context, index) {
                    final item = itens[index];
                    return _buildItemLoja(item);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemLoja(ItemLoja item) {
    bool podeComprar = _moedas >= item.preco;

    return GestureDetector(
      onTap: () => _comprarItem(item),
      child: Container(
        decoration: BoxDecoration(
          color: podeComprar ? Colors.white : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(item.icone, style: const TextStyle(fontSize: 40)),
              const SizedBox(height: 12),
              Text(
                item.nome,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1D1D1D),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                item.descricao,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF666666),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: podeComprar ? const Color(0xFF6A5AE0) : Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      item.preco.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}