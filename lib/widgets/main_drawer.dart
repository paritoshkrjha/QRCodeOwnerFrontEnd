import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:owner_front/models/current_user.dart';

import '../screens/emergency_contact.dart';

class MainDrawer extends StatelessWidget {
  final CurrentUser currentUser;
  const MainDrawer(
      {super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  currentUser.userName,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff343d48)),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: ListTile(
              leading: const Icon(
                Icons.emergency,
                size: 26,
                color: Colors.black,
              ),
              title: Text(
                'Emergency Contact',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 18),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EmergencyContactsScreen(
                          currentUser: currentUser,
                        )));
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListTile(
              leading: const Icon(
                Icons.logout,
                size: 26,
                color: Colors.black,
              ),
              title: Text(
                'Sign out',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 18),
              ),
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ),
        ],
      ),
    );
  }
}
