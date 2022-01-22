import 'package:flutter/material.dart';

class TextoErrorWidget extends StatelessWidget {
  const TextoErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'Error al intentar obtener datos, intente de nuevo más tarde',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w700,
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.red[400],
      ),
      padding: EdgeInsets.all(16.0),
      width: 320.0,
    );
  }
}
