import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario.dart';
import '../models/progresso_jogo.dart';
import 'servico_banco_dados.dart';

class ServicoAutenticacao {
  final ServicoBancoDados _servicoBancoDados = ServicoBancoDados();

  String _hashSenha(String senha) {
    return sha256.convert(utf8.encode(senha)).toString();
  }

  Future<bool> registrar(String nomeUsuario, String email, String senha) async {
    try {
      // Verifica se usuário já existe
      final usuarioExistente = await _servicoBancoDados.obterUsuarioPorNome(nomeUsuario);
      if (usuarioExistente != null) return false;

      // Verifica se email já existe
      final emailExistente = await _servicoBancoDados.obterUsuarioPorEmail(email);
      if (emailExistente != null) return false;

      final usuario = Usuario(
        nomeUsuario: nomeUsuario,
        email: email,
        hashSenha: _hashSenha(senha),
        dataCriacao: DateTime.now(),
      );

      final id = await _servicoBancoDados.inserirUsuario(usuario);

      // Cria progresso inicial para o usuário
      if (id > 0) {
        final progresso = ProgressoJogo(
          usuarioId: id,
          nivel: 1,
          pontuacao: 0,
          moedas: 100, // Moedas iniciais
          ultimoSalvamento: DateTime.now(),
        );
        await _servicoBancoDados.salvarProgresso(progresso);
        return true;
      }

      return false;
    } catch (e) {
      print('Erro no registro: $e');
      return false;
    }
  }

  Future<Usuario?> login(String nomeUsuario, String senha) async {
    try {
      final usuario = await _servicoBancoDados.obterUsuarioPorNome(nomeUsuario);

      if (usuario != null && usuario.hashSenha == _hashSenha(senha)) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('usuario_id_atual', usuario.id!);
        await prefs.setString('nome_usuario_atual', usuario.nomeUsuario);
        return usuario;
      }
      return null;
    } catch (e) {
      print('Erro no login: $e');
      return null;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('usuario_id_atual');
    await prefs.remove('nome_usuario_atual');
  }

  Future<Usuario?> obterUsuarioAtual() async {
    final prefs = await SharedPreferences.getInstance();
    final usuarioId = prefs.getInt('usuario_id_atual');
    if (usuarioId != null) {
      return await _servicoBancoDados.obterUsuarioPorId(usuarioId);
    }
    return null;
  }
}