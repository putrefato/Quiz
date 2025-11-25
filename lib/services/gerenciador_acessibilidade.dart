import 'package:flutter/material.dart';

class GerenciadorAcessibilidade {
  static final GerenciadorAcessibilidade _instancia = GerenciadorAcessibilidade._interno();
  factory GerenciadorAcessibilidade() => _instancia;
  GerenciadorAcessibilidade._interno();

  // Configurações de acessibilidade
  double _tamanhoFonte = 1.0;
  bool _altoContraste = false;
  bool _leitorTela = false;
  bool _animacoesReduzidas = false;
  bool _feedbackHaptico = true;

  // Getters
  double get tamanhoFonte => _tamanhoFonte;
  bool get altoContraste => _altoContraste;
  bool get leitorTela => _leitorTela;
  bool get animacoesReduzidas => _animacoesReduzidas;
  bool get feedbackHaptico => _feedbackHaptico;

  // Setters
  void setTamanhoFonte(double tamanho) {
    _tamanhoFonte = tamanho.clamp(0.8, 2.0);
  }

  void setAltoContraste(bool ativo) {
    _altoContraste = ativo;
  }

  void setLeitorTela(bool ativo) {
    _leitorTela = ativo;
  }

  void setAnimacoesReduzidas(bool ativo) {
    _animacoesReduzidas = ativo;
  }

  void setFeedbackHaptico(bool ativo) {
    _feedbackHaptico = ativo;
  }

  // Aplicar configurações ao tema
  ThemeData aplicarAcessibilidadeAoTheme(ThemeData temaBase) {
    return temaBase.copyWith(
      textTheme: temaBase.textTheme.apply(
        fontSizeFactor: _tamanhoFonte,
      ),
      colorScheme: _altoContraste
          ? temaBase.colorScheme.copyWith(
              primary: Colors.black,
              secondary: Colors.white,
              surface: Colors.white,
              background: Colors.black,
              onPrimary: Colors.white,
              onSecondary: Colors.black,
              onSurface: Colors.black,
              onBackground: Colors.white,
            )
          : temaBase.colorScheme,
      // Reduzir animações se solicitado
      pageTransitionsTheme: _animacoesReduzidas
          ? PageTransitionsTheme(
              builders: {
                TargetPlatform.android: ZoomPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            )
          : temaBase.pageTransitionsTheme,
    );
  }

  // Gerar texto semântico para leitores de tela
  String gerarDescricaoSemantica(String texto, {String? contexto}) {
    if (!_leitorTela) return texto;

    final descricao = StringBuffer();
    if (contexto != null) {
      descricao.write('$contexto: ');
    }
    descricao.write(texto);

    return descricao.toString();
  }

  // Verificar se é necessário alto contraste
  bool precisaAltoContraste(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return _altoContraste || brightness == Brightness.low;
  }
}