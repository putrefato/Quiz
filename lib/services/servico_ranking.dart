import '../models/ranking.dart';

class ServicoRanking {
  Future<List<PosicaoRanking>> obterRankingGlobal() async {
    await Future.delayed(Duration(milliseconds: 500));

    return [
      PosicaoRanking(posicao: 1, nomeUsuario: "MestreQuiz", pontuacao: 12500, nivel: 10, avatar: "👑"),
      PosicaoRanking(posicao: 2, nomeUsuario: "TechGuru", pontuacao: 11200, nivel: 9, avatar: "🤓"),
      PosicaoRanking(posicao: 3, nomeUsuario: "CodeWizard", pontuacao: 9800, nivel: 8, avatar: "🧙"),
      PosicaoRanking(posicao: 4, nomeUsuario: "DevMaster", pontuacao: 8700, nivel: 8, avatar: "💻"),
      PosicaoRanking(posicao: 5, nomeUsuario: "ByteKing", pontuacao: 7600, nivel: 7, avatar: "👑"),
      PosicaoRanking(posicao: 6, nomeUsuario: "Pythonista", pontuacao: 6900, nivel: 7, avatar: "🐍"),
      PosicaoRanking(posicao: 7, nomeUsuario: "JavaExpert", pontuacao: 6200, nivel: 6, avatar: "☕"),
      PosicaoRanking(posicao: 8, nomeUsuario: "CSharpPro", pontuacao: 5800, nivel: 6, avatar: "🔷"),
      PosicaoRanking(posicao: 9, nomeUsuario: "WebDev", pontuacao: 5200, nivel: 6, avatar: "🌐"),
      PosicaoRanking(posicao: 10, nomeUsuario: "MobileMaster", pontuacao: 4800, nivel: 5, avatar: "📱"),
    ];
  }

  Future<List<PosicaoRanking>> obterRankingSemanal() async {
    await Future.delayed(Duration(milliseconds: 500));

    return [
      PosicaoRanking(posicao: 1, nomeUsuario: "MestreQuiz", pontuacao: 2500, nivel: 10, avatar: "👑"),
      PosicaoRanking(posicao: 2, nomeUsuario: "NovatoPro", pontuacao: 1800, nivel: 5, avatar: "🚀"),
      PosicaoRanking(posicao: 3, nomeUsuario: "EstudanteTop", pontuacao: 1500, nivel: 4, avatar: "🎓"),
      PosicaoRanking(posicao: 4, nomeUsuario: "CodeNinja", pontuacao: 1200, nivel: 4, avatar: "🥷"),
      PosicaoRanking(posicao: 5, nomeUsuario: "DevIniciante", pontuacao: 900, nivel: 3, avatar: "👨‍💻"),
    ];
  }

  Future<PosicaoRanking?> obterMinhaPosicao(int usuarioId) async {
    await Future.delayed(Duration(milliseconds: 300));

    return PosicaoRanking(
      posicao: 15,
      nomeUsuario: "Você",
      pontuacao: 3200,
      nivel: 6,
      avatar: "😊"
    );
  }
}