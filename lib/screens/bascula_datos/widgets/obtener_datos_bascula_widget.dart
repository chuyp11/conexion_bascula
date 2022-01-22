import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:guud_app/models/body_parameter_model.dart';
import 'package:guud_app/models/datos_bascula_model.dart';
import 'package:guud_app/models/get_access_token_model.dart';
import 'package:guud_app/screens/bascula_datos/bloc/bascula_datos_bloc.dart';
import 'package:guud_app/screens/bascula_datos/utility/api.dart';
import 'package:guud_app/screens/bascula_datos/utility/bascula_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ObtenerDatosBasculaWidget extends StatefulWidget {
  ObtenerDatosBasculaWidget({
    Key? key,
    required this.basculaDatosBloc,
    required this.guardarMedicion,
  }) : super(key: key);

  final BasculaDatosBloc basculaDatosBloc;
  final ValueChanged<String> guardarMedicion;

  @override
  _ObtenerDatosBasculaWidgetState createState() =>
      _ObtenerDatosBasculaWidgetState();
}

class _ObtenerDatosBasculaWidgetState extends State<ObtenerDatosBasculaWidget> {
  String _direccionMac = '';

  BodyParameter bodyParameter = BodyParameter();

  String mediciones = '';

  @override
  initState() {
    super.initState();
    _direccionMac = widget.basculaDatosBloc.direccionMACValue!;
    // FlutterBlue.instance.startScan();
    // FlutterBlue.instance.startScan(timeout: Duration(seconds: 20), allowDuplicates: true);
    FlutterBlue.instance.startScan(allowDuplicates: true);
  }

