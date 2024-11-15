import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:vendor_mate/Constants/user_status.dart';
import 'package:vendor_mate/widgets/loader.dart';
import 'package:vendor_mate/widgets/snack_bar.dart';

class GenerateQRCodeScreen extends StatefulWidget {
  @override
  _GenerateQRCodeScreenState createState() => _GenerateQRCodeScreenState();
}

class _GenerateQRCodeScreenState extends State<GenerateQRCodeScreen> {
  final GlobalKey _qrKey = GlobalKey();
  bool _isGenerating = false;
  bool _isQRCodeGenerated = false;
  bool _isLoading = true; // New loading state
  String? _qrCodeUrl;

  @override
  void initState() {
    super.initState();
    _checkQRCodeExists();
  }

  // Check if the QR code already exists on the server
  Future<void> _checkQRCodeExists() async {
    try {
      final QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject('QRCodes'))
            ..whereEqualTo(
                'text', 'https://eclarios/belli.app/${UserStatus.vendorId}');
      final ParseResponse response = await query.query();

      if (response.success == true &&
          response.results != null &&
          response.results!.isNotEmpty) {
        final ParseObject qrCodeObject = response.results!.first as ParseObject;
        final ParseFileBase? qrFile = qrCodeObject.get<ParseFileBase>('file');

        if (qrFile != null) {
          setState(() {
            _isQRCodeGenerated = true;
            _qrCodeUrl = qrFile.url;
          });
        }
      } else {
        print(response.error?.message ??
            'No QR code found or failed to retrieve.');
      }
    } catch (e) {
      print("Error checking QR code existence: $e");
    } finally {
      setState(() {
        _isLoading = false; // Stop loading once check is complete
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate QR Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: _isLoading
              ? Loader() // Show loading indicator
              : _isQRCodeGenerated
                  ? _buildGeneratedQRCodeDisplay()
                  : _buildGenerateQRCodeSection(),
        ),
      ),
    );
  }

  // Widget to display existing QR code and message
  Widget _buildGeneratedQRCodeDisplay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RepaintBoundary(
          key: _qrKey,
          child: QrImageView(
            data: 'https://eclarios/belli.app/${UserStatus.vendorId}',
            size: 200.0,
          ),
        ),
        SizedBox(height: 20),
        Text(
          'This QR code is already registered with your store.',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Widget to display QR code generation button and loading state
  Widget _buildGenerateQRCodeSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Generate Your Store QR Code',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        _isGenerating
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _generateQRCode,
                child: Text('Generate QR Code'),
              ),
      ],
    );
  }

  Future<void> _generateQRCode() async {
    setState(() {
      _isGenerating = true;
      _isQRCodeGenerated = false;
    });

    try {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (_qrKey.currentContext != null) {
          RenderRepaintBoundary boundary = _qrKey.currentContext!
              .findRenderObject() as RenderRepaintBoundary;
          ui.Image image = await boundary.toImage();
          ByteData? byteData =
              await image.toByteData(format: ui.ImageByteFormat.png);
          Uint8List pngBytes = byteData!.buffer.asUint8List();

          final directory = await getApplicationDocumentsDirectory();
          final imagePath = '${directory.path}/qr_code.png';
          final imageFile = File(imagePath)..writeAsBytesSync(pngBytes);

          await _uploadQRCodeToBack4App(imageFile);
        } else {
          debugPrint("QR key's current context is still null.");
        }
      });
    } catch (e) {
      print('Error generating QR code: $e');
    } finally {
      setState(() {
        _isGenerating = false;
        _isQRCodeGenerated = true;
      });
    }
  }

  // Upload the generated QR code to Back4App server with details
  Future<void> _uploadQRCodeToBack4App(File qrImageFile) async {
    ParseFileBase qrFile = ParseFile(qrImageFile);
    final text = 'https://eclarios/belli.app/${UserStatus.vendorId}';

    final qrCodeObject = ParseObject('QRCodes')
      ..set('text', text)
      ..set('file', qrFile);

    final response = await qrCodeObject.save();

    if (response.success) {
      CustomSnackbar.show(context, "QR Code Generated Successfully");
    } else {
      CustomSnackbar.show(context, "Failed to Generate QR code");
    }
  }
}
