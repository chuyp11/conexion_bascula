import 'package:flutter/material.dart';
import 'package:guud_app/screens/bascula_datos/bloc/bascula_datos_bloc.dart';
import 'package:guud_app/screens/bascula_datos/widgets/obtener_datos_bascula_widget.dart';
import 'package:guud_app/screens/bascula_datos/widgets/sincronizar_bascula_widget.dart';
import 'package:guud_app/screens/bascula_datos/widgets/tarjeta_permisos_widget.dart';
import 'package:guud_app/widgets/loading_circular_progress_widget.dart';

class BasculaDatosScreen extends StatefulWidget {
  BasculaDatosScreen({
    Key? key,
  }) : super(key: key);

  @override
  _BasculaDatosScreenState createState() => _BasculaDatosScreenState();
}

class _BasculaDatosScreenState extends State<BasculaDatosScreen> {
  late BasculaDatosBloc _basculaDatosBloc;

  @override
  initState() {
    super.initState();
    _basculaDatosBloc = BasculaDatosBloc();
  }

  @override
  void dispose() {
    _basculaDatosBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: LoadingCircularProgressWidget(
        streamMostrarCircularProgress:
            _basculaDatosBloc.mostrarCircularProgress,
        child: Stack(
          children: [
            Container(
              color: Colors.white,
              height: double.infinity,
              width: double.infinity,
            ),
            SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        TarjetaPermisoWidget(),
                        _body(),
                      ],
                    ))),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 50,
                  height: 50,
                  child: Icon(Icons.close,
                      size: 30, color: Color.fromRGBO(128, 128, 128, 1)),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _body() {
    return StreamBuilder<String>(
        stream: _basculaDatosBloc.direccionMAC,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          String direccionMac = '';

          if (snapshot.hasData) {
            direccionMac = snapshot.data!;
          }

          if (direccionMac.length == 17) {
            return ObtenerDatosBasculaWidget(
              basculaDatosBloc: _basculaDatosBloc,
              guardarMedicion: (String nada) {},
            );
          } else {
            return SincronizarBasculaWidget(
              basculaDatosBloc: _basculaDatosBloc,
              clickEnlazar: (String mac) {},
            );
          }
        });
  }
}
