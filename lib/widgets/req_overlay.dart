import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:owner_front/models/request_message.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/category.dart';

class RequestDetailsOverlay extends StatefulWidget {
  final RequestMessages requestMessage;
  final Function() onDelete;

  const RequestDetailsOverlay({
    super.key,
    required this.requestMessage,
    required this.onDelete,
  });

  @override
  State<RequestDetailsOverlay> createState() => _RequestDetailsOverlayState();
}

class _RequestDetailsOverlayState extends State<RequestDetailsOverlay> {
  bool isTextCopied = false;

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

    Widget customCopyContainer(String label, String value) {
      return InkWell(
        onTap: () {
          Clipboard.setData(ClipboardData(text: value)).then((_) {
            setState(() {
              isTextCopied = true;
            });
          }, onError: (e) => print(e));
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontWeight: FontWeight.bold),
                  ),
                  isTextCopied
                      ? const Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 14,
                        )
                      : const Icon(
                          Icons.copy_outlined,
                          size: 14,
                        ),
                ],
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
        ),
      );
    }

    onPressed(Uri uri) async {
      Uri url = uri;
      if (await (canLaunchUrl(url))) {
        await launchUrl(url);
      } else {
        // print('cannot launch this uri');
      }
    }

    launchMap() {
      MapsLauncher.launchCoordinates(
          double.parse(widget.requestMessage.coordinates.latitude),
          double.parse(widget.requestMessage.coordinates.longitude));
    }

    Widget customIconButton({
      required icon,
      required Color color,
      required Uri uri,
      required bool requestLaunchMap,
      required bool disabled,
    }) {
      return IconButton(
        onPressed: disabled
            ? null
            : () {
                requestLaunchMap ? launchMap() : onPressed(uri);
              },
        icon: icon,
        style: ButtonStyle(
          padding: const MaterialStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 25, vertical: 12),
          ),
          iconColor: const MaterialStatePropertyAll(Colors.white),
          iconSize: MaterialStateProperty.all(24),
          backgroundColor: MaterialStateProperty.all(
            color,
          ),
          shape: const MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text(
              'Request Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: widget.onDelete,
              style: const ButtonStyle(
                elevation: MaterialStatePropertyAll(10),
                backgroundColor: MaterialStatePropertyAll(Colors.white),
              ),
              icon: const Icon(Icons.delete),
            ),
          ]),
        ),
        Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            requestDetailItem(
                'Category', kCategoryOptions[widget.requestMessage.category]!),
            const SizedBox(height: 10),
            requestDetailItem('Description', widget.requestMessage.description),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: requestDetailItem(
                      'Callback',
                      widget.requestMessage.isCallRequested == 'true'
                          ? "Requested"
                          : "Not Requested"),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: customCopyContainer(
                      ' Contact', widget.requestMessage.contactNumber),
                )
              ],
            ),
          ],
        ),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            customIconButton(
              icon: const Icon(
                FontAwesomeIcons.locationDot,
                color: Colors.white,
              ),
              color: widget.requestMessage.coordinates.latitude == ''
                  ? Colors.red.shade300
                  : Colors.red,
              uri: Uri.parse(
                'https://www.google.com/maps/search/?api=1&query=${widget.requestMessage.coordinates.latitude},${widget.requestMessage.coordinates.longitude}',
              ),
              requestLaunchMap: true,
              disabled: widget.requestMessage.coordinates.latitude == '',
            ),
            customIconButton(
              icon: const Icon(FontAwesomeIcons.message),
              color: Theme.of(context).primaryColor,
              uri: Uri(
                scheme: 'sms',
                path: widget.requestMessage.contactNumber,
              ),
              requestLaunchMap: false,
              disabled: false,
            ),
            customIconButton(
              icon: const Icon(FontAwesomeIcons.whatsapp),
              color: Colors.green,
              uri: Uri.parse(
                  'https://wa.me/${widget.requestMessage.contactNumber}'),
              requestLaunchMap: false,
              disabled: false,
            ),
            customIconButton(
              icon: const Icon(FontAwesomeIcons.phone),
              color: const Color(0xff0f2138),
              uri: Uri(
                scheme: 'tel',
                path: widget.requestMessage.contactNumber,
              ),
              requestLaunchMap: false,
              disabled: false,
            ),
          ],
        ),
      ],
    );
  }
}