  @override
  void dispose() {
    FlutterBlue.instance.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      child: Column(
        children: [
          _texto(),
          _mediciones(),
          _listaScanResult(),
          _isScanning(),
        ],
      ),
    );
  }

  Widget _mediciones() {
    return StreamBuilder(
      stream: widget.basculaDatosBloc.datosBasculaModel,
      builder:
          (BuildContext context, AsyncSnapshot<DatosBasculaModel?> snapshot) {
        DatosBasculaModel datos = DatosBasculaModel();
        if (snapshot.hasData) {
          datos = snapshot.data!;
        }
        return Column(
          children: [
            Text('age: ' + datos.age.toString()),
            Text('bmi: ' + datos.bmi.toString()),
            Text('bmr: ' + datos.bmr.toString()),
            Text('bodyAge: ' + datos.bodyAge.toString()),
            Text('bodyScore: ' + datos.bodyScore.toString()),
            Text('bodyType: ' + datos.bodyType.toString()),
            Text('boneKg: ' + datos.boneKg.toString()),
            Text('boneRate: ' + datos.boneRate.toString()),
            Text('controlFatKg: ' + datos.controlFatKg.toString()),
            Text('controlMuscleKg: ' + datos.controlMuscleKg.toString()),
            Text('controlWeight: ' + datos.controlWeight.toString()),
            Text('fatKg: ' + datos.fatKg.toString()),
            Text('fatRate: ' + datos.fatRate.toString()),
            Text('healthLevel: ' + datos.healthLevel.toString()),
            Text('height: ' + datos.height.toString()),
            Text('impedance: ' + datos.impedance.toString()),
            Text('impedanceStatus: ' + datos.impedanceStatus.toString()),
            Text('mac: ' + datos.mac.toString()),
            Text('muscleKg: ' + datos.muscleKg.toString()),
            Text('muscleRate: ' + datos.muscleRate.toString()),
            Text('notFatWeight: ' + datos.notFatWeight.toString()),
            Text('obesityLevel: ' + datos.obesityLevel.toString()),
            Text(
                'proteinPercentageKg: ' + datos.proteinPercentageKg.toString()),
            Text('proteinPercentageRate: ' +
                datos.proteinPercentageRate.toString()),
            Text('sex: ' + datos.sex.toString()),
            Text('standardWeight: ' + datos.standardWeight.toString()),
            Text('subcutaneousFatKg: ' + datos.subcutaneousFatKg.toString()),
            Text(
                'subcutaneousFatRate: ' + datos.subcutaneousFatRate.toString()),
            Text('visceralFat: ' + datos.visceralFat.toString()),
            Text('visceralFatKg: ' + datos.visceralFatKg.toString()),
            Text('waterKg: ' + datos.waterKg.toString()),
            Text('waterRate: ' + datos.waterRate.toString()),
            Text('weight: ' + datos.weight.toString()),
          ],
        );
      },
    );
  }

  Widget _texto() {
    return Container(
      width: 320,
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.fromLTRB(0, 12, 0, 54),
      // decoration: BoxDecoration(
      //   border: Border.all(
      //     width: 1.0,
      //     color: Color.fromRGBO(230, 230, 230, 1),
      //   ),
      //   borderRadius: BorderRadius.all(Radius.circular(8)),
      //   color: Color.fromRGBO(230, 230, 230, 1),
      // ),
      child: Text(
        // 'Súbete a la báscula para sincronizar',
        'Medición en curso, por favor mantente en la báscula',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'OpenSans',
          fontSize: 20,
          color: Color.fromRGBO(112, 112, 112, 1),
        ),
      ),
    );
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
                  String direccionMac = '';
                  for (var i = 0; i < 6; i++) {
                    direccionMac =
                        '$direccionMac${bytes[i + 7].toRadixString(16).padLeft(2, '0').toUpperCase()}';
                    if (i < 5) {
                      direccionMac = '$direccionMac:';
                    }
                  }
                  print('direccionMac: $direccionMac');

                  if (_direccionMac == direccionMac) {
                    int serialNumber = id;
                    print('serial number: $serialNumber');

                    bool lockingData = (BasculaUtils().getBit(
                            ByteData.sublistView(listaBytes, 6, 7), 0) ==
                        1);

                    (lockingData)
                        ? print('locking Data')
                        : print('Non-lockingData');

                    int decimal = BasculaUtils().getDecimal(BasculaUtils()
                        .getTwoBit(
                            ByteData.sublistView(listaBytes, 6, 7), 5, 7));
                    print('decimal: $decimal');

                    double weight =
                        BasculaUtils().getWeight(listaBytes, decimal);

                    int impedance = (ByteData.sublistView(listaBytes, 2, 3)
                                    .getUint8(0) &
                                0xff) *
                            256 +
                        (ByteData.sublistView(listaBytes, 3, 4).getUint8(0) &
                            0xff);
                    print('impedance: $impedance');

                    if (weight > 0 && impedance > 0) {
                      widget.basculaDatosBloc.mostrarCircularProgressNext(true);

                      FlutterBlue.instance.stopScan();
                      print('aaaaaaaaaaaaaaaaaaaaaaaaaaaa');

                      // SharedPreferences prefs =
                      //     await SharedPreferences.getInstance();
                      // final String? correo = prefs.getString(CORREO);

                      // bodyParameter.loginAccount = 'email@163.com';
                      // bodyParameter.thirdUserNo  = 1000.toString();
                      // bodyParameter.thirdNickName = 'test';
                      // bodyParameter.height = 169.toString();
                      // bodyParameter.age = 27.toString();
                      // bodyParameter.sex = 1.toString();
                      bodyParameter.loginAccount = 'email@163.com';
                      bodyParameter.thirdUserNo = 1000.toString();
                      bodyParameter.thirdNickName = 'nombre';
                      bodyParameter.height = '175';
                      bodyParameter.age = '25';
                      bodyParameter.sex = '1';
                      bodyParameter.mac = result.device.id.toString();
                      bodyParameter.weight = weight.toString();
                      bodyParameter.impedance = impedance.toString();

                      GetAccessToken getAccessToken = GetAccessToken();

                      getAccessToken.appid = 'd82a7485030fe83b0d955f4792f0ce04';
                      getAccessToken.secret =
                          'XenwE4VpZxRX0xMfSiqCkdKgzzPq0JGUSFCEzXv0pvMzfBzg5gS91vKyL3fAXj4Q';

                      String accessToken = '';

                      await Api.instance
                          .accessToken(getAccessToken)
                          .then((http.Response response) async {
                        final Map<String, dynamic> parsedJson =
                            convert.jsonDecode(response.body);
                        print(parsedJson.toString());

                        int code = (parsedJson['code'] != null)
                            ? parsedJson['code']
                            : -1;

                        if (code == 1000) {
                          accessToken =
                              (parsedJson['data']['accessToken'] != null)
                                  ? parsedJson['data']['accessToken']
                                  : '';
                        }
                      }).catchError((error) {
                        print('error' + error.toString());
                        throw error;
                      }).whenComplete(() {});

                      if (accessToken.length > 0) {
                        await Api.instance
                            .bodyParameter(bodyParameter, accessToken)
                            .then((http.Response response) async {
                          final Map<String, dynamic> parsedJson =
                              convert.jsonDecode(response.body);
                          print(parsedJson.toString());

                          DatosBasculaModel datosBasculaModel =
                              DatosBasculaModel.fromJson(parsedJson['data']);

                          datosBasculaModel.age = 25;
                          datosBasculaModel.sex = 1;
                          datosBasculaModel.mac = result.device.id.toString();
                          datosBasculaModel.impedance = impedance;
                          datosBasculaModel.height = 175;

                          // widget.inicioBloc.datosBasculaModelNext(datosBasculaModel);

                          // widget.inicioBloc.indexBottomBarNext(0);

                          widget.basculaDatosBloc
                              .datosBasculaModelNext(datosBasculaModel);

                          widget.guardarMedicion('');
                        }).catchError((error) {
                          print('error' + error.toString());
                          throw error;
                        }).whenComplete(() {});
                      }

                      widget.basculaDatosBloc
                          .mostrarCircularProgressNext(false);
                    } else {
                      // FlutterBlue.instance.stopScan();
                      // FlutterBlue.instance.startScan();
                    }
                  }
                }
              });
            });
          }

          return Container();
        });
  }

  Widget _isScanning() {
    return StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!) {
              print('SI Scanning');
            } else {
              print('NO Scanning');
            }
          }
          return Container();
        });
  }
}
