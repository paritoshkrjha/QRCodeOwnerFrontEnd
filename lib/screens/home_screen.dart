import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:owner_front/screens/qrcode_screen.dart';
import 'package:owner_front/widgets/main_drawer.dart';
import 'package:owner_front/widgets/req_list.dart';

FirebaseFirestore database = FirebaseFirestore.instance;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String username = "";
  String? userFcmToken = "";
  Map<String, dynamic> userData = {'name': 'User'};

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

  void getUserDetails() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
      (DocumentSnapshot doc) {
        userData = doc.data() as Map<String, dynamic>;
      },
      onError: (e) => print('Error : $e'),
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setUpPushNotification();
    getUserDetails();
    // print('user : ${FirebaseAuth.instance.currentUser!.uid}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(userName: userData['name']),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'QR-Owner',
        ),
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
          const Expanded(child: RequestList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const QrCodeGenerator()));
        },
        child: const Icon(
          Icons.qr_code,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
