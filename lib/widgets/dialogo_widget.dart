import 'package:flutter/material.dart';

class DialogoWidget extends StatelessWidget {
  DialogoWidget({
    Key? key,
    required this.titulo,
    required this.mensaje,
  }) : super(key: key);

  final String titulo;
  final String mensaje;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('$titulo'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[Text('$mensaje')],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'Continuar',
            style: TextStyle(color: Color.fromRGBO(0, 45, 183, 1)),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
