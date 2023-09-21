import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String username;
  const UserCard({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff0f2138),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5.0,
            spreadRadius: 2.0,
            offset: const Offset(0.0, 2.0),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, $username !',
            style:const TextStyle(
                fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
          ),
          const SizedBox(height: 5),
          const Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elite.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          )
        ],
      ),
    );
  }
}
