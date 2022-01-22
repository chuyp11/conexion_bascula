import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:guud_app/screens/bascula_datos/bloc/bascula_datos_bloc.dart';

import 'package:binary/binary.dart';
import 'package:guud_app/screens/bascula_datos/utility/bascula_utils.dart';

class SincronizarBasculaWidget extends StatefulWidget {
  SincronizarBasculaWidget({
    Key? key,
    required this.basculaDatosBloc,
    required this.clickEnlazar,
  }) : super(key: key);

  final BasculaDatosBloc basculaDatosBloc;
  // final VoidCallback clickEnlazar;
  final ValueChanged<String> clickEnlazar;

  @override
  _SincronizarBasculaWidgetState createState() =>
      _SincronizarBasculaWidgetState();
}

class _SincronizarBasculaWidgetState extends State<SincronizarBasculaWidget> {
  // "78:0A:B1:D1:32:1E"

  String _direccionMac = '';
  double _peso = 0;

  bool mostrarDialogoConfirmar = false;

  String unitSelection = '';

  final double libra = 2.20462;

  @override
  initState() {
    super.initState();
    FlutterBlue.instance.stopScan();
  }

  @override
  void dispose() {
    FlutterBlue.instance.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _inicio();
    // return (!mostrarDialogoConfirmar) ? Container(

    //   child: Column(
    //     children: [

    //       _imagenBascula(),
    //       _texto(),
    //       _botonContinuar(),

    //       _listaScanResult(),
    //       // _guardarDireccionMAC(),

    //     ],
    //   ),

    // )
    // :
    // _confirmarSincronizacion();
  }

