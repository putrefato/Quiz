import '../models/progresso_jogo.dart';
import 'servico_banco_dados.dart';
import 'servico_conquistas.dart';

class ServicoJogo {
  final ServicoBancoDados _servicoBancoDados = ServicoBancoDados();
  final ServicoConquistas _servicoConquistas = ServicoConquistas();

  Future<int> salvarProgresso(ProgressoJogo progresso) async {
    return await _servicoBancoDados.salvarProgresso(progresso);
  }

  Future<ProgressoJogo?> obterProgresso(int usuarioId) async {
    return await _servicoBancoDados.obterProgresso(usuarioId);
  }

  Future<int> atualizarProgresso(ProgressoJogo progresso) async {
    return await _servicoBancoDados.atualizarProgresso(progresso);
  }

  Future<void> salvarProgressoComConquistas(ProgressoJogo progresso) async {
    await salvarProgresso(progresso);
    await _servicoConquistas.verificarConquistas(
      progresso.usuarioId,
      progresso.nivel,
      progresso.pontuacao,
      progresso.moedas,
      0,
      0,
    );
  }
}