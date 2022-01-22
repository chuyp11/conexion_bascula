import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:guud_app/widgets/texto_error_widget.dart';
import 'package:location/location.dart';
import 'dart:io' show Platform;

class TarjetaPermisoWidget extends StatefulWidget {
  TarjetaPermisoWidget({Key? key}) : super(key: key);

  @override
  _TarjetaPermisoWidgetState createState() => _TarjetaPermisoWidgetState();
}

class _TarjetaPermisoWidgetState extends State<TarjetaPermisoWidget> {
  Location location = new Location();

  PermissionStatus? permisoStatus;
  BluetoothState? estadoBluetooth;

  @override
  Widget build(BuildContext context) {
    return (permisoStatus == PermissionStatus.granted &&
            estadoBluetooth == BluetoothState.on)
        ? Container()
        : Container(
            width: 320,
            padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),

            // decoration: BoxDecoration(
            //   border: Border.all(
            //     width: 1.0,
            //     color: Color.fromRGBO(230, 230, 230, 1),
            //   ),
            //   borderRadius: BorderRadius.all(Radius.circular(8)),
            //   color: Color.fromRGBO(230, 230, 230, 1),
            // ),

            child: Column(
              children: [
                _bluetooth(),
                (Platform.isAndroid) ? _gps() : Container(),
              ],
            ),
          );
  }

  Widget _bluetooth() {
    return StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (c, snapshot) {
          estadoBluetooth = snapshot.data;
          if (estadoBluetooth == BluetoothState.on) {
            return Container();
          }
          return Container(
              // color: Colors.red,
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 12),
              child: Text(
                'Es necesario encender el Bluetooth',
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 14,
                  color: Color.fromRGBO(112, 112, 112, 1),
                ),
                textAlign: TextAlign.center,
              ));
        });
  }

  Widget _gps() {
    return FutureBuilder<bool>(
      future: location.serviceEnabled(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!) {
            return FutureBuilder<PermissionStatus>(
                future: location.hasPermission(),
                builder: (BuildContext context,
                    AsyncSnapshot<PermissionStatus> snapshot) {
                  if (snapshot.hasData) {
                    permisoStatus = snapshot.data;
                    if (permisoStatus == PermissionStatus.granted) {
                      return Container();
                    } else {
                      return tarjetaPermisoLocalizacion();
                    }
                  } else if (snapshot.hasError) {
                    return TextoErrorWidget();
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                });
          } else {
            return tarjetaHabilitarGps();
          }
        } else if (snapshot.hasError) {
          return tarjetaPermisoLocalizacion();
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget tarjetaPermisoLocalizacion() {
    return Container(
      // padding: EdgeInsets.fromLTRB(16, 8, 16, 8),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            // padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: Text(
              'Es necesario que permita acceder a la ubicacion del dispositivo para poder continuar',
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 14,
                color: Color.fromRGBO(112, 112, 112, 1),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            // height: 50,
            width: 230,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 8),

            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 4,
                primary: Color.fromRGBO(120, 217, 7, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              onPressed: () => {permisoLocalizacion()},
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  'Permitir acceder a ubicacion',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 16,
                    fontFamily: 'Oswald',
                  ),
                ),
              ]),
            ),
          ),
          // Container(
          //     margin: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          //     child: OutlinedButton(
          //       onPressed: () => permisoLocalizacion(),
          //       child: Text(
          //         'Permitir acceder a ubicacion',
          //         style: TextStyle(color: Color.fromRGBO(0, 45, 183, 1)),
          //       ),
          //     )),
        ],
      ),
    );
  }

  permisoLocalizacion() async {
    PermissionStatus permisoStatus = await location.requestPermission();
    if (permisoStatus == PermissionStatus.granted) {
      setState(() {});
    }
  }

  Widget tarjetaHabilitarGps() {
    return Container(
      // padding: EdgeInsets.fromLTRB(16, 8, 16, 8),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            // padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: Text(
              'Es necesario habilitar el GPS para poder continuar, no se guarda la localización pero es necesario para poder buscar dispositivos Bluetooth',
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 14,
                color: Color.fromRGBO(112, 112, 112, 1),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            // height: 50,
            width: 150,
            // color: Colors.red,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 8),

            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 4,
                primary: Color.fromRGBO(120, 217, 7, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              onPressed: () => {habilitarGps()},
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  'Habilitar GPS',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 16,
                    fontFamily: 'Oswald',
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  habilitarGps() async {
    bool habilitado = await location.requestService();
    if (habilitado) {
      setState(() {});
    }
  }
}