  Widget _texto() {
    return Container(
      width: 200,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 24),
      child: Text(
        'Súbete a la báscula para sincronizar',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color.fromRGBO(112, 112, 112, 1),
          fontSize: 20,
          fontFamily: 'OpenSans',
        ),
      ),
    );
  }

  Widget _botonContinuar() {
    return Container(
      width: 320,
      height: 50,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 24),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color.fromRGBO(120, 217, 7, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        onPressed: () => {_clickSincronizar()},
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Container(
          //   width: 25,
          // ),
          Text(
            'Buscar Báscula',
            style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 1),
              fontSize: 24,
              fontFamily: 'Montserrat',
            ),
          ),
          // Container(
          //   width: 25,
          //   // color: Colors.red,
          //   child: Icon(
          //     Icons.east,
          //     size: 20,
          //   ),
          // ),
        ]),
      ),
    );
  }

  void _clickSincronizar() {
    _direccionMac = '';
    _peso = 0.0;
    // widget.basculaDatosBloc.mostrarCircularProgressNext(true);
    FlutterBlue.instance.stopScan();
    FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
    // FlutterBlue.instance.startScan(allowDuplicates: true);
  }

  Widget _listaScanResult() {
    List<ScanResult> lista = [];

    return StreamBuilder<List<ScanResult>>(
        stream: FlutterBlue.instance.scanResults,
        builder:
            (BuildContext context, AsyncSnapshot<List<ScanResult>> snapshot) {
          if (snapshot.hasData) {
            lista = snapshot.data!;

            lista.forEach((ScanResult result) {
              result.advertisementData.manufacturerData
                  .forEach((id, bytes) async {
                Uint8List listaBytes = Uint8List.fromList(bytes);

                if (bytes.length == 13) {
                  // String direccionMac1 = '${bytes[7].toRadixString(16).padLeft(2).toUpperCase()}';
                  // String direccionMac = '${bytes[7].toRadixString(16)}:${bytes[8].toRadixString(16)}:${bytes[9].toRadixString(16)}:${bytes[10].toRadixString(16)}:${bytes[11].toRadixString(16)}:${bytes[12].toRadixString(16)}';
                  FlutterBlue.instance.stopScan();

                  int decimal = BasculaUtils().getDecimal(BasculaUtils()
                      .getTwoBit(ByteData.sublistView(listaBytes, 6, 7), 5, 7));
                  print('decimal: $decimal');

                  _peso = BasculaUtils().getWeight(listaBytes, decimal);

                  int impedance =
                      (ByteData.sublistView(listaBytes, 2, 3).getUint8(0) &
                                  0xff) *
                              256 +
                          (ByteData.sublistView(listaBytes, 3, 4).getUint8(0) &
                              0xff);
                  print('impedance: $impedance');

                  if (_peso > 0 && impedance > 0) {
                    // widget.basculaDatosBloc.mostrarCircularProgressNext(true);
                    FlutterBlue.instance.stopScan();

                    unitSelection = BasculaUtils().getTwoBit(
                        ByteData.sublistView(listaBytes, 6, 7), 3, 5);

                    print('direccion MAC: ${result.device.id.toString()}');

                    String direccionMac = '';
                    for (var i = 0; i < 6; i++) {
                      direccionMac =
                          '$direccionMac${bytes[i + 7].toRadixString(16).padLeft(2, '0').toUpperCase()}';
                      if (i < 5) {
                        direccionMac = '$direccionMac:';
                      }
                    }
                    print('direccionMac: $direccionMac');
                    _direccionMac = direccionMac;
                    // _direccionMac = result.device.id.toString();
                    widget.basculaDatosBloc
                        .direccionMACNext(result.device.id.toString());
                  }
                }
              });
            });
          }

          return Container();
        });
  }

  Widget _inicio() {
    return StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!) {
              print('SI Scanning');
              return _sincronizar();
            } else {
              print('NO Scanning');
              // widget.basculaDatosBloc.mostrarCircularProgressNext(false);
              if (_direccionMac.length == 17) {
                print('Peso: $_peso');
                print('direccionMac: $_direccionMac');

                return _confirmarSincronizacion();
              } else {
                return _sincronizar();
              }
            }
          } else {
            return Container();
          }
        });
  }

  Widget _sincronizar() {
    return Container(
      child: Column(
        children: [
          _texto(),
          _botonContinuar(),

          _listaScanResult(),
          // _guardarDireccionMAC(),
        ],
      ),
    );
  }

  Widget _confirmarSincronizacion() {
    return Container(
      child: Column(
        children: [
          _pesoTexto(),
          _textoConfirmacion(),
          _botonEnlazar(),
          _buscarOtraVez(),
        ],
      ),
    );
  }

  Widget _pesoTexto() {
    String pesoTexto = '';
    if (unitSelection == '10') {
      pesoTexto = (_peso * libra).toStringAsFixed(2);
    } else {
      pesoTexto = _peso.toStringAsFixed(2);
    }
    return Container(
      width: 320,
      margin: EdgeInsets.fromLTRB(0, 54, 0, 16),
      alignment: Alignment.center,
      child: Text(
        pesoTexto,
        style: TextStyle(
          color: Color.fromRGBO(94, 235, 94, 1),
          fontSize: 60,
          fontFamily: 'Oswald',
        ),
      ),
    );
  }

  Widget _textoConfirmacion() {
    return Container(
      width: 320,
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.fromLTRB(0, 12, 0, 54),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: Color.fromRGBO(230, 230, 230, 1),
        ),
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Color.fromRGBO(230, 230, 230, 1),
      ),
      child: Text(
        'Para confirmar el enlace verifique que el valor mostrado en pantalla coincida con el valor mostrado en la báscula',
        style: TextStyle(
          fontFamily: 'OpenSans',
          fontSize: 16,
          color: Color.fromRGBO(112, 112, 112, 1),
        ),
      ),
    );
  }

  Widget _botonEnlazar() {
    return Container(
      width: 320,
      height: 40,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 24),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color.fromRGBO(120, 217, 7, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        onPressed: () {
          // widget.basculaDatosBloc.direccionMACNext(_direccionMac);
          widget.clickEnlazar(_direccionMac);
        },
        child: Text(
          'Sincroniza',
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
            fontSize: 16,
            fontFamily: 'Oswald',
          ),
        ),
      ),
    );
  }

  Widget _buscarOtraVez() {
    return Container(
      width: 320,
      height: 40,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 24),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color.fromRGBO(120, 217, 7, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        onPressed: () {
          _direccionMac = '';
          _peso = 0.0;
          // widget.basculaDatosBloc.mostrarCircularProgressNext(true);
          FlutterBlue.instance.stopScan();
          FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
          // FlutterBlue.instance.startScan(allowDuplicates: true);
        },
        child: Text(
          'Buscar báscula de nuevo',
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
            fontSize: 16,
            fontFamily: 'Oswald',
          ),
        ),
      ),
    );
  }
}
