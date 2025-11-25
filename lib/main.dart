import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/tela_login.dart';
import 'screens/tela_inicial.dart';
import 'services/servico_autenticacao.dart';
import 'services/servico_banco_dados.dart';
import 'theme/tema_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o banco de dados
  try {
    final bancoDados = ServicoBancoDados();
    await bancoDados.bancoDados;
    print('Banco de dados inicializado com sucesso');
  } catch (e) {
    print('Erro ao inicializar banco de dados: $e');
  }

  runApp(const MeuJogoApp());
}

class MeuJogoApp extends StatelessWidget {
  const MeuJogoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aventura do Herói',
      theme: TemaApp.temaClaro,
      home: FutureBuilder(
        future: ServicoAutenticacao().obterUsuarioAtual(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data != null) {
              return TelaInicial(usuario: snapshot.data!);
            } else {
              return const TelaLogin();
            }
          }
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF6A5AE0), Color(0xFF8C84F6)],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                    const SizedBox(height: 20),
                    Text('Carregando sua aventura...', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}