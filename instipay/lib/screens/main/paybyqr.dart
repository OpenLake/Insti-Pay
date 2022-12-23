import 'package:flutter/material.dart';
import 'package:instipay/screens/main/pay.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class PayQR extends StatefulWidget {
  const PayQR({Key? key}) : super(key: key);

  @override
  State<PayQR> createState() => _PayQRState();
}

class _PayQRState extends State<PayQR> {
  bool _screenOpened = false;
  MobileScannerController cameraController = MobileScannerController();
  void _detectedQR(barcode, args) {
    if (!_screenOpened) {
      final String code = barcode.rawValue ?? "---";
      debugPrint('Barcode found! $code');
      _screenOpened = true;
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Pay(id: code,)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Color(0xff300757),
        title: Text('Pay by QR'),
      ) ,
      body:Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Color(0xbb2C0354), Color(0x60A725B2)])),
        child: MobileScanner(
            allowDuplicates: false,
            controller: cameraController,
            onDetect: _detectedQR),

      ),
    );
  }
}
