import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class QrCodeGenerator extends StatefulWidget {
  const QrCodeGenerator({super.key});

  @override
  State<QrCodeGenerator> createState() => _QrCodeGeneratorState();
}

class _QrCodeGeneratorState extends State<QrCodeGenerator> {
  PermissionStatus _storagePermissonStatus = PermissionStatus.denied;
  final ScreenshotController _screenshotController = ScreenshotController();

  void requestStoragePermissions() async {
    await Permission.manageExternalStorage
        .request()
        .then((PermissionStatus status) => {
              setState(() {
                _storagePermissonStatus = status;
              })
            });
  }

  void _notifyUserWithSnackBar(String message, int milliseconds) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(milliseconds: milliseconds),
      ),
    );
  }

  void _shareQrCode() {
    requestStoragePermissions();
    if (_storagePermissonStatus.isGranted) {
      _screenshotController.capture().then((Uint8List? qrCodeImage) async {
        if (qrCodeImage != null) {
          final String captureTimestamp = DateTime.now().toString();
          await ImageGallerySaver.saveImage(
            Uint8List.fromList(qrCodeImage),
            quality: 100,
            name: captureTimestamp,
          );
          _notifyUserWithSnackBar('QR Code saved in your gallery!', 1500);
        }
      });
    } else if (_storagePermissonStatus.isPermanentlyDenied) {
      _notifyUserWithSnackBar(
          'Please grant storage permission to save QR codes', 1500);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your QR Code',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Screenshot(
              controller: _screenshotController,
              child: QrImageView(
                data:
                    'https://otp-auth-48162.web.app?userId=${FirebaseAuth.instance.currentUser!.uid}',
                version: QrVersions.auto,
                size: 250.0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            ElevatedButton(
              style: const ButtonStyle(
                  maximumSize: MaterialStatePropertyAll(Size.fromWidth(250)),
                  backgroundColor: MaterialStatePropertyAll(
                    Color(0xff0f2138),
                  ),
                  foregroundColor: MaterialStatePropertyAll(Colors.white)),
              onPressed: _shareQrCode,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Export QR')],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
