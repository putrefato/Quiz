import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaSobre extends StatelessWidget {
  const TelaSobre({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre o App', style: GoogleFonts.poppins()),
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
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabeçalho
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Color(0xFF6A5AE0),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.school,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Título
                Center(
                  child: Text(
                    'Quiz de Computação',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D1D1D),
                    ),
                  ),
                ),
                SizedBox(height: 8),

                Center(
                  child: Text(
                    'Documentação Técnica',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
                SizedBox(height: 32),

                // Card de Informações do Projeto
                _buildInfoCard(
                  '📋 Sobre o Projeto',
                  'Este é um aplicativo educativo desenvolvido em Dart/Flutter como parte do curso técnico de Desenvolvimento de Sistemas na Etec Dr. Geraldo José Rodrigues Alckmin.\n\nO objetivo principal é fornecer uma plataforma interativa para aprendizado e revisão de conceitos fundamentais da computação através de um sistema de quiz gamificado.',
                ),

                SizedBox(height: 20),

                // Card de Tecnologias
                _buildInfoCard(
                  '🛠 Tecnologias Utilizadas',
                  '• Framework: Flutter 3.0+\n• Linguagem: Dart\n• Banco de Dados: SQLite com sqflite\n• Gerenciamento de Estado: setState\n• UI: Material Design 3\n• Fontes: Google Fonts\n• Persistência: Shared Preferences\n• Arquitetura: MVC (Model-View-Controller)',
                ),

                SizedBox(height: 20),

                // Card de Funcionalidades
                _buildInfoCard(
                  '🎯 Funcionalidades Principais',
                  '✅ Sistema de autenticação de usuários\n✅ Quiz com 100+ perguntas categorizadas\n✅ 10 níveis de dificuldade progressiva\n✅ Sistema de progresso e conquistas\n✅ Loja virtual com itens colecionáveis\n✅ Timer por pergunta (30 segundos)\n✅ Sistema de pontuação inteligente\n✅ Seleção de níveis desbloqueados\n✅ Salvamento automático de progresso\n✅ Interface responsiva e acessível',
                ),

                SizedBox(height: 20),

                // Card de Estrutura
                _buildInfoCard(
                  '📁 Estrutura do Projeto',
                  'lib/\n├── models/\n│   ├── usuario.dart\n│   ├── progresso_jogo.dart\n│   ├── pergunta.dart\n│   ├── item_loja.dart\n│   ├── conquista.dart\n│   └── inventario_usuario.dart\n├── services/\n│   ├── servico_autenticacao.dart\n│   ├── servico_banco_dados.dart\n│   ├── servico_jogo.dart\n│   ├── servico_quiz.dart\n│   ├── servico_loja.dart\n│   └── servico_conquistas.dart\n├── screens/\n│   ├── tela_login.dart\n│   ├── tela_registro.dart\n│   ├── tela_inicial.dart\n│   ├── tela_quiz.dart\n│   ├── tela_selecao_nivel.dart\n│   ├── tela_loja.dart\n│   ├── tela_conquistas.dart\n│   └── tela_sobre.dart\n├── widgets/\n│   ├── botao_personalizado.dart\n│   ├── campo_texto_personalizado.dart\n│   └── cartao_progresso.dart\n├── theme/\n│   └── tema_app.dart\n└── main.dart',
                ),

                SizedBox(height: 20),

                // Card de Horas
                _buildInfoCard(
                  '⏰ Carga Horária',
                  'Este projeto foi desenvolvido para cumprir parte da carga horária prática do curso técnico em Desenvolvimento de Sistemas, contemplando:\n\n• Análise e Projeto de Sistemas: 40h\n• Programação Mobile: 60h\n• Banco de Dados: 30h\n• Interface de Usuário: 30h\n• Testes e Qualidade: 20h\n• Documentação: 20h\n\nTotal estimado: +/- 200 horas',
                ),

                SizedBox(height: 20),

                // Card de Desenvolvedor
                _buildInfoCard(
                  '👨‍💻 Desenvolvimento',
                  'Projeto desenvolvido por:\nLucas Alves Vieira.\n\nCurso: Técnico em Desenvolvimento de Sistemas\nInstituição: Etec Dr. Geraldo José Rodrigues Alckmin\nAno: 2025\n\nOrientador: Reginaldo Luiz Gonçalvez',
                ),

                SizedBox(height: 20),

                // Card de Versão
                _buildInfoCard(
                  '📄 Versão e Licença',
                  'Versão: 1.0.0\nData de Lançamento: 25/11/2025 \n\nLicença: Educational Use Only\nEste software é destinado exclusivamente para fins educacionais e acadêmicos.\n\n© 2025 Etec Dr. Geraldo José Rodrigues Alckmin',
                ),

                SizedBox(height: 30),

                // Botão Voltar
                Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6A5AE0),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Voltar',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String titulo, String conteudo) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6A5AE0),
            ),
          ),
          SizedBox(height: 12),
          Text(
            conteudo,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Color(0xFF666666),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}