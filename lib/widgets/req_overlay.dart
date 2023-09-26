import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:owner_front/models/request_message.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/category.dart';

class RequestDetailsOverlay extends StatelessWidget {
  final RequestMessages requestMessage;

  const RequestDetailsOverlay({
    super.key,
    required this.requestMessage,
  });

  @override
  Widget build(BuildContext context) {
    Widget requestDetailItem(String label, String value) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                  color: Colors.black.withOpacity(0.8),
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(0.8),
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      );
    }

    Widget customIconButton(
        Icon icon, String scheme, Color color, bool isWhatsappIcon) {
      return IconButton(
        onPressed: () async {
          Uri url = Uri.parse('');
          if (isWhatsappIcon) {
            url = Uri.parse('https://wa.me/${requestMessage.contactNumber}');
          } else {
            url = Uri(
              scheme: scheme,
              path: requestMessage.contactNumber,
            );
          }

          if (await (canLaunchUrl(url))) {
            await launchUrl(url);
          } else {
            // print('cannot launch this uri');
          }
        },
        icon: icon,
        style: ButtonStyle(
            padding: const MaterialStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            ),
            iconColor: const MaterialStatePropertyAll(Colors.white),
            iconSize: MaterialStateProperty.all(24),
            backgroundColor: MaterialStateProperty.all(
              color,
            ),
            shape: const MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))))),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            'Request Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Column(
          children: [
            requestDetailItem(
                'Category', kCategoryOptions[requestMessage.category]!),
            const SizedBox(height: 10),
            requestDetailItem('Description', requestMessage.description),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: requestDetailItem(
                      'Callback',
                      requestMessage.isCallRequested == 'true'
                          ? "Requested"
                          : "Not Requested"),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: requestDetailItem(
                      'Sender\'s Contact', requestMessage.contactNumber),
                )
              ],
            ),
          ],
        ),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            customIconButton(const Icon(FontAwesomeIcons.message), 'tel',
                Theme.of(context).primaryColor, false),
            customIconButton(const Icon(FontAwesomeIcons.whatsapp), 'sms',
                Colors.green, true),
            customIconButton(
                const Icon(Icons.phone), 'tel', const Color(0xff0f2138), false),
          ],
        )
      ],
    );
  }
}
