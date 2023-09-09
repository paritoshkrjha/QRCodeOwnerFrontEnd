import 'package:flutter/material.dart';
import 'package:owner_front/components/req_card.dart';

class RequestList extends StatelessWidget {
  const RequestList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 200,
      child: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          return const RequestCard();
        },
      ),
    );
  }
}
