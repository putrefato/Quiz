import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/usuario.dart';
import '../services/servico_autenticacao.dart';
import 'tela_quiz.dart';
import 'tela_selecao_nivel.dart';
import 'tela_selecao_modo.dart'; // NOVO
import 'tela_login.dart';
import 'tela_conquistas.dart';
import 'tela_loja.dart';
import 'tela_sobre.dart';
import 'tela_ranking.dart'; // NOVO
import 'tela_desafios.dart'; // NOVO
import 'tela_avatar.dart'; // NOVO
import 'tela_estatisticas.dart'; // NOVO
import 'tela_configuracoes_audio.dart'; // NOVO
import 'tela_acessibilidade.dart'; // NOVO

class TelaInicial extends StatelessWidget {
  final Usuario usuario;

  const TelaInicial({Key? key, required this.usuario}) : super(key: key);

  Future<void> _sair(BuildContext context) async {
    final servicoAutenticacao = ServicoAutenticacao();
    await servicoAutenticacao.logout();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TelaLogin()));
  }

  void _jogar(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TelaQuiz(usuario: usuario)));
  }

  void _selecionarNivel(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TelaSelecaoNivel(usuario: usuario)));
  }

  void _selecionarModo(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TelaSelecaoModo(usuario: usuario)));
  }

  void _navegarParaTela(Widget tela, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => tela));
  }

  Widget _buildBotaoMenu(String texto, VoidCallback onPressed, {Color? corFundo, Color? corTexto, IconData? icone}) {
    return SizedBox(
      width: 250,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: corFundo ?? Colors.white,
          foregroundColor: corTexto ?? (corFundo != null ? Colors.white : const Color(0xFF6A5AE0)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icone != null) ...[
              Icon(icone, size: 20),
              SizedBox(width: 8),
            ],
            Text(texto, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz de Computação', style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xFF6A5AE0),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              switch (value) {
                case 'audio':
                  _navegarParaTela(TelaConfiguracoesAudio(), context);
                  break;
                case 'acessibilidade':
                  _navegarParaTela(TelaAcessibilidade(), context);
                  break;
                case 'sobre':
                  _navegarParaTela(TelaSobre(), context);
                  break;
                case 'sair':
                  _sair(context);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'audio',
                child: Row(
                  children: [
                    Icon(Icons.volume_up, color: Color(0xFF6A5AE0)),
                    SizedBox(width: 8),
                    Text('Áudio'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'acessibilidade',
                child: Row(
                  children: [
                    Icon(Icons.accessibility, color: Color(0xFF6A5AE0)),
                    SizedBox(width: 8),
                    Text('Acessibilidade'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'sobre',
                child: Row(
                  children: [
                    Icon(Icons.info, color: Color(0xFF6A5AE0)),
                    SizedBox(width: 8),
                    Text('Sobre'),
                  ],
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: 'sair',
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Sair', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF6A5AE0), Color(0xFF8C84F6)]),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(radius: 60, backgroundColor: Colors.white, child: Icon(Icons.person, size: 50, color: Color(0xFF6A5AE0))),
                const SizedBox(height: 20),
                Text('Olá, ${usuario.nomeUsuario}!', style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 10),
                Text('Pronto para testar seus conhecimentos?', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70)),
                const SizedBox(height: 40),

                // Jogar
                Column(
                  children: [
                    Text('JOGAR', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w600)),
                    SizedBox(height: 8),
                    _buildBotaoMenu('🚀 Continuar Jornada', () => _jogar(context), corFundo: Color(0xFFFD6E87)),
                    const SizedBox(height: 8),
                    _buildBotaoMenu('🎯 Selecionar Nível', () => _selecionarNivel(context)),
                    const SizedBox(height: 8),
                    _buildBotaoMenu('🎮 Modos de Jogo', () => _selecionarModo(context)),
                    const SizedBox(height: 20),
                  ],
                ),

                // Progresso
                Column(
                  children: [
                    Text('PROGRESSO', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w600)),
                    SizedBox(height: 8),
                    _buildBotaoMenu('📊 Estatísticas', () => _navegarParaTela(TelaEstatisticas(usuario: usuario), context)),
                    const SizedBox(height: 8),
                    _buildBotaoMenu('🏆 Conquistas', () => _navegarParaTela(TelaConquistas(usuario: usuario), context)),
                    const SizedBox(height: 8),
                    _buildBotaoMenu('📈 Ranking', () => _navegarParaTela(TelaRanking(usuario: usuario), context)),
                    const SizedBox(height: 20),
                  ],
                ),

                // Personalização
                Column(
                  children: [
                    Text('PERSONALIZAÇÃO', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w600)),
                    SizedBox(height: 8),
                    _buildBotaoMenu('🎨 Avatar', () => _navegarParaTela(TelaAvatar(usuario: usuario), context)),
                    const SizedBox(height: 8),
                    _buildBotaoMenu('🛒 Loja', () => _navegarParaTela(TelaLoja(usuario: usuario), context)),
                    const SizedBox(height: 8),
                    _buildBotaoMenu('🎯 Desafios Diários', () => _navegarParaTela(TelaDesafios(usuario: usuario), context)),
                    const SizedBox(height: 20),
                  ],
                ),

                // Configurações
                _buildBotaoMenu('⚙️ Configurações', () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.volume_up),
                            title: Text('Áudio'),
                            onTap: () {
                              Navigator.pop(context);
                              _navegarParaTela(TelaConfiguracoesAudio(), context);
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.accessibility),
                            title: Text('Acessibilidade'),
                            onTap: () {
                              Navigator.pop(context);
                              _navegarParaTela(TelaAcessibilidade(), context);
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.info),
                            title: Text('Sobre'),
                            onTap: () {
                              Navigator.pop(context);
                              _navegarParaTela(TelaSobre(), context);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }, corFundo: Colors.transparent, corTexto: Colors.white70, icone: Icons.settings),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}