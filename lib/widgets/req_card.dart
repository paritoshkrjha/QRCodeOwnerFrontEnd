import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants/category.dart';

class RequestCard extends StatelessWidget {
  final Function() openDetailOverlay;
  final String category;
  final String desc;
  final String requestCall;
  const RequestCard({
    super.key,
    required this.desc,
    required this.category,
    required this.requestCall,
    required this.openDetailOverlay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xfff5f6f7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade200, // Set the border color here
          width: 2.0, // Set the border width
        ),
      ),
      child: ListTile(
        trailing: const Icon(
          FontAwesomeIcons.angleRight,
          size: 12,
        ),
        leading: const Icon(
          Icons.car_crash,
        ),
        title: Text(
          kCategoryOptions[category]!,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14),
        ),
        subtitle: const Text('15.09.23'),
        onTap: openDetailOverlay,
      ),
    );
  }
}
