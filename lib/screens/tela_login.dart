import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/servico_autenticacao.dart';
import '../widgets/campo_texto_personalizado.dart';
import '../widgets/botao_personalizado.dart';
import 'tela_registro.dart';
import 'tela_inicial.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({Key? key}) : super(key: key);

  @override
  _TelaLoginState createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  final _senhaController = TextEditingController();
  final ServicoAutenticacao _servicoAutenticacao = ServicoAutenticacao();
  bool _carregando = false;

  Future<void> _fazerLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _carregando = true);
      
      final usuario = await _servicoAutenticacao.login(_usuarioController.text, _senhaController.text);

      setState(() => _carregando = false);

      if (usuario != null && mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TelaInicial(usuario: usuario)));
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credenciais inválidas. Tente novamente.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _irParaRegistro() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const TelaRegistro()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF6A5AE0), Color(0xFF8C84F6)]),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text('Bem-vindo de volta!', style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('Faça login para continuar sua jornada', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white70)),
                  const SizedBox(height: 60),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CampoTextoPersonalizado(
                            controller: _usuarioController,
                            rotulo: 'Nome de usuário',
                            icone: Icons.person,
                            validador: (value) {
                              if (value == null || value.isEmpty) return 'Por favor, digite seu usuário';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CampoTextoPersonalizado(
                            controller: _senhaController,
                            rotulo: 'Senha',
                            obscuro: true,
                            icone: Icons.lock,
                            validador: (value) {
                              if (value == null || value.isEmpty) return 'Por favor, digite sua senha';
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          BotaoPersonalizado(texto: 'Entrar', aoPressionar: _fazerLogin, carregando: _carregando, largura: double.infinity),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: _irParaRegistro,
                            child: RichText(
                              text: TextSpan(
                                text: 'Não tem uma conta? ',
                                style: GoogleFonts.poppins(color: const Color(0xFF666666)),
                                children: [TextSpan(text: 'Registre-se', style: GoogleFonts.poppins(color: const Color(0xFF6A5AE0), fontWeight: FontWeight.w600))],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(child: Text('Seu progresso está seguro conosco', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}