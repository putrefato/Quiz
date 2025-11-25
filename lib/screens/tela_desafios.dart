import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/desafio_diario.dart';
import '../models/usuario.dart';
import '../services/servico_desafios.dart';

class TelaDesafios extends StatefulWidget {
  final Usuario usuario;

  const TelaDesafios({Key? key, required this.usuario}) : super(key: key);

  @override
  _TelaDesafiosState createState() => _TelaDesafiosState();
}

class _TelaDesafiosState extends State<TelaDesafios> {
  List<DesafioDiario> _desafios = [];

  @override
  void initState() {
    super.initState();
    _carregarDesafios();
  }

  void _carregarDesafios() {
    setState(() {
      _desafios = ServicoDesafios.gerarDesafiosDiarios();
    });
  }

  void _coletarRecompensa(DesafioDiario desafio) {
    if (desafio.podeCompletar) {
      setState(() {
        desafio.concluido = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Recompensa coletada: ${desafio.recompensaMoedas} moedas e ${desafio.recompensaPontos} pontos!',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Widget _buildCardDesafio(DesafioDiario desafio) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        border: desafio.concluido
            ? Border.all(color: Colors.green, width: 2)
            : desafio.expirado
                ? Border.all(color: Colors.red, width: 1)
                : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                desafio.icone,
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      desafio.titulo,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1D1D1D),
                      ),
                    ),
                    Text(
                      desafio.descricao,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
              if (desafio.concluido)
                Icon(Icons.check_circle, color: Colors.green, size: 24)
              else if (desafio.expirado)
                Icon(Icons.timer_off, color: Colors.red, size: 24),
            ],
          ),

          SizedBox(height: 12),

          // Barra de progresso
          LinearProgressIndicator(
            value: desafio.progresso.clamp(0.0, 1.0),
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              desafio.concluido ? Colors.green : Color(0xFF6A5AE0),
            ),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),

          SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${desafio.progressoAtual}/${desafio.progressoNecessario}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Color(0xFF666666),
                  fontWeight: FontWeight.w500,
                ),
              ),

              Row(
                children: [
                  if (desafio.recompensaMoedas > 0)
                    Row(
                      children: [
                        Icon(Icons.monetization_on, size: 16, color: Colors.amber),
                        SizedBox(width: 4),
                        Text(
                          '${desafio.recompensaMoedas}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.amber,
                          ),
                        ),
                        SizedBox(width: 8),
                      ],
                    ),

                  if (desafio.recompensaPontos > 0)
                    Row(
                      children: [
                        Icon(Icons.emoji_events, size: 16, color: Color(0xFF6A5AE0)),
                        SizedBox(width: 4),
                        Text(
                          '${desafio.recompensaPontos}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6A5AE0),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),

          if (desafio.podeCompletar)
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 12),
              child: ElevatedButton(
                onPressed: () => _coletarRecompensa(desafio),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6A5AE0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Coletar Recompensa',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final desafiosAtivos = _desafios.where((d) => !d.expirado).toList();
    final desafiosExpirados = _desafios.where((d) => d.expirado).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Desafios Diários', style: GoogleFonts.poppins()),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF6A5AE0),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(Icons.timer, color: Colors.white, size: 32),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Desafios Diários',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Complete desafios para ganhar recompensas extras!',
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              Text(
                'Desafios Ativos',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1D1D1D),
                ),
              ),

              SizedBox(height: 12),

              Expanded(
                child: desafiosAtivos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.emoji_events, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Nenhum desafio ativo',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              'Volte amanhã para novos desafios!',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: desafiosAtivos.length,
                        itemBuilder: (context, index) {
                          return _buildCardDesafio(desafiosAtivos[index]);
                        },
                      ),
              ),

              if (desafiosExpirados.isNotEmpty) ...[
                SizedBox(height: 20),
                Text(
                  'Desafios Expirados',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF666666),
                  ),
                ),
                SizedBox(height: 8),
                ...desafiosExpirados.map((desafio) => _buildCardDesafio(desafio)).toList(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}