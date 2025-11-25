import 'package:flutter/material.dart';

class GerenciadorAcessibilidade {
  static final GerenciadorAcessibilidade _instancia = GerenciadorAcessibilidade._interno();
  factory GerenciadorAcessibilidade() => _instancia;
  GerenciadorAcessibilidade._interno();

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
    print('🔧 Tamanho da fonte alterado para: ${(_tamanhoFonte * 100).toInt()}%');
  }

  void setAltoContraste(bool ativo) {
    _altoContraste = ativo;
    print('🔧 Alto contraste: ${ativo ? "ATIVADO" : "DESATIVADO"}');
  }

  void setLeitorTela(bool ativo) {
    _leitorTela = ativo;
    print('🔧 Leitor de tela: ${ativo ? "ATIVADO" : "DESATIVADO"}');
  }

  void setAnimacoesReduzidas(bool ativo) {
    _animacoesReduzidas = ativo;
    print('🔧 Animações reduzidas: ${ativo ? "ATIVADO" : "DESATIVADO"}');
  }

  void setFeedbackHaptico(bool ativo) {
    _feedbackHaptico = ativo;
    print('🔧 Feedback háptico: ${ativo ? "ATIVADO" : "DESATIVADO"}');
  }

  // Aplicar configurações ao texto
  TextStyle aplicarFonte(TextStyle estiloBase) {
    return estiloBase.copyWith(
      fontSize: estiloBase.fontSize != null ? estiloBase.fontSize! * _tamanhoFonte : null,
      color: _altoContraste ? Colors.black : estiloBase.color,
      fontWeight: _altoContraste ? FontWeight.bold : estiloBase.fontWeight,
    );
  }

  // Aplicar ao container
  BoxDecoration aplicarContraste(BoxDecoration decoracaoBase) {
    if (!_altoContraste) return decoracaoBase;
    
    return decoracaoBase.copyWith(
      color: Colors.white,
      border: Border.all(color: Colors.black, width: 2),
    );
  }

  // Vibrar
  void vibrar() {
    if (_feedbackHaptico) {
      print('📳 Vibração simulada');
    }
  }
}