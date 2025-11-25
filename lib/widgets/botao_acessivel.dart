import 'package:flutter/material.dart';

class BotaoAcessivel extends StatelessWidget {
  final String descricao;
  final VoidCallback aoPressionar;
  final Widget filho;

  const BotaoAcessivel({
    super.key,
    required this.descricao,
    required this.aoPressionar,
    required this.filho,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: descricao,
      button: true,
      child: ElevatedButton(
        onPressed: aoPressionar,
        child: filho,
      ),
    );
  }
}
