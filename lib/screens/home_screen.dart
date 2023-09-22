import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:owner_front/screens/qrcode_screen.dart';
import 'package:owner_front/widgets/new_req_list.dart';
// import 'package:owner_front/widgets/user_card.dart';

FirebaseFirestore database = FirebaseFirestore.instance;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String username = "";
  String? userFcmToken = "";

  void setUpPushNotification() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    final token = await fcm.getToken();
    userFcmToken = token;
    database
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({'fcmToken': userFcmToken}, SetOptions(merge: true));
  }

  @override
  void initState() {
    super.initState();
    setUpPushNotification();
    // print('user : ${FirebaseAuth.instance.currentUser!.uid}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        backgroundColor: Color(0xfff8f8f8),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'QR-Owner',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.exit_to_app),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: const Text(
              "Requests",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const Expanded(child: NewRequestList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff0f2138),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const QrCodeGenerator()));
        },
        child: const Icon(
          Icons.qr_code,
          color: Colors.white,
        ),
      ),
    );
  }
}
