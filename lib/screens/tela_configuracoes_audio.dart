import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/gerenciador_audio.dart';

class TelaConfiguracoesAudio extends StatefulWidget {
  const TelaConfiguracoesAudio({Key? key}) : super(key: key);

  @override
  _TelaConfiguracoesAudioState createState() => _TelaConfiguracoesAudioState();
}

class _TelaConfiguracoesAudioState extends State<TelaConfiguracoesAudio> {
  final GerenciadorAudio _audio = GerenciadorAudio();
  late bool _musicaAtiva;
  late bool _efeitosAtivos;
  late double _volumeMusica;
  late double _volumeEfeitos;

  @override
  void initState() {
    super.initState();
    _musicaAtiva = _audio.musicaAtiva;
    _efeitosAtivos = _audio.efeitosAtivos;
    _volumeMusica = _audio.volumeMusica;
    _volumeEfeitos = _audio.volumeEfeitos;
  }

  void _testarEfeito() {
    _audio.playEfeitoClick();
  }

  void _testarMusica() {
    if (_musicaAtiva) {
      _audio.stopMusica();
      Future.delayed(Duration(milliseconds: 500), () {
        _audio.playMusicaTema();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações de Áudio', style: GoogleFonts.poppins()),
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
                    Icon(Icons.volume_up, color: Colors.white, size: 32),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Configurações de Áudio',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Ajuste o volume e efeitos sonoros',
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

              SizedBox(height: 24),

              // Música
              _buildCardConfiguracao(
                titulo: 'Música de Fundo',
                icone: Icons.music_note,
                valor: _musicaAtiva,
                onChanged: (valor) {
                  setState(() => _musicaAtiva = valor);
                  _audio.setMusicaAtiva(valor);
                  if (valor) _testarMusica();
                },
                child: _musicaAtiva
                    ? Column(
                        children: [
                          Slider(
                            value: _volumeMusica,
                            onChanged: (valor) {
                              setState(() => _volumeMusica = valor);
                              _audio.setVolumeMusica(valor);
                            },
                            min: 0.0,
                            max: 1.0,
                            divisions: 10,
                            label: '${(_volumeMusica * 100).toInt()}%',
                          ),
                          SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: _testarMusica,
                            icon: Icon(Icons.play_arrow),
                            label: Text('Testar Música'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF6A5AE0),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      )
                    : null,
              ),

              SizedBox(height: 16),

              // Efeitos Sonoros
              _buildCardConfiguracao(
                titulo: 'Efeitos Sonoros',
                icone: Icons.graphic_eq,
                valor: _efeitosAtivos,
                onChanged: (valor) {
                  setState(() => _efeitosAtivos = valor);
                  _audio.setEfeitosAtivos(valor);
                  if (valor) _testarEfeito();
                },
                child: _efeitosAtivos
                    ? Column(
                        children: [
                          Slider(
                            value: _volumeEfeitos,
                            onChanged: (valor) {
                              setState(() => _volumeEfeitos = valor);
                              _audio.setVolumeEfeitos(valor);
                            },
                            min: 0.0,
                            max: 1.0,
                            divisions: 10,
                            label: '${(_volumeEfeitos * 100).toInt()}%',
                          ),
                          SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: _testarEfeito,
                            icon: Icon(Icons.volume_up),
                            label: Text('Testar Efeito'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF6A5AE0),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      )
                    : null,
              ),

              SizedBox(height: 24),

              // Dicas
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue[600]),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Dica: Desative os sons para economizar bateria ou jogar em locais silenciosos.',
                        style: GoogleFonts.poppins(
                          color: Colors.blue[800],
                          fontSize: 12,
                        ),
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

  Widget _buildCardConfiguracao({
    required String titulo,
    required IconData icone,
    required bool valor,
    required ValueChanged<bool> onChanged,
    Widget? child,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(0xFF6A5AE0).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icone, color: Color(0xFF6A5AE0), size: 20),
                  ),
                  SizedBox(width: 12),
                  Text(
                    titulo,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D1D1D),
                    ),
                  ),
                ],
              ),
              Switch(
                value: valor,
                onChanged: onChanged,
                activeColor: Color(0xFF6A5AE0),
              ),
            ],
          ),
          if (child != null) ...[
            SizedBox(height: 12),
            child,
          ],
        ],
      ),
    );
  }
}