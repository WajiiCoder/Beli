import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BarcodeScannerScreen extends StatefulWidget {
  @override
  _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  String _scanResult = 'No result';

  @override
  void initState() {
    super.initState();
    // Start the barcode scan automatically when the screen is loaded
    startBarcodeScan();
  }

  Future<void> startBarcodeScan() async {
    try {
      final barcode = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", // The color of the cancel button
        "Cancel",  // The label of the cancel button
        true,      // Whether to show the flash icon
        ScanMode.BARCODE, // Scan mode (barcode or QR)
      );

      if (barcode != '-1') {
        setState(() {
          _scanResult = barcode;
        });
      }
    } catch (e) {
      setState(() {
        _scanResult = 'Failed to get scan result: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Scanner'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 32.0),
            Text(
              'Scan Result:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              _scanResult,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}