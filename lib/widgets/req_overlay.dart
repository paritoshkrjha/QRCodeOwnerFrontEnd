import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestDetailsOverlay extends StatelessWidget {
  final String category, desc, requestCall, contactValue;

  const RequestDetailsOverlay(
      {super.key,
      required this.category,
      required this.desc,
      required this.requestCall,
      required this.contactValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Request Details',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.red.shade500,
              borderRadius: BorderRadius.circular(100)),
          child: Column(
            children: [
              Text(
                category,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          desc,
          style: const TextStyle(fontSize: 18),
        ),
        ButtonBar(
          alignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () async {
                final Uri url = Uri(
                  scheme: 'sms',
                  path: contactValue,
                );
                if (await (canLaunchUrl(url))) {
                  await launchUrl(url);
                } else {
                  print('cannot launch this uri');
                }
              },
              icon: const Icon(FontAwesomeIcons.message),
            ),
            IconButton(
              onPressed: () async {
                final Uri url = Uri(
                  scheme: 'tel',
                  path: contactValue,
                );
                if (await (canLaunchUrl(url))) {
                  await launchUrl(url);
                } else {
                  print('cannot launch this uri');
                }
              },
              icon: const Icon(Icons.phone),
              style: ButtonStyle(
                  iconColor: const MaterialStatePropertyAll(Colors.white),
                  iconSize: MaterialStateProperty.all(24),
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xff0f2138))),
            ),
          ],
        )
      ],
    );
  }
}
