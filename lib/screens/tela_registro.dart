import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/servico_autenticacao.dart';
import '../widgets/campo_texto_personalizado.dart';
import '../widgets/botao_personalizado.dart';
import 'tela_login.dart';

class TelaRegistro extends StatefulWidget {
  const TelaRegistro({Key? key}) : super(key: key);

  @override
  _TelaRegistroState createState() => _TelaRegistroState();
}

class _TelaRegistroState extends State<TelaRegistro> {
  final _formKey = GlobalKey<FormState>();
  final _nomeUsuarioController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final ServicoAutenticacao _servicoAutenticacao = ServicoAutenticacao();
  bool _carregando = false;

  Future<void> _registrar() async {
    if (_formKey.currentState!.validate()) {
      if (_senhaController.text != _confirmarSenhaController.text) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('As senhas não coincidem'), backgroundColor: Colors.red));
        return;
      }

      setState(() => _carregando = true);
      
      final sucesso = await _servicoAutenticacao.registrar(_nomeUsuarioController.text, _emailController.text, _senhaController.text);

      setState(() => _carregando = false);

      if (sucesso && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Conta criada com sucesso!'), backgroundColor: Colors.green));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TelaLogin()));
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao criar conta. Tente outro nome de usuário.'), backgroundColor: Colors.red));
      }
    }
  }

  void _irParaLogin() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TelaLogin()));
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
                  Text('Criar Conta', style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('Junte-se à nossa aventura', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white70)),
                  const SizedBox(height: 40),
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
                            controller: _nomeUsuarioController,
                            rotulo: 'Nome de usuário',
                            icone: Icons.person,
                            validador: (value) {
                              if (value == null || value.isEmpty) return 'Digite um nome de usuário';
                              if (value.length < 3) return 'Mínimo 3 caracteres';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CampoTextoPersonalizado(
                            controller: _emailController,
                            rotulo: 'E-mail',
                            icone: Icons.email,
                            tipoTeclado: TextInputType.emailAddress,
                            validador: (value) {
                              if (value == null || value.isEmpty) return 'Digite seu e-mail';
                              if (!value.contains('@')) return 'E-mail inválido';
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
                              if (value == null || value.isEmpty) return 'Digite uma senha';
                              if (value.length < 6) return 'Mínimo 6 caracteres';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CampoTextoPersonalizado(
                            controller: _confirmarSenhaController,
                            rotulo: 'Confirmar Senha',
                            obscuro: true,
                            icone: Icons.lock_outline,
                            validador: (value) {
                              if (value == null || value.isEmpty) return 'Confirme sua senha';
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          BotaoPersonalizado(texto: 'Criar Conta', aoPressionar: _registrar, carregando: _carregando, largura: double.infinity),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: _irParaLogin,
                            child: RichText(
                              text: TextSpan(
                                text: 'Já tem uma conta? ',
                                style: GoogleFonts.poppins(color: const Color(0xFF666666)),
                                children: [TextSpan(text: 'Faça login', style: GoogleFonts.poppins(color: const Color(0xFF6A5AE0), fontWeight: FontWeight.w600))],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}