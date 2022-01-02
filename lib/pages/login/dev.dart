import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class DevelopmentQRScanner extends StatefulHookConsumerWidget {
  static const routename = '/login/qr';
  const DevelopmentQRScanner({Key? key}) : super(key: key);

  @override
  _DevelopmentQRScannerState createState() => _DevelopmentQRScannerState();
}

class _DevelopmentQRScannerState extends ConsumerState<DevelopmentQRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          LayoutBuilder(
            builder: (context, constraints) {
              final size = constraints.maxWidth * 0.9;
              return SizedBox(
                  width: size,
                  height: size,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ));
            },
          ),
          Center(
            child: (result != null)
                ? Text('Data: ${result!.code}')
                : const Text('Scan a code'),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
