import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeGenerator extends StatelessWidget {
  const QrCodeGenerator({super.key});

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
            QrImageView(
              data:
                  'https://otp-auth-48162.web.app?userId=${FirebaseAuth.instance.currentUser!.uid}',
              version: QrVersions.auto,
              size: 250.0,
            ),
          ],
        ),
      ),
    );
  }
}
