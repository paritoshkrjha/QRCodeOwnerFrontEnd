import 'package:flutter/material.dart';

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
      decoration: BoxDecoration(
        color: const Color(0xfff5f6f7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        trailing: const Icon(Icons.arrow_circle_right),
        leading: const Icon(
          Icons.car_crash,
        ),
        title: Text(desc),
        subtitle: const Text('15.09.23'),
        onTap: openDetailOverlay,
      ),
    );
  }
}
