import 'package:guud_app/models/datos_bascula_model.dart';
import 'package:rxdart/rxdart.dart';

class BasculaDatosBloc {
  final _mostrarCircularProgress = BehaviorSubject<bool>.seeded(false);

  final _direccionMAC = BehaviorSubject<String>();

  final _datosBasculaModel = BehaviorSubject<DatosBasculaModel>();

  //////////////////////////////////////////////////
  ///       mostrarCircularProgress
  //////////////////////////////////////////////////
  Stream<bool> get mostrarCircularProgress => _mostrarCircularProgress.stream;

  bool? get mostrarCircularProgressValue => _mostrarCircularProgress.value;

  mostrarCircularProgressNext(bool mostrarCircularProgress) {
    _mostrarCircularProgress.sink.add(mostrarCircularProgress);
  }

  //////////////////////////////////////////////////
  ///       direccionMAC
  //////////////////////////////////////////////////
  Stream<String> get direccionMAC => _direccionMAC.stream;

  String? get direccionMACValue => _direccionMAC.value;

  direccionMACNext(String direccionMAC) {
    _direccionMAC.sink.add(direccionMAC);
  }

  //////////////////////////////////////////////////
  ///       datosBasculaModel
  //////////////////////////////////////////////////
  Stream<DatosBasculaModel> get datosBasculaModel =>
      _datosBasculaModel.stream.asBroadcastStream();

  DatosBasculaModel? get datosBasculaModelValue => _datosBasculaModel.value;

  datosBasculaModelNext(DatosBasculaModel datosBasculaModel) {
    _datosBasculaModel.sink.add(datosBasculaModel);
  }

  dispose() {
    _mostrarCircularProgress.close();
    _direccionMAC.close();
    _datosBasculaModel.close();
  }
}
