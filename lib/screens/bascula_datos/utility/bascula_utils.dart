import 'dart:typed_data';
import 'package:binary/binary.dart';

class BasculaUtils {
  getBit(ByteData byte, int posicion) {
    int uno = byte.getUint8(0);
    // int ocho = byte.getUint8(8);
    return byte.getUint8(0) >> posicion & 0x01;
  }

  getTwoBit(ByteData byte, int i, int j) {
    String binary = byte.getUint8(0).toBinaryPadded(8);
    return binary.substring(i, j);
  }

  getDecimal(String s) {
    switch (s) {
      case "00":
        return 10;
      case "10":
        return 100;
      default:
        return 1;
    }
  }

  double getWeight(Uint8List listaBytes, int decimal) {
    String unitSelection =
        getTwoBit(ByteData.sublistView(listaBytes, 6, 7), 3, 5);
    print('unitSelection: $unitSelection');

    switch (unitSelection) {
      case '01':
        print('斤');
        double peso =
            (((ByteData.sublistView(listaBytes, 0, 1).getUint8(0) & 0xff) *
                            256 +
                        (ByteData.sublistView(listaBytes, 1, 2).getUint8(0) &
                            0xff)) /
                    decimal) /
                2;
        print('peso: $peso');
        return peso;
      case '10':
        print('lb');
        double peso =
            (((ByteData.sublistView(listaBytes, 0, 1).getUint8(0) & 0xff) *
                            256 +
                        (ByteData.sublistView(listaBytes, 1, 2).getUint8(0) &
                            0xff)) /
                    decimal) *
                0.4536;
        print('peso: $peso');
        return peso;
      case '11':
        print('st:lb');
        int st = (((ByteData.sublistView(listaBytes, 0, 1).getUint8(0) & 0xff) *
                        256 +
                    (ByteData.sublistView(listaBytes, 1, 2).getUint8(0) &
                        0xff)) ~/
                decimal)
            .toInt();
        double lb =
            ((ByteData.sublistView(listaBytes, 0, 1).getUint8(0) & 0xff) * 256 +
                        (ByteData.sublistView(listaBytes, 1, 2).getUint8(0) &
                            0xff)) /
                    decimal -
                st;
        print('peso: ${st * 6.3503 + lb * 0.4536}');
        return st * 6.3503 + lb * 0.4536;
      default:
        print('kg');
        double peso =
            ((ByteData.sublistView(listaBytes, 0, 1).getUint8(0) & 0xff) * 256 +
                    (ByteData.sublistView(listaBytes, 1, 2).getUint8(0) &
                        0xff)) /
                decimal;
        print('peso: $peso');
        return peso;
    }
  }
}
