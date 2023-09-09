import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xfff5f6f7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const ListTile(
        title: Text(
          "Your car is being towed",
          style:
              TextStyle(color: Color(0xff0f2138), fontWeight: FontWeight.bold),
        ),
        leading: Icon(
          FontAwesomeIcons.car,
          color: Color(0xff0f2138),
        ),
        subtitle: Row(
          children: [
            Text(
              '05.09.23',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
