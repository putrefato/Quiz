import '../models/conquista.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/servico_conquistas.dart';
import '../models/usuario.dart';

class TelaConquistas extends StatefulWidget {
  final Usuario usuario;

  const TelaConquistas({Key? key, required this.usuario}) : super(key: key);

  @override
  _TelaConquistasState createState() => _TelaConquistasState();
}

class _TelaConquistasState extends State<TelaConquistas> {
  final ServicoConquistas _servicoConquistas = ServicoConquistas();
  List<Conquista> _conquistas = [];

  @override
  void initState() {
    super.initState();
    _carregarConquistas();
  }

  Future<void> _carregarConquistas() async {
    final conquistas = await _servicoConquistas.obterConquistasUsuario(widget.usuario.id!);
    setState(() => _conquistas = conquistas);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conquistas', style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xFF6A5AE0),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFF7F7F7), Color(0xFFE8E8E8)]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Suas Conquistas', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700, color: const Color(0xFF1D1D1D))),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.9),
                  itemCount: _conquistas.length,
                  itemBuilder: (context, index) {
                    final conquista = _conquistas[index];
                    return _buildCartaoConquista(conquista);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartaoConquista(Conquista conquista) {
    return Container(
      decoration: BoxDecoration(
        color: conquista.desbloqueada ? Colors.white : Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(conquista.icone, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 8),
            Text(conquista.titulo, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: conquista.desbloqueada ? const Color(0xFF1D1D1D) : Colors.grey), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(conquista.descricao, style: GoogleFonts.poppins(fontSize: 12, color: conquista.desbloqueada ? const Color(0xFF666666) : Colors.grey), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            if (conquista.desbloqueada)
              Text('${conquista.pontosRecompensa} pontos', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF6A5AE0)))
            else
              const Icon(Icons.lock, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}